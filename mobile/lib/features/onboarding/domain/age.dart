/// Yaş beyanı (H-002, H-009): yalnızca doğum yılı sorulur, yalnızca bu
/// cihazda tutulur. Yaş takvim yılına göre hesaplanır (backend `Ages` ve
/// `ageAllowed` ile aynı: bu yıl − doğum yılı).
library;

/// - [under13]: uygulamanın tamamı hesapsız; hesap açma hiç gösterilmez.
/// - [teen]: 13–17; hesap isteğe bağlı (sonra, sakin kartla).
/// - [adult]: 18+; v1'deki serbest AI sohbeti yalnızca bu grupta (H-047).
enum AgeBand { under13, teen, adult }

const accountMinimumAge = 13;
const adultAge = 18;

AgeBand ageBandOf(int birthYear, DateTime now) {
  final age = now.toUtc().year - birthYear;
  if (age < accountMinimumAge) return AgeBand.under13;
  if (age < adultAge) return AgeBand.teen;
  return AgeBand.adult;
}

enum BirthYearError { empty, format, outOfRange }

/// En yaşlı kabul edilen yaş (yazım hatasını yakalamak için).
const _maxAge = 120;

/// Dört haneli, bu yıldan büyük olmayan ve en fazla 120 yıl önceki yıl.
BirthYearError? validateBirthYear(String raw, DateTime now) {
  final v = raw.trim();
  if (v.isEmpty) return BirthYearError.empty;
  if (!RegExp(r'^\d{4}$').hasMatch(v)) return BirthYearError.format;
  final year = int.parse(v);
  final thisYear = now.toUtc().year;
  if (year > thisYear || year < thisYear - _maxAge) {
    return BirthYearError.outOfRange;
  }
  return null;
}
