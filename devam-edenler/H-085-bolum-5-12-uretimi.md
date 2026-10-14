# H-085: Sezon 1 Bölüm 5–12 üretimi

- **Durum:** Devam ediyor (B5 görsel + Türkçe ses ayrı dalda; İngilizce TTS kota bekliyor)
- **Tür:** İçerik üretimi
- **Faz:** F1 içerik (Sezon 1)
- **Bağımlılık:** H-032 (diyaloglar onaylı), H-083 (Türkçe sesler Alania)

## Kapsam
- A1-005…A1-012, H-024 standart yoluyla:
  - GPT Image 2.5 görseller, karakter referanslı;
  - yerel Ken Burns;
  - kilit anda Seedance 2.0 Mini;
  - İngilizce sesler ElevenLabs, Türkçe sesler Alania;
  - paket.
- Önce B5, örnek olarak; süreç `docs/BOLUM-URETIM-REHBERI.md`'ye yazılır. Ardından B6–B12.

## Kabul kriterleri
- Her bölüm content-lint 0 hata, paket ve senkron ölçümü (≤ 0,2 sn), -16 LUFS.
- Kullanıcı simülatörde dener.

## Engel
- İngilizce seslendirme: bölüm başı ~1.100 karakter, toplam ~9.000. Elimizde ElevenLabs 914 karakter; kullanıcıdan hesap ya da plan bekleniyor.

## Notlar
2026-10-14: Kullanıcı 500 Higgsfield kredisi yükledi, yarım kalan işler için onay verdi. B5 bütçesi 20 kr.
