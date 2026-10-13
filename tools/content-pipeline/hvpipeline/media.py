"""ffmpeg / ImageMagick ile medya işlemleri (yalnızca yerel; ücretli servis çağrısı yok).

Kaynak: geçici kurgu.py v3 ve bolum_yardimci.py. D-001 kuralları:
- Ken Burns: 3 kat süper örnekleme + zoompan (çift piksele yuvarlanan scale takılır).
- Hız değişikliği önce ayrı dosyaya uygulanır; doldurma `apad=whole_dur=L, atrim=end=L`.
- Bu ffmpeg'de drawtext/subtitles yok: yazılar ImageMagick PNG + overlay.
- Komutlar liste argümanla çalıştırılır (zsh kelime bölme tuzağı yok).
"""

from __future__ import annotations

import array
import json
import os
import re
import subprocess
from pathlib import Path

FPS = 30
XFADE = 0.30          # çekimler arası geçiş (sn)
AOFF = 0.5            # çekim başında sesten önceki boşluk
TAIL = 0.55           # sesten sonraki kuyruk
GAP = 0.35            # birleşik replikler arası boşluk
TARGET_LUFS = -16.0
LIMIT_LINEAR = 0.84   # ≈ -1.5 dBFS
W, H = 1080, 1920
FONT_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
FONT_REG = "/System/Library/Fonts/Supplemental/Arial.ttf"
AI_LABEL = "Yapay zekâ ile üretilmiştir"

# H-054: uygulamanın varsayılan oynattığı hafif sürüm. 1080p dosyadan yeniden kodlanır (Ken Burns yeniden
# çizilmez); ses kopyalanır, böylece ses, süre ve senkron 1080p ile birebir aynı kalır.
RENDITION_720 = "720p"
RENDITION_1080 = "1080p"
R720_W, R720_H = 720, 1280
R720_CRF = 21            # çizim tarzı Ken Burns'te ~1,5–1,8 Mbps (2026-10-12 ölçümü, s02: 1,73 Mbps)
R720_MAXRATE = "2M"
R720_BUFSIZE = "4M"
R720_VERSION = "1"       # kodlama ayarı değişince önbellek anahtarı değişir
WEBP_QUALITY = 80


class MediaError(RuntimeError):
    pass


def run(cmd: list[str]) -> None:
    r = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if r.returncode:
        raise MediaError(f"komut başarısız: {' '.join(cmd[:6])} …\n{r.stderr.decode(errors='replace')[-800:]}")


def _tmp(out: Path) -> Path:
    """Önbellek dosyaları önce geçici adla yazılır, başarıda yeniden adlandırılır (yarım dosya kalmaz)."""
    out.parent.mkdir(parents=True, exist_ok=True)
    return out.with_name(out.stem + ".part" + out.suffix)


def probe_duration(path: Path) -> float:
    out = subprocess.check_output(["ffprobe", "-v", "error", "-show_entries", "format=duration",
                                   "-of", "csv=p=0", str(path)])
    return float(out.decode().strip())


def probe_streams(path: Path) -> list[dict]:
    out = subprocess.check_output(["ffprobe", "-v", "error", "-show_entries",
                                   "stream=codec_type,codec_name,width,height,duration,sample_rate,channels,pix_fmt,profile",
                                   "-of", "json", str(path)])
    return json.loads(out)["streams"]


