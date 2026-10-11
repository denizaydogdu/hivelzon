# hiVelzon arayüz tasarım yönü (H-045)

Taslaklar: `onizleme/T1…T6.jpg` (tam boy PNG'ler git dışında). Üretim kaydı: `PROMPTS.md`.
Ton: hikâyeyle uyumlu (kullanıcı kararı, 2026-10-11). Arayüz sade; hikâye çizimleri kartlarda ve videoda.

## Tasarım belirteçleri (Flutter temasına aktarılır)
| Belirteç | Değer | Kullanım |
|---|---|---|
| Birincil | `#1F4E79` deniz mavisi | Başlıklar, seçili sekme, birincil düğme (koyu) |
| Vurgu | `#F2B33D` fener sarısı | Ana eylem düğmesi ("Hikâyeye devam", "Bildim"), sıradaki bölüm |
| Arka plan | `#F7F1E6` kum | Sayfa zemini |
| Metin | `#2B2B2B` | Gövde metni (saf siyah yok) |
| Akşam turuncusu | `#E98A3C` | Yalnızca küçük vurgular |
| Köşe | 12 px | Kart ve düğmeler |
| Boşluk | 8 px ızgara | 8 / 16 / 24 / 32 |
| Yazı | Inter benzeri, en fazla 3 ağırlık | 400 / 500 / 700 |

## Ekranlardan alınacaklar
- **T1 Ana Sayfa:** tek büyük "Hikâyeye devam" kartı + günlük hedef halkası + "Hızlı pratik" + "Yeni klipler". Ürün ilkesi: tek öğrenme eylemi öne çıkar.
- **T2 Harita:** resimli kasaba haritası, limandan fenere uzanan yol, biten bölümde onay, sıradaki parlayan, kilitlide kilit + spoiler'sız ipucu. Düğümler Flutter'da çizilir (görseldeki numaralar bozuk).
- **T3 Oynatıcı + karar:** video üstte kararır, alttan "Ne dersin?" kartı, büyük seçenek düğmeleri; üst çubukta kapat, ilerleme noktaları, 0,75x, altyazı düğmesi.
- **T4 Hi ipucu:** Hi'nin ışıklı balonu, Türkçe ipucu + ses, "Bir ipucu daha" ve "Tekrar dene". Cezalandırıcı dil yok.
- **T5 Defter:** "İfadeler / İpucu panosu" sekmesi, FSRS kartı (Bildim / Bilmedim), bölüm etiketli ifade listesi.
- **T6 Keşfet:** tam boy klip, hedef kelime vurgulu altyazı + küçük Türkçe karşılık, sağda Kaydet / Anlam / Tam hikâye. Beğeni ve yorum yok.

## Taslaklardan farklı yapılacaklar
- Oynatıcıda (T3, T4) alt sekme çubuğu **gizlenir**; tam ekran.
- T2'deki üst sekme şeridi kullanılmaz (sekmeler yalnızca altta).
- Görsellerdeki İngilizce örnekler yer tutucudur: gerçek metin bölüm paketinden gelir. (T5'teki "Otobüs durağı nerede?" çevirisi de yanlış; *bus station* ≠ durak.)
- Görsellerdeki tabela yazıları ("Good Coffee Better Days", "CAFÉ") uygulamaya taşınmaz.
