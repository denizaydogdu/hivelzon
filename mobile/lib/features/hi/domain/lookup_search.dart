// "Bu ne demek?" (H-048): onaylı veride deterministik arama. Saf Dart.
//
// Kaynaklar: onaylı çevirilerden üretilen dizin (yalnızca kullanıcının açtığı
// bölümler), defter ve açılmış konu setleri. Yapay zekâ yok; eşleşme yoksa
// Hi "henüz bilmiyorum" der.

import '../../../shared/text/turkish.dart';
import '../../notebook/domain/notebook_item.dart';

enum LookupOrigin { episode, notebook, topicSet }

class LookupCandidate {
  const LookupCandidate({
    required this.item,
    required this.origin,
    this.alt = const [],
  });

  /// Görüntü ve ses için [NotebookItem] biçimi (kart sesi oynatıcısı çalar).
  final NotebookItem item;
  final LookupOrigin origin;

  /// Başka bağlamlardaki Türkçe karşılıklar.
  final List<String> alt;
}

/// Arama anahtarı: Türkçe küçük harf (İ → i, I → ı), sonra ı/i ve Türkçe
/// harfler katlanır (Türkçe klavyesi olmayan da bulsun: "kopru" → "köprü").
/// İngilizce "I" da "i" olur. Noktalama ve `…` atılır.
String foldForSearch(String s) {
  const map = {
    'ı': 'i',
    'ç': 'c',
    'ş': 's',
    'ğ': 'g',
    'ö': 'o',
    'ü': 'u',
    'â': 'a',
    'î': 'i',
    'û': 'u',
    'é': 'e',
  };
  final low = lowerTr(s.replaceAll('’', "'"));
  final b = StringBuffer();
  for (final r in low.runes) {
    final ch = String.fromCharCode(r);
    b.write(map[ch] ?? ch);
  }
  return b
      .toString()
      .replaceAll(RegExp(r"[^\p{L}\p{N}'\s]", unicode: true), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Sonuç sırası: tam eşleşme (İngilizce, sonra Türkçe) → sözcük başı →
/// içinde geçen. Aynı İngilizce ifade bir kez (önce defterdeki, sonra sesli).
List<LookupCandidate> searchLookup(
  String query,
  List<LookupCandidate> candidates, {
  int limit = 6,
}) {
  final q = foldForSearch(query);
  if (q.isEmpty) return const [];
  final scored = <(int, int, LookupCandidate)>[];
  for (final (i, c) in candidates.indexed) {
    final s = _score(q, c);
    if (s != null) scored.add((s, i, c));
  }
  scored.sort((a, b) {
    final s = a.$1.compareTo(b.$1);
    if (s != 0) return s;
    final o = _originRank(a.$3).compareTo(_originRank(b.$3));
    if (o != 0) return o;
    return a.$2.compareTo(b.$2);
  });
  final seen = <String>{};
  final out = <LookupCandidate>[];
  for (final (_, _, c) in scored) {
    if (!seen.add(foldForSearch(c.item.textEn))) continue;
    out.add(c);
    if (out.length >= limit) break;
  }
  return out;
}

int _originRank(LookupCandidate c) => switch (c.origin) {
  LookupOrigin.notebook => 0,
  LookupOrigin.episode => c.item.hasAudio ? 1 : 2,
  LookupOrigin.topicSet => 3,
};

int? _score(String q, LookupCandidate c) {
  final en = foldForSearch(c.item.textEn);
  final trs = [
    if (c.item.textTr != null) c.item.textTr!,
    ...c.alt,
  ].map(foldForSearch).toList();
  // Türkçe karşılıklar "/" ve "," ile ayrılmış birden çok anlam taşıyabilir.
  final trParts = {
    for (final t in trs) ...t.split(RegExp(r'\s*[/,;]\s*|\s+\(|\)')),
    ...trs,
  }.where((t) => t.isNotEmpty).toList();
  if (en == q) return 0;
  if (trParts.any((t) => t == q)) return 1;
  // Tek harfli sorgu yalnızca tam eşleşir ("a", "I").
  if (q.length < 2) return null;
  bool wordStart(String s) => s.startsWith(q) || s.contains(' $q');
  if (wordStart(en)) return 2;
  if (trParts.any(wordStart)) return 3;
  if (q.length >= 3 && en.contains(q)) return 4;
  if (q.length >= 3 && trParts.any((t) => t.contains(q))) return 5;
  return null;
}
