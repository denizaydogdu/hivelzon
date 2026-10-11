# H-045: Arayüz tasarım yönü (ekran taslakları)

- **Durum:** Bitti
- **Tür:** Tasarım (kredi harcar, onaylı)
- **Bağımlılık:** H-033

## Kapsam
- GPT Image 2.5 ile 6 ekran taslağı: Ana Sayfa, harita, oynatıcı + karar, Hi ipucu, Defter, Keşfet.
- Tasarım belirteçleri (`tasarim/README.md`); Flutter teması H-031 ve sonrasında bunlara göre güncellenir.

## Kabul kriterleri
- Maliyet önceden gösterildi ve onaylandı (6 kr).
- Her prompt ve job `tasarim/PROMPTS.md`'de.
- Kullanıcı yönü onayladı.

## Notlar
2026-10-11: Kullanıcı "uygulama tasarımında ChatGPT ya da Higgsfield kullanabilirsin" dedi. Soru-cevapla: ekran taslakları, hikâyeyle uyumlu ton, 2k (6 kr). Üretildi; kredi 92,25.
2026-10-11: Kullanıcı "devam" dedi (yön onaylandı). Belirteçler `mobile/lib/app/theme.dart`'a işlendi; `flutter analyze` temiz, `flutter test` 1/1, simülatörde kum zemin + deniz mavisi + sarı sekme göstergesi doğrulandı.
