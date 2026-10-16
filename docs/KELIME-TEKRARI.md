# Kelime tekrarı: hatırlama, pratik ve öğrenme kanıtı (H-089)

> **Durum:** 2026-10-16, H-089 ile uygulandı. Önceki kurallar H-036 (FSRS, görevler), H-055 ("Söyle") ve H-087 (anlamı değiştiren ek).
> **Kaynak:** `docs/URUN-INCELEMESI-2026-10-15.md` §4 ("Tamamlamak, hatırlamak ve kullanabilmek ayrı kaydedilmeli"; "Hafıza ölçümü ile dinleyip taklit etme aynı kart durumuna karışıyor").
> **Kod:** `mobile/lib/features/notebook/domain/review_policy.dart` (görev ve not), `review_session.dart` (oturum akışı), `evidence_ladder.dart` (basamaklar), `data/notebook_store.dart` (kayıt), `shared/storage/evidence_backfill.dart` (eski cevaplardan doldurma).

## 1. İlke

FSRS bir **hafıza** modelidir: yalnızca yardımsız geri çağırmayla beslenir. Seçenekten tanımak, sesi duyup seçmek, verilen kelimeleri dizmek ya da duyduğunu tekrar etmek öğrenmeye yardım eder ama hatırlamayı kanıtlamaz. Bu yüzden görevler iki türe ayrılır:

| Tür | Görevler (`TaskType`) | FSRS | Kanıt basamağı |
|---|---|---|---|
| **Hatırlama** | `type` (Türkçesinden yaz), `speak_recall` (Türkçesinden, **sesi duymadan** söyle), `self_check` (aklından söyle, sonra kartı aç: Bildim / Bilmiyorum) | Not alır (Again / Hard / Good / Easy) | Kendi kullandı, sonra hatırladı |
| **Pratik** | `picture_choice`, `listen_choice`, `arrange`, `speak` (dinle ve söyle = taklit), `scene_hunt` | **Not almaz**; kart ve `review_logs` değişmez | Yardımla yaptı |

Bütün kartları beceri başına çoğaltmak gerekmedi (inceleme önerisi): kart tektir, yalnızca hangi sonucun hafızaya yazıldığı değişti.

## 2. Oturum akışı ve not kuralları

### 2.1 Görev seçimi (`ReviewPolicy.chooseTask`)

- **Uzun vade kartı** (`review`, vadesi gelmiş): **önce yardımsız hatırlama**, ısınma yok.
  - Genç kart (A1'de 4, A2+'da 3 tekrardan az) → kendini yokla.
  - Üretim aşaması: tek kelime → yaz; kalıp/cümle ve cihazda tanıma açık → sesi duymadan söyle; değilse kendini yokla.
- **Yeni, öğrenme, yeniden öğrenme kartı**: önce **pratik**, başarılıysa **aynı oturumun sonunda hatırlama sorusu** (yukarıdaki hatırlama görevi).
  - Hiç tekrar edilmemiş → resimden seç.
  - Yeniden gelen: tanıma açık + ses + kalıp/cümle ve tek sayılı tekrar → dinle ve söyle; ses varsa → dinle-seç; kalıp/cümle → diz; yoksa resimden seç.
  - Seçenek üretilemiyorsa (defterde tek kart) kalıp/cümle → diz; tek kelimede pratik yok, doğrudan hatırlama.

### 2.2 Notlar

| Durum | Önce (H-036/H-055) | Şimdi (H-089) |
|---|---|---|
| Pratik (seç, dinle-seç, diz) doğru | Good (yavaşsa Hard, olgunda hızlıysa Easy) | **Not yok**; "yardımla yaptı"; oturum sonunda hatırlama sorusu |
| Pratik yanlış / "Bilmiyorum" | Again | **Not yok**; pratik oturum sonunda yeniden (en çok 2 kez) |
| Dinle ve söyle (taklit) tam | Good / Easy | **Not yok**; "yardımla yaptı" |
| Dinle ve söyle yakın (bir kelime eksik) | Hard | Not yok; başarılı sayılır (anlamı değiştiren ek yoksa) |
| Sahne avı kendin buldun | Good | **Not yok**; "yardımla yaptı" (tekrar zamanı değişmez) |
| Sahne avı bulamadın / "Bilmiyorum" | Again | Not yok |
| Hatırlama doğru, yavaş | Hard | **Good** (hız hafızayı ölçmez) |
| Hatırlama doğru, olgun kart, hızlı | Easy | Easy **yalnız** yazma ve sesi duymadan söylemede; kendini yoklamada Good |
| Söyle (hatırlama) tam, 1. deneme | Good (olgunda hızlıysa Easy) | aynı |
| Söyle tam, 2. deneme | Hard | aynı |
| Söyle yakın: yalnız bir kelime duyulmadı | Hard | aynı |
| Söyle yakın: **anlamı değiştiren ek** (H-087 `changedWords`: olumsuzluk, kip, sayı, soru) | Hard | **Again** (doğru sayılmaz; "Devam et" düğmesi çıkmaz, bir daha denemek önerilir) |
| Yanlış, "Bilmiyorum", 2 denemede olmadı | Again | aynı |
| "Geç" | not ve kayıt yok | aynı |

