#!/usr/bin/env python3
"""Sezon 1 jeneriği yerel kurgusu (H-049).

Girdi (git dışı medya): A1-001 telsiz ışığı klibi, V1.mp4 (Seedance Mini), A1-001 telsiz sesi,
isteğe bağlı müzik dosyası (--muzik). Çıktı: _build/jenerik-tam.mp4 ve _build/jenerik-kisa.mp4; --baslik-arka ile
bölüm başlık ekranının yazısız arka planı _build/jenerik-baslik.mp4 (H-050).
Müzik yoksa geçici, sentetik yumuşak bir akor kullanılır.
"""
import argparse
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
B1 = ROOT / "icerik/A1-001-a-strange-message"
OUT = HERE / "_build"
FB = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
FR = "/System/Library/Fonts/Supplemental/Arial.ttf"

K_START, K_LEN = 0.0, 4.0      # telsiz klibinden alınan bölüm (ışık ~1,0 sn'de yanar)
XF = 0.35                      # geçiş süresi (D-001)
HOLD = 1.6                     # son karede bekleme
V1_LEN = 5.0
TOTAL = K_LEN + V1_LEN - XF + HOLD
TITLE_AT = TOTAL - HOLD - 0.3
SHORT = 2.0
TITLE_BG = 2.5                 # bölüm başlık ekranı arka planı (H-050): yazısız, 2,5 sn


def run(cmd):
    subprocess.run(cmd, check=True)


def overlays():
    OUT.mkdir(exist_ok=True)
    title = OUT / "baslik.png"
    run(["magick", "-size", "1080x1920", "xc:none",
         "-font", FB, "-pointsize", "150", "-fill", "rgba(0,0,0,0.35)", "-gravity", "north",
         "-annotate", "+4+344", "hiVelzon",
         "-fill", "white", "-annotate", "+0+340", "hiVelzon",
         "-font", FR, "-pointsize", "54", "-fill", "#F2B33D", "-annotate", "+0+530", "The Missing Signal",
         "-fill", "white", "-pointsize", "40", "-annotate", "+0+605", "Sezon 1",
         str(title)])
    label = OUT / "ai-etiket.png"
    run(["magick", "-size", "1080x1920", "xc:none", "-font", FR, "-pointsize", "28",
         "-fill", "rgba(255,255,255,0.75)", "-gravity", "south", "-annotate", "+0+90",
         "Yapay zekâ ile üretilmiştir", str(label)])
    return title, label


def normalize(path: Path, target: float = -16.0, _depth: int = 0):
    """İki adımlı ses seviyesi: ölç, kazancı uygula, tepe sınırla (D-001: -16 LUFS)."""
    out = subprocess.run(["ffmpeg", "-nostats", "-i", str(path), "-af", "ebur128", "-f", "null", "-"],
                         capture_output=True, text=True).stderr
    measured = float([l for l in out.splitlines() if l.strip().startswith("I:")][-1].split()[1])
    if abs(target - measured) < 0.3:
        return
    tmp = path.with_suffix(".tmp.mp4")
    run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(path), "-c:v", "copy",
         "-af", f"volume={target - measured:.2f}dB,alimiter=limit=0.84:level=0", "-c:a", "aac", "-b:a", "160k",
         "-movflags", "+faststart", str(tmp)])
    tmp.replace(path)
    if _depth < 3:  # sınırlayıcı ve AAC sonrası kalan farkı kapat
        normalize(path, target, _depth + 1)


