// Türkçe metin yardımcıları (H-053): büyük/küçük harf ve sayı ekleri.
//
// Dart'ın `toUpperCase` / `toLowerCase` işlevleri dilden bağımsızdır:
// "kilitli".toUpperCase() → "KILITLI", "İ".toLowerCase() → "i̇". Arayüzde
// büyük harfli etiketler ve arama için bu yardımcılar kullanılır.

/// Türkçe büyük harf: i → İ, ı → I ("kilitli" → "KİLİTLİ").
String upperTr(String s) =>
    s.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

/// Türkçe küçük harf: İ → i, I → ı ("İSTASYON" → "istasyon").
String lowerTr(String s) =>
    s.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

/// Sayıya 3. tekil iyelik eki: "12 bölümden 1'i", "2'si", "6'sı", "10'u".
String possessiveNumber(int n) {
  const ones = {
    1: "'i",
    2: "'si",
    3: "'ü",
    4: "'ü",
    5: "'i",
    6: "'sı",
    7: "'si",
    8: "'i",
    9: "'u",
  };
  const tens = {
    1: "'u",
    2: "'si",
    3: "'u",
    4: "'ı",
    5: "'si",
    6: "'ı",
    7: "'i",
    8: "'i",
    9: "'ı",
  };
  final last = n.abs() % 10;
  if (last != 0) return '$n${ones[last]}';
  final t = (n.abs() ~/ 10) % 10;
  if (t != 0) return '$n${tens[t]}';
  if (n == 0) return "0'ı";
  return "$n'ü"; // yüz, bin …: güvenli varsayılan
}

/// Sayıya ayrılma (-den) eki: "Bölüm 1'den", "3'ten", "6'dan", "10'dan",
/// "20'den", "40'tan".
String ablativeNumber(int n) {
  // Okunan son sözcüğün son ünlüsü ve ünsüzü (bir, iki, üç, dört, beş, altı,
  // yedi, sekiz, dokuz; on, yirmi, otuz, kırk, elli, altmış, yetmiş, seksen,
  // doksan; yüz, bin).
  const ones = {
    1: "'den",
    2: "'den",
    3: "'ten",
    4: "'ten",
    5: "'ten",
    6: "'dan",
    7: "'den",
    8: "'den",
    9: "'dan",
  };
  const tens = {
    1: "'dan",
    2: "'den",
    3: "'dan",
    4: "'tan",
    5: "'den",
    6: "'tan",
    7: "'ten",
    8: "'den",
    9: "'dan",
  };
  final last = n.abs() % 10;
  if (last != 0) return '$n${ones[last]}';
  final t = (n.abs() ~/ 10) % 10;
  if (t != 0) return '$n${tens[t]}';
  if (n == 0) return "0'dan";
  return "$n'den"; // yüz → yüzden, bin → binden
}