**Neden pratik hiç not almıyor (sınırlı not yerine)?** Hard bile FSRS'te kararlılığı artırır ve zorluğu yükseltir; tanıma başarısını "zor hatırladı" diye yazmak hem aralığı şişirir hem kartı haksız yere zor gösterir. Pratik başarısının yerine aynı oturumda gerçek bir hatırlama sorusu sorulur; FSRS'e giden tek sinyal odur. Pratik başarısızlığı da yazılmaz: kart zaten öğrenme ya da yeniden öğrenmededir, sıradaki hatırlama sorusu (ya da sonraki oturum) durumu ölçer.

**Hız kuralı (erişilebilirlik):** Önceden "doğru ama yavaş = Hard" idi. Okuma hızı, klavye, motor güçlük ve ekran okuyucu bu süreyi uzatır; hafızayı ölçmez ve yalnız bazı kullanıcıların aralığını kısaltır. Bu ceza kaldırıldı. "Hızlı = Easy" yalnızca olgun kartta (kararlılık ≥ 21 gün), nesnel üretimde (yaz / söyle) kalır; kimseyi cezalandırmaz, en çok aralığı biraz uzatır. Süre yine ölçülür ama gösterilmez (K-32).

**"Bilmiyorum"** her görevde vardır ve utandırmaz: "Sorun değil, birlikte bakalım." Pratikte not etkisi yoktur; hatırlamada Again'dir ve ifade oturum sonunda (önce pratikle) yeniden gelir.

**Günlük yeni ifade sınırı:** cevap kaydından (`review_logs.was_new`) sayılır. Pratik kayıt yazmadığından yalnız pratiği yapılıp hatırlama sorusuna gelmeden bırakılan yeni ifade bugünkü sınırdan düşmez (küçük ve kasıtlı bir sapma: ifade hâlâ yeni sayılır).

**Sunucu:** kart durumu sunucuda cevaplardan yeniden hesaplanır (`ReviewService`); pratik `review_logs`'a yazılmadığı için orada da not sayılmaz. Yeni görev türü `speak_recall` backend'de izinli (`LearningSyncTables.TASK_TYPES`).

## 3. Öğrenme kanıtı basamakları

### 3.1 Basamaklar ve olay kuralları

| Basamak | Kod | Ne zaman (ilk kez) |
|---|---|---|
| **Gördün** | `seen` | İfade deftere girdi (bölüm sonu hedef ifade, anlamına bakma, Deftere ekle, konu seti, kitap, dilbilgisi). **Saklanmaz**: defterdeki ifadenin eklenme anıdır. |
| **Yardımla yaptın** | `helped` | Başarılı pratik: seçenekten doğru seçim, dinleyip doğru seçim, doğru dizme, dinle ve söyle (tam ya da yalnız bir kelime eksik; anlamı değiştiren ek yok), sahne avında kendin bulma (en çok 1 kaçırma). |
| **Kendin kullandın** (yeni örnekte) | `own_use` | Nesnel denetlenen yardımsız üretim: Türkçe anlam + resimden, sesi duymadan ve seçenek görmeden **yazma doğru** ya da **söyleme tam / yalnız bir kelime eksik** (not Hard ya da üstü). Bağlam, ifadenin bölümdeki sahnesi değil, tekrar kartıdır. Kendini yoklama ("Bildim") sayılmaz (denetlenemez). |
| **Birkaç gün sonra hatırladın** | `recalled_later` | Uzun vade kartında (`review` durumu: o oturumda pratikle ısınmamış) **yardımsız hatırlama başarılı** (yaz, söyle ya da kendini yokla; Again değil) ve ifade **en az 2 gün önce** görülmüş. |