def build(muzik: Path | None, etiket: bool = False, yazisiz: bool = False):
    """yazisiz=True: "hiVelzon / The Missing Signal / Sezon 1" yazısı gömülmez; yalnızca bölüm başlık
    ekranının arka planı (jenerik-baslik.mp4) üretilir. Bölüm adını uygulama kendisi çizer (H-050)."""
    title, label = overlays()
    k = B1 / "clips/K-isik-seedance-mini.mp4"
    v1 = HERE / "V1.mp4"
    voice = B1 / "audio/voice_01_telsiz.mp3"
    scale = "scale=1080:1920:flags=lanczos,fps=30,setsar=1,format=yuv420p"
    hide = ",colorchannelmixer=aa=0" if yazisiz else ""  # yazı katmanı tamamen saydam
    vf = (
        f"[0:v]trim={K_START}:{K_START + K_LEN},setpts=PTS-STARTPTS,{scale},"
        # yavaş yaklaşma: telsiz bölümü hiç durağan görünmesin
        f"scale=w='2*trunc(1080*(1+0.08*t/{K_LEN})/2)':h=-2:eval=frame,crop=1080:1920[a];"
        f"[1:v]trim=0:{V1_LEN},setpts=PTS-STARTPTS,{scale},tpad=stop_mode=clone:stop_duration={HOLD},"
        # son karede de hafif yaklaşma (donmuş kare yok)
        f"scale=w='2*trunc(1080*(1+0.06*max(0,t-{V1_LEN})/{HOLD})/2)':h=-2:eval=frame,crop=1080:1920[b];"
        f"[a][b]xfade=transition=fade:duration={XF}:offset={K_LEN - XF}[v];"
        f"[2:v]format=rgba,fade=t=in:st={TITLE_AT}:d=0.6:alpha=1{hide}[t];"
        f"[v][t]overlay=0:0:enable='gte(t,{TITLE_AT})'[v2];"
        + (f"[v2][3:v]overlay=0:0,trim=0:{TOTAL}[vout]" if etiket else f"[v2]trim=0:{TOTAL}[vout]")
    )
    # Ses: cızırtı + telsiz sesi (ilk 4 sn), ardından müzik.
    static = (f"anoisesrc=color=pink:amplitude=0.05:d={K_LEN + 0.5}:seed=3,"
              f"highpass=f=400,lowpass=f=3500,afade=t=out:st={K_LEN - 0.4}:d=0.8[st]")
    if muzik:
        music_in = ["-i", str(muzik)]
        mus = (f"[5:a]atrim=0:{TOTAL - K_LEN + 1.2},asetpts=PTS-STARTPTS,"
               f"afade=t=in:d=0.6,afade=t=out:st={TOTAL - K_LEN + 0.2}:d=1.0,adelay={int((K_LEN - 1.0) * 1000)}:all=1[mu]")
    else:  # geçici yumuşak akor (müzik gelene kadar)
        music_in = []
        d = TOTAL - K_LEN + 1.2
        mus = (f"sine=f=220:d={d}[s1];sine=f=277.18:d={d}[s2];sine=f=329.63:d={d}[s3];"
               f"[s1][s2][s3]amix=inputs=3,volume=0.5,tremolo=f=3:d=0.2,"
               f"afade=t=in:d=1.2,afade=t=out:st={d - 1.2}:d=1.2,adelay={int((K_LEN - 1.0) * 1000)}:all=1[mu]")
    af = (f"{static};[4:a]adelay=1200:all=1,volume=1.1[vo];{mus};"
          f"[st][vo][mu]amix=inputs=3:normalize=0,atrim=0:{TOTAL}[aout]")
    full = OUT / ("cache-yazisiz-tam.mp4" if yazisiz else "jenerik-tam.mp4")
    run(["ffmpeg", "-y", "-loglevel", "error",
         "-i", str(k), "-i", str(v1), "-loop", "1", "-i", str(title), "-loop", "1", "-i", str(label),
         "-i", str(voice), *music_in,
         "-filter_complex", vf + ";" + af, "-map", "[vout]", "-map", "[aout]",
         "-t", f"{TOTAL:.3f}", "-c:v", "libx264", "-profile:v", "high", "-crf", "18", "-preset", "slow",
         "-c:a", "aac", "-b:a", "160k", "-ar", "44100", "-movflags", "+faststart", str(full)])
    normalize(full)
    if yazisiz:
        bg = OUT / "jenerik-baslik.mp4"
        run(["ffmpeg", "-y", "-loglevel", "error", "-ss", f"{TOTAL - TITLE_BG:.3f}", "-i", str(full),
             "-af", f"afade=t=in:d=0.3,afade=t=out:st={TITLE_BG - 0.5}:d=0.5",
             "-c:v", "libx264", "-profile:v", "high", "-pix_fmt", "yuv420p", "-crf", "18",
             "-c:a", "aac", "-b:a", "160k", "-ar", "44100", "-movflags", "+faststart", str(bg)])
        normalize(bg)
        full.unlink()
        print(bg, f"{TITLE_BG:.2f} sn (yazısız)")
        return
    short = OUT / "jenerik-kisa.mp4"
    run(["ffmpeg", "-y", "-loglevel", "error", "-ss", f"{TOTAL - SHORT:.3f}", "-i", str(full),
         "-af", f"afade=t=in:d=0.3,afade=t=out:st={SHORT - 0.5}:d=0.5",
         "-c:v", "libx264", "-crf", "18", "-c:a", "aac", "-b:a", "160k", "-movflags", "+faststart", str(short)])
    normalize(short)
    print(full, short, f"{TOTAL:.2f} sn")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--muzik", type=Path, help="müzik dosyası (yoksa geçici akor)")
    ap.add_argument("--etiket", action="store_true", help="AI etiketini göm (sosyal medya sürümü, K-14)")
    ap.add_argument("--baslik-arka", action="store_true",
                    help="yalnızca bölüm başlık ekranının yazısız arka planını üret (jenerik-baslik.mp4, H-050)")
    a = ap.parse_args()
    build(a.muzik, a.etiket, yazisiz=a.baslik_arka)
