# H-113: Lint uyarılarının sınıflandırılması

- **Durum:** ✅ Bitti (2026-11-25): yalnız sınıflandırma; içerik ve kural değişmedi.
- **Tür:** Denetim (salt okuma)
- **Bağımlılık:** yok

## Sonuç (CI komutlarıyla, `--json`; 797 uyarı, 0 hata)
| Lint | Uyarı | Dağılım | Ne bekliyor |
|---|---|---|---|
| dilbilgisi (71) | 558 | 551 İngilizce örnek sesi/hizası yok · 2 kapsama · 5 liste dışı sözcük | sesler: ElevenLabs erişimi (madde 4); sözcükler: editör |
| kitap (30) | 205 | 135 İngilizce ses/hizalama yok · 60 Türkçe Duyu hizalaması zayıf · ~10 liste dışı sözcük | ses: madde 4; zayıf hizalar: H-105 kulakla kontrol; sözcükler: editör |
| bölüm (13) | 28 | 8 çeviri DRAFT · 1 çeviri yok (A1-000 prolog, üretilmedi) · 4 kapsama · ~13 liste dışı/küme/Duyu | editör (H-028) |
| reel (18) | 6 | 6 kapsama %98 altı (sözlükle %100) | editör (H-094 P3) |

- **~712 uyarı (%89) eksik İngilizce sesten** gelir; doğru uyarılardır, ses gelince kendiliğinden kapanır.
- Kalan ~85 uyarı editör ya da kulakla kontrol işidir; ücretsiz kod düzeltmesi gerektiren kural hatası bulunmadı.
- Sesi olan metin değiştirilirse hizalama bozulur (yeniden ses = ücret); bu yüzden metne dokunulmadı.
- İsteğe bağlı küçük iyileştirme (yapılmadı): eksik ses uyarılarını ders/kitap başına tek satırda özetlemek.