def envelope(path: Path, rate: int = 8000, win: int = 80) -> list[float]:
    """Mono RMS zarfı; pencere 80 örnek @ 8 kHz = 10 ms (indeks × 0,01 = sn)."""
    raw = subprocess.check_output(["ffmpeg", "-loglevel", "error", "-i", str(path), "-ac", "1",
                                   "-ar", str(rate), "-f", "s16le", "-"])
    smp = array.array("h")
    smp.frombytes(raw[: len(raw) // 2 * 2])
    env = []
    for i in range(0, len(smp) - win, win):
        s = 0
        for x in smp[i:i + win]:
            s += x * x
        env.append((s / win) ** 0.5)
    return env


def onset_lead(path: Path, rel: float = 0.10) -> float:
    """İlk enerji başlangıcı (sn): zarfın en büyük değerinin %10'unu aşan ilk pencere."""
    env = envelope(path)
    if not env:
        return 0.0
    thr = rel * max(env)
    return next((i * 0.01 for i, v in enumerate(env) if v >= thr), 0.0)


def measure_onset(env: list[float], expected: float, before: float = 0.6, after: float = 0.8,
                  rel: float = 0.35) -> float | None:
    """Doğrulama (kurgu.py v3): beklenen başlangıç çevresinde yerel en büyüğün %35'ini aşan ilk an."""
    a = int(max(0.0, expected - before) * 100)
    b = int((expected + after) * 100)
    seg = env[a:b]
    if not seg:
        return None
    thr = rel * max(seg)
    if thr <= 0:
        return None
    return next(((a + i) / 100 for i, v in enumerate(seg) if v >= thr), None)


# --- ses -------------------------------------------------------------------------------------

def radio(src: Path, out: Path) -> Path:
    """Telsiz filtresi (bolum_yardimci.telsiz)."""
    if not out.exists():
        tmp = _tmp(out)
        run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(src), "-filter_complex",
             "[0:a]highpass=f=350,lowpass=f=3200,acompressor=threshold=-18dB:ratio=4,volume=1.4[s];"
             "anoisesrc=color=pink:amplitude=0.02:d=20:seed=7[n];[s][n]amix=inputs=2:duration=first:weights='1 0.6'",
             "-c:a", "libmp3lame", "-b:a", "128k", str(tmp)])
        tmp.replace(out)
    return out


def concat_audio(paths: list[Path], gap: float, out: Path) -> Path:
    """Replikleri her birinin ardına `gap` sn sessizlikle birleştirir (bolum_yardimci.grup)."""
    if out.exists():
        return out
    cmd = ["ffmpeg", "-y", "-loglevel", "error"]
    for p in paths:
        cmd += ["-i", str(p)]
    flt = "".join(f"[{i}:a]aresample=44100,aformat=channel_layouts=stereo,apad=pad_dur={gap}[p{i}];"
                  for i in range(len(paths)))
    flt += "".join(f"[p{i}]" for i in range(len(paths))) + f"concat=n={len(paths)}:v=0:a=1[a]"
    tmp = _tmp(out)
    run(cmd + ["-filter_complex", flt, "-map", "[a]", "-c:a", "pcm_s16le", str(tmp)])
    tmp.replace(out)
    return out


def tempo(src: Path, atempo: float, out: Path) -> Path:
    if not out.exists():
        tmp = _tmp(out)
        run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(src), "-af",
             f"aresample=44100,atempo={atempo}", "-ac", "2", "-c:a", "pcm_s16le", str(tmp)])
        tmp.replace(out)
    return out


def loudness(paths: list[Path]) -> dict:
    """Birleştirilmiş sesin tümleşik ölçümü (loudnorm ölçüm geçişi)."""
    cmd = ["ffmpeg", "-hide_banner", "-nostats"]
    for p in paths:
        cmd += ["-i", str(p)]
    flt = "".join(f"[{i}:a]aresample=44100,aformat=channel_layouts=stereo[a{i}];" for i in range(len(paths)))
    flt += "".join(f"[a{i}]" for i in range(len(paths))) + f"concat=n={len(paths)}:v=0:a=1,"
    flt += f"loudnorm=I={TARGET_LUFS}:TP=-1.5:LRA=11:print_format=json[o]"
    r = subprocess.run(cmd + ["-filter_complex", flt, "-map", "[o]", "-f", "null", "-"],
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if r.returncode:
        raise MediaError(r.stderr.decode(errors="replace")[-600:])
    m = re.search(r"\{[^{}]*\"input_i\"[^{}]*\}", r.stderr.decode(errors="replace"), re.S)
    if not m:
        raise MediaError("loudnorm çıktısı okunamadı")
    j = json.loads(m.group(0))
    return {"I": float(j["input_i"]), "TP": float(j["input_tp"]), "LRA": float(j["input_lra"])}


def gain_filter(gain_db: float) -> str:
    return (f"aresample=44100,aformat=channel_layouts=stereo,volume={gain_db:.2f}dB,"
            f"alimiter=limit={LIMIT_LINEAR}:level=disabled:latency=1")


def audio_clip(src: Path, gain_db: float, out: Path) -> Path:
    out.parent.mkdir(parents=True, exist_ok=True)
    run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(src), "-af", gain_filter(gain_db),
         "-c:a", "aac", "-b:a", "96k", "-movflags", "+faststart", str(out)])
    return out


