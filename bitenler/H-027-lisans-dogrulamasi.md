# H-027: Kelime listesi ve içerik lisanslarının doğrulanması

- **Durum:** Bitti (2026-10-11)
- **Tür:** Araştırma (kodsuz) + hukuk
- **Öncelik:** Yüksek (ilk içerik yayınından önce bitmeli)
- **Bağımlılık:** —

## Amaç
Müfredat omurgasında kullanılacak kaynakların ticari, ücretsiz bir uygulamada yasal olarak kullanılabildiğini birincil kaynaktan doğrulamak.

## Kapsam
- **CEFR-J Wordlist ve Grammar Profile:** cefr-j.org'daki resmî kullanım koşulları ve güncel sürüm (1.5 mi, 1.6 mı?).
- **Octanove C1/C2 ve NGSL/NAWL:** CC BY-SA yükümlülükleri. Liste uygulamaya gömülürse share-alike koşulu doğar.
- **English Vocabulary Profile ve English Grammar Profile:** Ticari kullanım koşulları Cambridge'e yazılı olarak sorulur.
- **Yardımcı araçlar:** CVLA, cefrpy (Google Ngram verisinin lisansı) ve Text Inspector API'nin otomatik ve ticari kullanım koşulları.
- **Testler:** VST/VLT maddelerinin ticari kullanımı. Gerekirse yazarlardan izin istenir.
- **Hukuk:** Referans listelerdeki seviyeleri sistematik biçimde kopyalamanın veritabanı hakkına takılıp takılmadığı.
- **MEB:** Resmî İngilizce dersi programı metniyle eşleme kontrolü.

## Kabul kriterleri
- Her kaynak için şunlar `docs/` altında bir lisans raporuna yazılmış: lisans metninin bağlantısı, kontrol tarihi, "kullanılabilir / yalnızca referans / kullanılmaz" kararı ve atıf metni.
- Uygulamanın "Lisanslar" ekranı için atıf listesi hazır.
- Hukuki görüş gereken maddeler kullanıcıya iletilmiş.

## Kaynak
`docs/ICERIK-MIMARISI.md` §3.1, §12

## Notlar
2026-10-11: Web araştırması (5 kol) ve kullanıcının içerik stratejisi belgesinden açıldı. Ayrıntı: `docs/ICERIK-MIMARISI.md`.

## Sonuç (2026-10-11)
Rapor: `docs/LISANS-RAPORU.md`. Kabul kriterleri karşılandı:
- her kaynak için lisans bağlantısı, alıntı, tarih, karar ve atıf;
- "Lisanslar" ekranı için atıf taslağı (§4);
- Cambridge e-posta taslağı (§6; **gönderilmedi**);
- hukukçuya 12 soru (§8; kullanıcıya iletildi).

**Kararlar:**
- CEFR-J omurga kararı güçlendi; v1.6'ya geçilir.
- CEFR-J Grammar Profile koşullu: yalnızca referans.
- Cambridge EVP/EGP: kullanılmaz.
- NGSL, NAWL ve Octanove CC BY-SA; ayrı veri seti olarak tutulur.
- VST/VLT kullanılmaz; kendi test maddelerimiz yazılır.
- FSRS MIT; port edilirken bildirim korunur.
- MEB eşlemesi doğrulandı (2–4. sınıf 6 tema).

**İşlendiği yerler:** CLAUDE.md ve ICERIK-MIMARISI §3.1/§3.4.

**Açık kalanlar:**
- hukuk soruları (S1–S12);
- Tono Lab ve Cambridge'e yazılı teyit. Dışa dönük yazışma olduğu için kullanıcı onayı gerekir.

2026-10-11: **Dış yazışmalar şimdilik yapılmayacak** (kullanıcı, soru-cevap): Cambridge, Tono Lab, hukukçu. Taslaklar `docs/LISANS-RAPORU.md` §6–§8'de duruyor. Lansmandan önce yeniden sorulacak.
