import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;

import '../features/account/application/account_providers.dart';
import '../features/grammar/application/grammar_providers.dart';
import '../features/hi/application/hi_providers.dart';
import '../features/library/application/library_providers.dart';
import '../features/notebook/application/notebook_providers.dart';
import '../features/profile/application/profile_providers.dart';
import '../features/story/application/story_providers.dart';
import '../features/topic_sets/application/topic_set_providers.dart';
import '../shared/state/safe_refresh.dart';

/// Cihazdaki öğrenme verisini okuyan bütün sağlayıcılar (sekmeler: Ana Sayfa,
/// Hikâye haritası, Defter, Profil, Hi paneli ve balonu, konu setleri).
final localDataProviders = <ProviderOrFamily>[
  storyProgressProvider,
  seasonMapProvider,
  reviewOverviewProvider,
  notebookEntriesProvider,
  clueBoardProvider,
  dailyGoalProvider,
  displayNameProvider,
  coachInputProvider,
  hiSuggestionProvider,
  hiBadgeProvider,
  weeklySummaryProvider,
  lookupCandidatesProvider,
  bridgeTaskProvider,
  hiKnowledgeProvider,
  seenTopicIntrosProvider,
  topicSetsProvider,
  deckKeysProvider,
  topicSetUnlockedByProvider,
  accountNudgeProvider,
  bookProgressProvider,
  libraryProvider,
  grammarProgressProvider,
  grammarListProvider,
];

/// Başka cihazdan veri geldi ya da yerel veri toplu değişti (H-038, H-056):
/// bütün sekmeler — görünmeyenler de — güvenle yeniden okur
/// ([invalidateAndFlush]). Uygulama kökünden ([HiVelzonApp]) çağrılır:
/// kökün aboneliği hiçbir zaman duraklatılmaz.
void refreshLocalData(WidgetRef ref) =>
    invalidateAndFlush(ref, localDataProviders);
