# H-095: Hukukçu cevaplarının uygulanması

- **Durum:** Devam ediyor (2026-10-21)
- **Tür:** Uygulama (kod) + metin
- **Faz:** F1 MVP — H-042'nin devamı
- **Bağımlılık:** H-042, H-037; kaynak: `docs/HUKUK-SORULARI.md` → "Cevaplar" (2026-10-21)

## Kapsam (kullanıcı onayı 2026-10-21)
1. **Metin sürümü değişince yeniden onay yok:** backend `CONSENT_VERSION_OUTDATED` eşitlemeyi durdurmaz; uygulama yeni sürümü sakin bir bildirimle gösterir ("Gizlilik metni güncellendi" + metne bağlantı). Kabul kaydı istenmez.
2. **2 yıl saklama:** hesap kalıcı silinince rıza kayıtları ve denetim kaydı (IP, port, saat) hemen silinmez; **2 yıl** saklanır, süre dolunca silinir (zamanlanmış temizlik). Hesapla bağı koparılabilir ama ispat için gereken alanlar kalır.
3. **KVKK aydınlatma metni ve kullanım koşulları:** Claude taslak yazar (sade, "sen" dili), uygulamadaki 3 bölümlük taslağın yerine geçer; "hukukçu gözden geçirecek" notu kalır. Veri sorumlusu unvanı/adresi/iletişimi ve yetkili mahkeme **yer tutucu** (ayrı faz).

## Kabul kriterleri
- Eski sürüm onaylı hesap eşitlemeye devam eder; bildirim görünür (test).
- Kalıcı silmede rıza ve denetim kayıtları kalır; 2 yıldan eski olanlar temizlenir (test).
- Yeni metinler `docs/ARAYUZ-METINLERI.md` ile tutarlı; erişilebilirlik ve taşma testleri geçer.

## Test
```bash
cd mobile && flutter analyze && flutter test
cd backend && DOCKER_HOST=unix://$HOME/.colima/default/docker.sock TESTCONTAINERS_RYUK_DISABLED=true mvn -B test
```

## Geri alma
Kendi dalında; `git revert`.
