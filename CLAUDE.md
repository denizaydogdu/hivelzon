# HiVelzon — Proje Rehberi

**HiVelzon:** Velzon Bilişim Teknolojileri Ltd. Şti.'nin, yapay zekâ videolarıyla İngilizce öğreten **mobil uygulaması** (iOS + Android).
- Kitle: herkes, A1–C1.
- Gelir modeli: tamamen ücretsiz.
- Alan adı ileride `hi.velzon.tr`; şimdilik web yok.

> **Durum:** Planlama. **Kullanıcı planı onaylamadan kod yazılmaz.** Plan: `docs/IS-PLANI.md`.

**Karışmasın:** Velzon'un Higgsfield görsel/video üretim atölyesi bu klasör değildir; `~/Dev/velzon-gorsel` altındadır (ayrı oturum). WishSay ayrı bir projedir: `~/Dev/wishsay`.

## Ürünün dört ayağı
1. Hazır ders videoları (Higgsfield; sabit yapay zekâ öğretmen karakteri)
2. Yapay zekâ konuşma pratiği (günlük kota)
3. Kişiselleştirme: kişiye özel video değil, etkinlikler ve hazır videoların varyantları
4. 30 sn'lik kısa video akışı

## Önerilen teknik yığın
WishSay ile aynı: Flutter + Spring Boot 4 + PostgreSQL. WishSay'den yeniden kullanılacak desenler:
- kimlik doğrulama;
- denetim kaydı (IP/port/saat);
- onay kayıtları;
- 30 gün geri alınabilir hesap silme;
- iş takip düzeni.

Ayrıntı: `docs/IS-PLANI.md` §10.

## İş takibi (H-numaraları)
| Klasör | Anlamı |
|---|---|
| `yapilacaklar/IS-SIRASI.md` | **Önce bunu oku.** Sıra, durum, nerede kalındığı, günlük |
| `yapilacaklar/` | Başlanmamış işler |
| `devam-edenler/` | Üzerinde çalışılan işler |
| `bitenler/` | Bitmiş **ve doğrulanmış** işler |
| `hatalar/` | Hatalar ve riskler |
| `ogrenilenler/` | Dersler (`D-` numaralı) |

Kurallar:
- İşler `H-<3 hane>-<kisa-baslik>.md`, tek sayaç. Dersler `D-<3 hane>-…`.
- Durum değişince dosya ilgili klasöre taşınır ve `IS-SIRASI.md` güncellenir.
- Bir iş, kabul kriterleri doğrulanmadan `bitenler/`e geçmez.
- WishSay'de öğrenilen dersler `~/Dev/wishsay/ogrenilenler/` altında; ilgili olanlar burada da geçerli.

## Kurallar
- Kullanıcıyla Türkçe konuş.
- Commit: `/commit` skill, Claude imzası yok. GitHub: `github.com/denizaydogdu/hivelzon`.
- Higgsfield üretiminden önce maliyet gösterilir; her prompt kaydedilir.
- Yapay zekâ maliyetleri ölçülür; aylık harcama tavanı aşılmaz (§8).
- Çocuk kullanıcı ihtimali yüksek: KVKK, COPPA benzeri kurallar ve mağaza eğitim kategorisi kuralları dikkate alınır (§9).