- Basamaklar sırayla gelmek zorunda değildir (kendini yoklamayla "sonra hatırladın", denetlenen üretimden önce gelebilir). Ekranda **en yüksek** basamak kullanılır.
- Her basamağın yalnız **ilk** anı tutulur; tekrar yazmak bir şey değiştirmez (idempotent).
- Hikâye içi "Sen de söyle", bölüm sonu hedef ifadeleri söyleme ve karar anı "Söyleyerek seç" şimdilik basamağa yazılmaz (hikâye kodu bu işin kapsamı dışında; sonra "yardımla yaptın"a bağlanabilir). Kitap sonu anlama (H-091) kitap başına tutulduğundan ifade basamağına bağlanmadı.

### 3.2 Veri (yalnız cihazda; hesap varsa eşitlenir)

`expression_evidence (item_key, stage, at)` — Drift şema 10, backend V13. İfadenin anahtarı (defterdeki `item_key`), basamak ve ilk an. İçerik metni (anahtar dışında), ses ve tanıma yazısı **yoktur**. Yalnız eklenir; iki cihazda aynı basamak varsa ilk gelen kalır (istemcide yereldeki ilk an korunur). "Defterden çıkar" ifadenin kanıtlarını cihazda siler; "Bu telefondaki verileri de sil" hepsini siler. Hesap silmede sunucudaki satırlar diğer öğrenme verisiyle birlikte silinir.

### 3.3 Eski cevaplardan doldurma (şema 10 geçişi)

Eski cevaplarda kartın o anki durumu olmadığından yaklaşıktır: doğru pratik cevabı → yardımla; doğru `type` cevabı (not ≥ Hard) → kendin kullandın; doğru `type` / `self_check` cevabı, ifade ≥ 2 gün önce eklenmiş ve aynı kartın ≥ 1 gün önce başka cevabı var → sonra hatırladın. Eski `speak` cevapları taklittir → yardımla. Hesap açıksa doldurulan satırlar eşitleme kuyruğuna alınır.

## 4. Profil: kanıta dayalı küçük kazanımlar

"**Neler yapabiliyorsun**" bölümü sayı yığını ve yüzde yerine en çok dört kısa cümle gösterir (`ProfileTexts.evidence*`; metinler `docs/ARAYUZ-METINLERI.md` §6):

1. En yüksek basamağı "sonra hatırladın" olan ifadeler (en yeni önce, en çok 2 + "ve n ifade daha").
2. "Kendin kullandın" olanlar.
3. Yalnız bu ikisi yoksa "yardımla yaptın" olanlar ("Sırada kendin hatırlamak var.").
4. **Yeniden çalışalım:** son hatırlamada gelmeyen (yeniden öğrenmede ya da tekrar edilmiş ama öğrenmede) ifadeler. Suçlamaz; "unuttun" denmez.

Henüz kanıt yoksa sakin davet: "Kelime tekrarında bir ifadeyi kendin hatırladığında burada görünür." İfadelerin konu etiketi olmadığından cümleler **ifade düzeyindedir** ("Yol sorabiliyorsun" gibi konu düzeyi cümle, ifadelere konu/beceri etiketi gelince eklenebilir).

Sayılar (ifade, bitirilen bölüm, bu hafta tekrar) **"İçerik ilerlemesi"** başlığı altında kalır: bunlar içerik ilerlemesidir, "öğrendin" diye yorumlanmaz. Dilbilgisi ("%40 ilerledin") ve kitap ("yüzde 40 okundu") yüzdeleri de içerik ilerlemesidir ve öyle kalır.

## 5. Sonra

- Haftalık özet (Hi, Ana Sayfa) hâlâ "tekrar ettin / ekledin" sayar; kanıt basamaklarından bir cümle ("Bu hafta 2 ifadeyi birkaç gün sonra kendin hatırladın") eklenmeli. `review_logs` artık yalnız hatırlamayı içerdiği için "tekrar edilen ifade" sayısı pratiği saymaz.
- Hikâye içi söyleme yerleri → "yardımla yaptın".
- Pilotta: hızlı = Easy kuralının etkisi ve kendini yoklamanın dürüstlüğü ölçülür.
