# Hi — marka dosyası

> Karar: `docs/KARARLAR-2026-10-27.md` (H-016). Bu klasördeki dosyalar
> H-101 ile iOS/Android uygulama simgelerine ve açılış ekranlarına uygulandı;
> 1024/512 mağaza master'ları hazırdır. Hesaplara yükleme H-044'te en sondadır.

## Dosyalar

| Dosya | Ne için |
|---|---|
| `logo-hi.svg` | Ölçeklenebilir simge/logo konsepti |
| `logo-hi-1024.png` | 1024 × 1024 master PNG (mağaza/uygulama simgesi tabanı) |
| `google-play-icon-512.png` | Google Play için 512 × 512 PNG |

Varlıkları yeniden üretmek için `mobile/` altında
`bash tool/brand_icons.sh` çalıştırılır.

## Palet

| Rol | Renk | Değer |
|---|---|---|
| Birincil | Deniz mavisi | `#1F4E79` |
| Ana eylem | Fener sarısı | `#F2B33D` |
| Zemin | Kum | `#F7F1E6` |
| Metin | Mürekkep | `#2B2B2B` |
| Küçük vurgu | Akşam turuncusu | `#E98A3C` |

Renkler `mobile/lib/app/design/tokens.dart` içindeki `AppPalette` ile aynıdır.
Yeni renk eklenmez; kontrastlar mevcut tasarım sistemiyle korunur.

## Kullanım

- Simge: deniz mavisi zemin + kum rengi konuşma balonu + "Hi" + fener sarısı
  ışık. Küçük boyutta okunurluk için ayrıntı eklenmez.
- Maskot Hi'nin yüzü logoya gömülmez; maskot ayrı karakterdir (H-005).
- Mağaza adı: **Hi: İngilizce Öğren**.
- Apple alt başlığı: **İngilizceyi hikâyeyle öğren**.
- Google kısa açıklama: **Hikâyelerle İngilizce öğren: oku, dinle, konuş.**
- "Port Lumen" yalnız hikâye mekânıdır; marka adı olarak kullanılmaz.
