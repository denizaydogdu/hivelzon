import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/learn_section_store.dart';
import '../domain/learn_section.dart';

/// Öğren sekmesinde görünen bölüm (H-103).
///
/// İlk değer **Hikâye**; cihazdaki son seçim gelince ona geçer. Kullanıcı
/// seçimi ya da derin bağlantı ([select]) kayıt okunmadan önce gelirse
/// kayıt onu ezmez (açık seçim kazanır). Okuma/yazma hatası akışı durdurmaz.
class LearnSectionNotifier extends Notifier<LearnSection> {
  bool _chosen = false;

  @override
  LearnSection build() {
    _chosen = false;
    unawaited(_restore());
    return LearnSection.story;
  }

  Future<void> _restore() async {
    LearnSection? saved;
    try {
      saved = await ref.read(learnSectionStoreProvider).load();
    } on Object catch (e) {
      debugPrint('[H103] son bölüm okunamadı: $e');
    }
    if (saved == null || _chosen || !ref.mounted) return;
    state = saved;
  }

  /// Kullanıcı seçimi ya da derin bağlantı: hemen gösterilir ve son seçim
  /// olarak cihaza yazılır.
  void select(LearnSection section) {
    _chosen = true;
    state = section;
    unawaited(_save(section));
  }

  Future<void> _save(LearnSection section) async {
    try {
      await ref.read(learnSectionStoreProvider).save(section);
    } on Object catch (e) {
      debugPrint('[H103] son bölüm yazılamadı: $e');
    }
  }
}

final learnSectionProvider =
    NotifierProvider<LearnSectionNotifier, LearnSection>(
      LearnSectionNotifier.new,
    );
