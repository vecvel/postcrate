import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/widgets.dart';
import '../../features/share/link_capture.dart';
import '../../features/share/presentation/link_offer_sheet.dart';

/// Phone layout: bottom bar with Library, Home (center, default) and Backup.
/// Also hosts post-link capture, so a copied or shared-in link can be
/// attached from any tab.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const items = [
    PcBarItem(icon: CupertinoIcons.square_grid_2x2, label: 'Library'),
    PcBarItem(icon: CupertinoIcons.house, label: 'Home'),
    PcBarItem(icon: CupertinoIcons.cloud_upload, label: 'Backup'),
  ];

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(linkCaptureProvider.notifier).start());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LinkOffer?>(linkCaptureProvider, (_, offer) {
      if (offer != null) showLinkOfferSheet(context, ref, offer);
    });
    final shell = widget.shell;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: shell,
      bottomNavigationBar: PcBottomBar(
        items: AppShell.items,
        index: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
