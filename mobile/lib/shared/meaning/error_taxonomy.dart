// Öğrenme olaylarındaki hata türü (H-036; Hi-A koçluğu H-048 kullanacak).
//
// Desen: EnglishPractice `app/backend/errors.py` (MIT) — sabit, sürümlü hata
// kategorileri. Kod alınmadı; kategori adları ve Türkçe etiketler bizimdir.
// Sınıflandırma değişirse [kErrorTaxonomyVersion] artırılır; eski olaylar
// kendi sürümleriyle okunur.

const int kErrorTaxonomyVersion = 1;

/// Sürüm 1 kategorileri. Olayda `errorType` yoksa (null) olay hata değildir
/// (ör. anlama bakmak — K-32: bakmak hata sayılmaz).
enum ErrorType {
  tense('tense', 'Zaman'),
  verbForm('verb_form', 'Fiil yapısı'),
  agreement('agreement', 'Özne-yüklem uyumu'),
  article('article', 'a / an / the'),
  preposition('preposition', 'Edat'),
  pronoun('pronoun', 'Zamir'),
  plural('plural', 'Çoğul'),
  wordOrder('word_order', 'Kelime sırası'),
  wordChoice('word_choice', 'Kelime seçimi'),
  missingOrExtra('missing_extra', 'Eksik ya da fazla kelime'),
  spelling('spelling', 'Yazım'),
  punctuation('punctuation', 'Noktalama'),

  /// Tekrar kartında anlam/biçim hatırlanamadı (yanlış seçim ya da Bilmiyorum).
  recall('recall', 'Hatırlama'),
  other('other', 'Diğer');

  const ErrorType(this.code, this.labelTr);

  final String code;
  final String labelTr;

  static ErrorType? parse(String? code) {
    if (code == null) return null;
    for (final t in values) {
      if (t.code == code) return t;
    }
    return ErrorType.other;
  }
}