# --- görüntü ---------------------------------------------------------------------------------

def _font(path: str) -> list[str]:
    return ["-font", path] if os.path.exists(path) else []


def sign_png(sign: dict, out: Path) -> Path:
    """Dünya içi yazı (tabela, not, saat): kurguda PNG olarak gömülür (K-03 istisnası)."""
    if out.exists():
        return out
    out.parent.mkdir(parents=True, exist_ok=True)
    style = sign.get("style", "caption")
    lines = sign["lines"]
    if style == "note":
        a = ["magick", "-size", f"{W}x{H}", "xc:rgba(10,20,30,0.78)", "-gravity", "center"] + _font(FONT_BOLD)
        y = -int(sum(int(ln.get("size", 60)) * 1.9 for ln in lines) / 2) + 40
        for ln in lines:
            ps = int(ln.get("size", 60))
            a += ["-pointsize", str(ps), "-fill", ln.get("color", "white"), "-annotate", f"+0{y:+d}", ln["text"]]
            y += int(ps * 1.9)
    else:
        text = "\n".join(ln["text"] for ln in lines)
        bg = "rgba(0,0,0,0.62)"
        a = ["magick", "-size", f"{W}x{H}", "xc:none", "(", "-background", bg, "-fill", "white"] + _font(FONT_BOLD)
        a += ["-pointsize", "58", "-size", "940x", "-gravity", "center", "caption:" + text,
              "-bordercolor", bg, "-border", "28", ")", "-gravity", "south", "-geometry", "+0+300", "-composite"]
    tmp = _tmp(out)
    run(a + [str(tmp)])
    tmp.replace(out)
    return out


def label_png(out: Path) -> Path:
    if not out.exists():
        out.parent.mkdir(parents=True, exist_ok=True)
        run(["magick", "-size", f"{W}x{H}", "xc:none"] + _font(FONT_REG) +
            ["-pointsize", "30", "-fill", "rgba(255,255,255,0.85)", "-gravity", "north",
             "-annotate", "+0+60", AI_LABEL, str(_tmp(out))])
        _tmp(out).replace(out)
    return out


def to_webp(src: Path, out: Path, quality: int = WEBP_QUALITY) -> Path:
    """Görseli WebP'ye çevirir (ImageMagick; H-054). Önce geçici adla yazılır."""
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = _tmp(out)
    run(["magick", str(src), "-strip", "-quality", str(quality), "-define", "webp:method=6", str(tmp)])
    tmp.replace(out)
    return out


def image_size(src: Path) -> tuple[int, int]:
    """Görselin piksel boyutu (ImageMagick)."""
    out = subprocess.check_output(["magick", "identify", "-format", "%w %h", str(src)]).decode().split()
    return int(out[0]), int(out[1])


def crop_webp(src: Path, box: tuple[int, int, int, int], out: Path, size: int = 512,
              quality: int = WEBP_QUALITY) -> Path:
    """Konu seti öğe görseli (H-051): `box` (x, y, w, h piksel) kırpılır, `size`×`size` WebP. Yazı eklenmez."""
    x, y, w, h = box
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = _tmp(out)
    run(["magick", str(src), "-crop", f"{w}x{h}+{x}+{y}", "+repage", "-resize", f"{size}x{size}!",
         "-strip", "-quality", str(quality), "-define", "webp:method=6", str(tmp)])
    tmp.replace(out)
    return out


def scene_webp(src: Path, out: Path, width: int = 1080, quality: int = WEBP_QUALITY) -> Path:
    """Sahne avı görseli (H-051): oran korunur, genişlik `width`, WebP. Yazı eklenmez."""
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = _tmp(out)
    run(["magick", str(src), "-resize", f"{width}x", "-strip", "-quality", str(quality),
         "-define", "webp:method=6", str(tmp)])
    tmp.replace(out)
    return out


def gain_to_target(src: Path) -> float:
    """Kaynağı -16 LUFS'a getiren kazanç (dB); konu seti ses kesitleri tam replikten ölçülür (kısa
    kesitte tümleşik ölçüm güvenilmez)."""
    return round(TARGET_LUFS - loudness([src])["I"], 2)


