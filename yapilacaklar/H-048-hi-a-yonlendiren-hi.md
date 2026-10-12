# H-048: Hi-A, yönlendiren Hi (balon + kural tabanlı koç)

- **Durum:** Yapılacak
- **Tür:** Uygulama (kod)
- **Faz:** 1.4b (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-036 (defter + FSRS), H-046 (anlam verisi)

## Kapsam (`docs/HI-ASISTAN-VE-KOC.md` §3, §6)
- Hi balonu: sekmelerde sağ altta, menünün üstünde; oynatıcıda, görevde ve onboarding'de gizli. Erişilebilir etiket, 48 px dokunma alanı.
- Hi paneli:
  - bugünkü tek öneri + görünür gerekçe (kurallar: FSRS vadesi gelen kartlar, son hatalar, yarım bölüm, günlük hedef);
  - hızlı eylemler;
  - "bu ne demek?" (çeviri ve sözlük verisinden, deterministik arama);
  - haftalık özet.
- Türkçeye göre hata ipuçları: hata kataloğu (yapılandırılmış veri; içerikteki notlardan).
- Gerçek hayat köprü görevleri: isteğe bağlı yan görev kartı (K-31).
- Profil'de "Hi benim hakkımda ne biliyor?" görünümü ve silme.
- AI yok, ücretli çağrı yok; bütün yaşlar.

## Kabul kriterleri
- Öneri kuralları birim testli; her önerinin gerekçe metni var.
- Balon doğru ekranlarda görünüyor ve gizleniyor (widget testi).
- Suçlayıcı dil yok (metin denetim listesi).

## Notlar
2026-10-11: H-047 kararıyla açıldı.
