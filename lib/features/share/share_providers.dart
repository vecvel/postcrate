import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import 'native/native_share.dart';
import 'share_service.dart';

final nativeShareProvider = Provider<NativeShare>((ref) => NativeShare());

final shareServiceProvider = Provider<ShareService>(
  (ref) => ShareService(ref.watch(postsRepositoryProvider), ref.watch(nativeShareProvider)),
);

/// Platforms installed on this device, for ordering and labelling targets.
final installedAppsProvider = FutureProvider((ref) => ref.watch(nativeShareProvider).installedApps());