def cut_audio(src: Path, start: float, end: float | None, gain_db: float, out: Path) -> Path:
    """Kayıttan kelime ya da cümle kesiti (H-051): kazanç + sınırlayıcı, 15/30 ms yumuşak giriş/çıkış, AAC."""
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = _tmp(out)
    trim = ["-ss", f"{start:.3f}"] + (["-to", f"{end:.3f}"] if end is not None else [])
    length = (end - start) if end is not None else None
    fade = "afade=t=in:d=0.015" + (f",afade=t=out:st={max(0.0, length - 0.03):.3f}:d=0.03" if length else "")
    run(["ffmpeg", "-y", "-loglevel", "error"] + trim + ["-i", str(src), "-af", f"{gain_filter(gain_db)},{fade}",
         "-c:a", "aac", "-b:a", "96k", "-f", "mp4", "-movflags", "+faststart", str(tmp)])
    tmp.replace(out)
    return out


def still(image: Path, out: Path) -> Path:
    """9:16 durağan görsel (karar/kart/görev arka planı ya da videonun ilk karesi).

    Çıktı biçimi uzantıdan: `.webp` (H-054, varsayılan) ya da `.jpg`.
    """
    if not out.exists():
        out.parent.mkdir(parents=True, exist_ok=True)
        webp = out.suffix.lower() == ".webp"
        frame = out.with_name(out.stem + ".frame.png") if webp else _tmp(out)
        run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(image), "-vf",
             f"crop='min(iw,ih*9/16)':'min(ih,iw*16/9)',scale={W}:{H}:flags=lanczos,setsar=1",
             "-frames:v", "1"] + ([] if webp else ["-q:v", "3"]) + [str(frame)])
        if webp:
            to_webp(frame, out)
            frame.unlink(missing_ok=True)
        else:
            frame.replace(out)
    return out


def rendition_name(path: str, rendition: str = RENDITION_720) -> str:
    """`segments/s02.mp4` → `segments/s02.720p.mp4` (aynı klasör; şema deseni değişmez)."""
    stem, dot, ext = path.rpartition(".")
    return f"{stem}.{rendition}.{ext}" if dot else f"{path}.{rendition}"


def rendition_720(src: Path, out: Path) -> Path:
    """1080p son çıktıdan 720×1280 H.264 High yuv420p sürüm; ses kopyalanır, faststart (H-054).

    Kare sayısı ve zaman damgaları korunur (fps süzgeci yok): süre ve ses 1080p ile aynıdır.
    `-tune animation`: çizim tarzı düz alanlarda bantlaşmayı azaltır.
    """
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = _tmp(out)
    run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(src), "-map", "0:v:0", "-map", "0:a?",
         "-vf", f"scale={R720_W}:{R720_H}:flags=lanczos,setsar=1",
         "-c:v", "libx264", "-preset", "slow", "-tune", "animation", "-profile:v", "high",
         "-pix_fmt", "yuv420p", "-crf", str(R720_CRF), "-maxrate", R720_MAXRATE, "-bufsize", R720_BUFSIZE,
         "-g", "60", "-c:a", "copy", "-movflags", "+faststart", str(tmp)])
    tmp.replace(out)
    return out


