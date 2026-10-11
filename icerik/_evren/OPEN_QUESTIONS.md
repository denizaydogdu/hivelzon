# AÇIK SORULAR: *The Missing Signal*

**Sürüm:** 0.1 (H-030) · **Tarih:** 2026-10-11

Bu dosya, bölümler arası bağ kurallarının denetim kaydıdır (CLAUDE.md, `OYUN-TASARIMI.md` §4.3):

| Soru türü | Kural |
|---|---|
| **Bölüm sorusu** | Açıldığı bölümden sonra **en geç 3 bölüm** içinde kapanır. |
| **Sezon sorusu** | Sezon finalinde kapanır. Sezon ortasında kısmi cevap verilir. |
| **Seri sorusu** | Arka plandadır. Aynı anda açık soru sayımına girmez. S5'te kapanır. |

**Sınır:** Aynı anda en fazla 1 sezon sorusu ve 2 bölüm sorusu açık olabilir.

İleride `content-lint` bu tabloyu bölümlerin `content.json` dosyalarıyla karşılaştıracak.

## Sezon 1

| ID | Tür | Soru | Açıldığı | Kısmi cevap | Kapandığı | Cevap |
|---|---|---|---|---|---|---|
| SQ0 | Seri | Babaannenin notu ne anlama geliyor? ("Cuma. Saat yedi. Yedinci kanal. Unutma. — N.") | Prolog | B4 (aynı saat), B8 (Kanal Yedi), B12 (1979 fotoğrafı) | S5 | Ellen ile verilen söz |
| S1-Q | Sezon | Telsizdeki çağrıyı kim gönderiyor? | B1 | B8 (bir kayıt; tepe yönü) | **B12** | Kulübün fenerdeki vericisi; zamanlayıcıyı Ellen Hart kurmuş |
| Q1 | Bölüm | Old Station nerede? | B1 | B2 (limanda) | **B3** | Limanda, balıkçı dükkânının yakınında, otobüs durağı ile kafenin arasında |
| Q2 | Bölüm | İstasyon kapalıysa çağrı neden oraya çağırıyor? | B2 | B4 (not Pier 3'ü gösteriyor) | **B5** | Biri hâlâ eski buluşma yerlerine not bırakıyor; buluşma Pier 3'e taşınmış |
| Q3 | Bölüm | Kapıdaki yarım notta ne yazıyor? | B3 | — | **B4** | "Friday. 7 pm. Pier 3. — E." |
| Q4 | Bölüm | Cuma saat yedide Pier 3'te kim olacak? | B4 | — | **B5** | Kırmızı paltolu yaşlı bir kadın (kaçırılır) |
| Q5 | Bölüm | Kayıtta ne var? | B5 | — | **B6** | "Lumen Point, Saturdays, the light, E." |
| Q6 | Bölüm | Kayıt mı doğru, Jordan mı? | B6 | — | **B7** | Kayıt doğru; Jordan karanlıkta yanlış görmüş ve duymuş |
| Q7 | Bölüm | Sinyal gerçekten nereden geliyor? | B7 | — | **B8** | Tepe ve Lumen Point yönü; her cuma aynı kayıt |
| Q8 | Bölüm | Tepede çağrıyla ilgili ne var? | B8 | — | **B9** | Hilltop Café, eski kulübün buluşma yeri; bir üye cumartesileri fenere gidiyor |
| Q9 | Bölüm | Çağrıyı daha net duymak için ne lazım? | B9 | — | **B10** | Yeni anten; canlı ikinci mesaj yakalanır |
| Q10 | Bölüm | "The light test" nedir, gidebilir miyiz? | B10 | — | **B11** | Müzenin Light Night etkinliği; güvenli ve açık |
| Q11 | Bölüm | Fener gecesinde kaynağı bulabilecek miyiz? | B11 | — | **B12** | Evet: verici, zamanlayıcı, 1979 fotoğrafı |
| Q12 | Sezon (S2) | Ellen nerede? Neden hâlâ babaanneyi bekliyor? | B12 | — | S2 finali | (S2'de yazılacak) |

## Eşzamanlı açık soru denetimi (bölüm sonunda açık olanlar)

SQ0 seri sorusudur ve sayıma girmez.

| Bölüm sonu | Açık sorular | Sayı (en fazla 3) |
|---|---|---|
| Prolog | — | 0 |
| B1 | S1-Q, Q1 | 2 ✅ |
| B2 | S1-Q, Q1, Q2 | 3 ✅ |
| B3 | S1-Q, Q2, Q3 | 3 ✅ |
| B4 | S1-Q, Q2, Q4 | 3 ✅ |
| B5 | S1-Q, Q5 | 2 ✅ |
| B6 | S1-Q, Q6 | 2 ✅ |
| B7 | S1-Q, Q7 | 2 ✅ |
| B8 | S1-Q, Q8 | 2 ✅ |
| B9 | S1-Q, Q9 | 2 ✅ |
| B10 | S1-Q, Q10 | 2 ✅ |
| B11 | S1-Q, Q11 | 2 ✅ |
| B12 | Q12 (S2 sezon sorusu) | 1 ✅ |

**Denetim:** Bütün bölüm soruları en geç 3 bölümde kapanıyor. En uzun açık kalan Q2: B2'de açılıp B5'te kapanıyor, yani tam 3 bölüm.
