/// Öğren sekmesinin üç bölümü (H-103; eski adıyla "Hikâye sekmesi"):
/// **Hikâye** (Sezon haritası) · **Kitaplık** (H-067) · **Dilbilgisi** (H-078).
///
/// [code] cihazdaki kayıtta ve derin bağlantıda (`/hikaye?bolum=kitaplik`)
/// kullanılır; değiştirilmez (eski kayıtlar okunamaz olur).
enum LearnSection {
  story('hikaye'),
  library('kitaplik'),
  grammar('dilbilgisi');

  const LearnSection(this.code);

  final String code;

  /// Bilinmeyen ya da boş kod `null` döner (varsayılana düşülür).
  static LearnSection? parse(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}