def render_shot(shot: dict, out: Path, label: Path | None) -> Path:
    """Tek çekim: Ken Burns (ya da klip) + yazı katmanları + gecikmeli ses → ara .mov (PCM)."""
    if out.exists():
        return out
    out.parent.mkdir(parents=True, exist_ok=True)
    L = shot["len"]
    cmd = ["ffmpeg", "-y", "-loglevel", "error", "-i", str(shot["source"])]
    overlays = list(shot.get("overlays", []))
    for p, _, _ in overlays:
        cmd += ["-loop", "1", "-t", f"{L}", "-i", str(p)]
    if label:
        cmd += ["-loop", "1", "-t", f"{L}", "-i", str(label)]
    ai = None
    if shot.get("audio"):
        cmd += ["-i", str(shot["audio"])]
        ai = 1 + len(overlays) + (1 if label else 0)
    if shot.get("clip"):
        f = [f"[0:v]fps={FPS},scale=1090:-2,crop={W}:{H},setsar=1,tpad=stop_mode=clone:stop_duration=2,"
             f"trim=duration={L},setpts=PTS-STARTPTS[b0]"]
    else:
        n = int(round(L * FPS))
        z0, z1, px0, px1, py0, py1 = shot["move"]
        f = [f"[0:v]crop=1512:2688,scale={W * 3}:{H * 3},setsar=1,"
             f"zoompan=z='({z0}+({z1}-{z0})*on/{n})':x='(iw-iw/zoom)*({px0}+({px1}-{px0})*on/{n})':"
             f"y='(ih-ih/zoom)*({py0}+({py1}-{py0})*on/{n})':d={n}:s={W}x{H}:fps={FPS},trim=duration={L}[b0]"]
    last = "b0"
    for k, (_, a, b) in enumerate(overlays):
        f.append(f"[{last}][{k + 1}:v]overlay=0:0:enable='between(t,{a},{b})'[b{k + 1}]")
        last = f"b{k + 1}"
    if label:
        f.append(f"[{last}][{len(overlays) + 1}:v]overlay=0:0[bl]")
        last = "bl"
    f.append(f"[{last}]format=yuv420p[v]")
    if ai is not None:
        d = int(round(shot["aoff"] * 1000))
        f.append(f"[{ai}:a]aresample=44100,aformat=channel_layouts=stereo,adelay={d}|{d},"
                 f"apad=whole_dur={L},atrim=end={L},asetpts=N/SR/TB[a]")
    else:
        f.append(f"anullsrc=r=44100:cl=stereo,atrim=duration={L}[a]")
    cmd += ["-filter_complex", ";".join(f), "-map", "[v]", "-map", "[a]", "-c:v", "libx264", "-crf", "17",
            "-preset", "veryfast", "-c:a", "pcm_s16le", "-ar", "44100", "-ac", "2", "-t", f"{L}", str(_tmp(out))]
    run(cmd)
    _tmp(out).replace(out)
    return out


def join_shots(movs: list[Path], lens: list[float], out: Path) -> Path:
    """Çekimleri xfade/acrossfade ile birleştirir (segment ara dosyası, PCM ses)."""
    if out.exists():
        return out
    cmd = ["ffmpeg", "-y", "-loglevel", "error"]
    for m in movs:
        cmd += ["-i", str(m)]
    enc = ["-c:v", "libx264", "-crf", "21", "-preset", "medium", "-profile:v", "high", "-pix_fmt", "yuv420p",
           "-g", "60", "-c:a", "pcm_s16le", "-ar", "44100", "-ac", "2"]
    tmp = _tmp(out)
    if len(movs) == 1:
        run(cmd + ["-map", "0:v", "-map", "0:a"] + enc + [str(tmp)])
        tmp.replace(out)
        return out
    f, lv, la, acc = [], "0:v", "0:a", lens[0]
    for k in range(1, len(movs)):
        off = acc - XFADE
        f.append(f"[{lv}][{k}:v]xfade=transition=fade:duration={XFADE}:offset={off:.3f}[v{k}]")
        f.append(f"[{la}][{k}:a]acrossfade=d={XFADE}:c1=tri:c2=tri[a{k}]")
        lv, la, acc = f"v{k}", f"a{k}", acc + lens[k] - XFADE
    run(cmd + ["-filter_complex", ";".join(f), "-map", f"[{lv}]", "-map", f"[{la}]"] + enc + [str(tmp)])
    tmp.replace(out)
    return out


def finalize(mov: Path, gain_db: float, out: Path) -> Path:
    """Son çıktı: H.264 (kopya) + AAC, ses kazancı + sınırlayıcı, faststart."""
    out.parent.mkdir(parents=True, exist_ok=True)
    vd = next(float(s["duration"]) for s in probe_streams(mov) if s["codec_type"] == "video")
    # acrossfade sesi görüntüden bir kare kadar kısa bırakabilir: sona sessizlik eklenip görüntü süresine kırpılır.
    af = gain_filter(gain_db) + f",apad=whole_dur={vd:.4f},atrim=end={vd:.4f}"
    run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(mov), "-map", "0:v", "-map", "0:a", "-c:v", "copy",
         "-af", af, "-c:a", "aac", "-b:a", "128k", "-ar", "44100",
         "-movflags", "+faststart", str(out)])
    return out
