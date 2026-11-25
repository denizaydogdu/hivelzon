# H-116: Duyu (Türkçe ses hizalaması) için aylık bütçe tavanı

- **Durum:** ⛔ Kullanıcı kararı bekliyor (2026-11-25)
- **Tür:** Araç kuralı (`tools/content-pipeline`) — ücretli harcama
- **Öncelik:** Orta (Duyu ücretsiz kota ≈ 985 saat bitince ya da toplu yeniden hizalamada önemli)
- **Bağımlılık:** H-114 (Duyu çağrıları artık her istekte deftere yazılıyor, kilit altında)

## Sorun
Proje kuralı: "Her ücretli çağrıdan önce kota ve bütçe kontrolü; tavan tanımlı değilse ücretli üretim kapalı."
Alania karakterleri `HIVELZON_TR_TTS_MONTHLY_CHAR_CAP` ile sınırlı; **Duyu (ses saati başına `TL_PER_AUDIO_HOUR` = 6 TL)
hiçbir tavana bağlı değil** — ana çağrı ve boşluk (`fill_gaps`) çağrıları denetimsiz. qa-code-reviewer bulgusu (H-114).

## Seçenekler (karar kullanıcıda)
1. Ayrı tavan: `HIVELZON_TR_STT_MONTHLY_SECONDS_CAP` (defterdeki `duyuSeconds` ile, kilit altında, her Duyu çağrısından önce).
2. Tek TL bütçesi: Alania + Duyu birlikte `estimate_tl` ile (`HIVELZON_TR_MONTHLY_TL_CAP`); kullanıcıya en anlaşılır olan.
3. Tavan tanımlı değilse: (a) Duyu reddedilir (kuralla tutarlı; mevcut iş akışını durdurur) ya da (b) `GET /v1/usage` kalan
   saniyesi üst sınır sayılır (okunamazsa reddedilir).

**Öneri:** 2 + 3a (tek TL tavanı; tanımsızsa Türkçe ücretli üretim tamamen kapalı — bugün Alania için de böyle).

## Kabul
Seçilen tavan her Duyu çağrısından (ana + boşluk) önce kilit altında denetlenir; aşılırsa çağrı yapılmaz, `HATA:`;
kuru çalışma satırı tavanı gösterir; testler (sınırda tek çağrı, eşzamanlı iki koşu, tanımsız tavan).
