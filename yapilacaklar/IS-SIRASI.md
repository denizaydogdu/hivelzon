# İş Sırası — HiVelzon

> Son güncelleme: 2026-10-11 · Güncelleyen: Claude

Bu dosya tek takip noktasıdır. Hangi işin hangi sırada yapıldığını, şu an ne üzerinde çalışıldığını ve neyin bittiğini gösterir. Her işin ayrıntısı kendi `H-<numara>-<başlık>.md` dosyasındadır.

## Nerede kaldık
- **Şu an:** Planlama, Faz 0. Kod yok.
- **Şimdi yapılan:** —
- **Sıradaki adım:**
  1. Kullanıcı 1. adımdaki kararları verir (H-001, H-007 ve diğer yüksek öncelikli kararlar).
  2. Bu sırada Claude 2. adımdaki kodsuz incelemeleri yapabilir (H-021, H-022).
- **Engel:** Kullanıcı kararları.

## Nasıl takip ediyoruz
- **İş dosyası nerede durur:** Durum değişince dosya klasör değiştirir:
  - başlanmamış iş `yapilacaklar/` klasöründe durur;
  - başlanınca `devam-edenler/` klasörüne taşınır;
  - kabul kriterleri doğrulanınca `bitenler/` klasörüne taşınır.
- **Her durum değişikliğinde:**
  - aşağıdaki tablodaki durum güncellenir;
  - H dosyasının `Durum` satırı güncellenir;
  - **Günlük** bölümüne bir satır eklenir.
- **Biten işler:** "Biten işler" tablosuna doğrulama kanıtıyla birlikte yazılır.
- **Numaralar:** Tek sayaçla verilir. Sıradaki boş numara: **H-026**.

**Durum simgeleri:**
- ⛔ Kullanıcı kararı bekliyor
- ⏳ Sırada (başlanabilir ya da bağımlılık bekliyor)
- 🔄 Devam ediyor
- ✅ Bitti (doğrulandı)
- ⏸ Ertelendi

## Sıra

### Adım 1 — Kararlar (kullanıcı)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 1 | H-001 | İş planını gözden geçir ve onayla | Yüksek | H-007 ile birlikte | ⛔ |
| 2 | H-007 | Plan ile şartname arasındaki çelişkileri uzlaştır (konuşma pratiği MVP'de mi?) | Yüksek | H-001 ile birlikte | ⛔ |
| 3 | H-002 | Yaş politikası | Yüksek | — | ⛔ |
| 4 | H-003 | Yapay zekâ aylık bütçe tavanı ve kotalar | Yüksek | — | ⛔ |
| 5 | H-006 | Yapay zekâ sağlayıcıları ve yurt dışı aktarım | Yüksek | — | ⛔ |
| 6 | H-008 | Ham ses ve transkript saklama politikası | Yüksek | H-006 | ⛔ |
| 7 | H-004 | Higgsfield planı ve video üretim emeği | Yüksek | — | ⛔ |
| 8 | H-005 | Yapay zekâ öğretmen karakteri | Yüksek | — | ⛔ |
| 9 | H-018 | Mağaza yayın bölgesi | Orta | H-002 | ⛔ |
| 10 | H-009 | Misafir kullanım ve kayıt zorunluluğu | Orta | H-002 | ⛔ |
| 11 | H-013 | Günlük hedef, seri ve bildirim politikası | Orta | H-007 | ⛔ |
| 12 | H-014 | Kısa video akışının davranışı | Orta | — | ⛔ |
| 13 | H-015 | Konuşma geri bildirimi ve telaffuz puanının güvenilirliği | Orta | H-006, H-007 | ⛔ |
| 14 | H-016 | Marka ve görsel kimlik | Orta | H-005 | ⛔ |
| 15 | H-019 | WishSay ile kod paylaşım yöntemi | Orta | H-021 | ⛔ |
| 16 | H-011 | İçerik yönetim ve editör onay paneli | Orta | H-021, H-022 | ⛔ |
| 17 | H-012 | Medya depolama ve CDN | Orta | H-021 | ⛔ |
| 18 | H-010 | Çevrimdışı kullanım MVP'de olacak mı? | Düşük | H-012 | ⛔ |
| 19 | H-017 | Sosyal medya yayın kapsamı | Düşük | — | ⛔ |
| 20 | H-020 | Reklam yok kararı | Düşük | — | ⛔ |

### Adım 2 — Kodsuz inceleme (Claude; kararları beklemeden yapılabilir)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 21 | H-021 | WishSay desenlerinin incelemesi | Yüksek | — | ⏳ |
| 22 | H-022 | videoGenerator sınıflarının incelemesi (yalnızca okuma) | Yüksek | — | ⏳ |

### Adım 3 — Plan güncellemesi ve pilot
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 23 | H-023 | İş planını şartnameyle güncelle | Yüksek | H-007, H-021, H-022 | ⏳ |
| 24 | H-024 | Pilot içerik: A1-001 hikâyesi ve 3 kısa klip (kredi harcar, onaylı) | Yüksek | H-004, H-005 | ⏳ |

### Adım 4 — Uygulama planı
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 25 | H-025 | Faz 1 (MVP) uygulama planı | Yüksek | H-001, H-007, H-023 | ⏳ |

Kod yazımı H-025 onaylandıktan sonra başlar. MVP işleri o aşamada H-026'dan itibaren numaralanır.

## Devam eden işler
| İş | Başlık | Başlangıç | Not |
|---|---|---|---|
| — | — | — | — |

## Biten işler
| İş | Başlık | Bitiş | Doğrulama |
|---|---|---|---|
| — | İş planı ve proje iskeleti | 2026-10-11 | 13 bölüm, 22 kaynak; GitHub'a gönderildi |
| — | Ürün/teknik şartname kaydı ve CLAUDE.md güncellemesi | 2026-10-11 | `docs/SARTNAME.md` eklendi; commit `15198a2`, GitHub'a gönderildi |

## Günlük
- **2026-10-11:**
  - Kullanıcı HiVelzon'u duyurdu: yapay zekâ videolarıyla İngilizce öğrenme; hazır videolar, konuşma pratiği, kişiselleştirme, kısa video akışı; herkes; ücretsiz; "şimdilik sadece iş planı, kodlama yok".
  - Plan yazıldı ve GitHub'a gönderildi.
  - Kullanıcı ayrıntılı ürün/teknik şartname taslağını (0.1) paylaştı → `docs/SARTNAME.md`. CLAUDE.md'ye belge hiyerarşisi, ürün ve mühendislik ilkeleri ile plan–şartname çelişkileri eklendi (konuşma pratiğinin MVP'deki yeri, faz yapısı, seviye testi, günlük hedef, seri, telaffuz puanı). Çelişkiler H-001 onayında çözülecek.
  - Klasör çakışması: başka bir oturum `~/Dev/hiVelzon`'u görsel atölye sanmıştı. Kullanıcı kararıyla atölye `~/Dev/velzon-gorsel`e taşındı (o oturum taşıdı, hiçbir şey silinmedi).
  - Kullanıcı isteğiyle her iş için `yapilacaklar/` altında H dosyası açıldı (H-006…H-025); `IS-SIRASI.md` adımlı takip tablosuna çevrildi.
    - **Numara düzeltmesi:** H-006 eskiden burada "Faz 1 uygulama planı" idi, `IS-PLANI.md` §13.2 ise H-006'yı sağlayıcılar için kullanıyordu. Plana uyuldu: H-006 artık sağlayıcılar, Faz 1 planı H-025 oldu.
