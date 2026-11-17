import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/core/theme/app_theme.dart';
import 'package:postcrate/core/widgets/widgets.dart';

void main() {
  testWidgets('taps on the bar between tiles do not reach content behind it', (tester) async {
    var behind = 0;
    var tab = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(Brightness.light),
        home: Scaffold(
          extendBody: true,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => behind++,
            child: const SizedBox.expand(),
          ),
          bottomNavigationBar: PcBottomBar(
            items: const [
              PcBarItem(icon: PcIcons.library, label: 'Library'),
              PcBarItem(icon: PcIcons.home, label: 'Home'),
            ],
            index: 0,
            onTap: (i) => tab = i,
          ),
        ),
      ),
    );
    final bar = tester.getRect(find.byType(PcBottomBar));
    // Left edge of the bar, outside any tile, and the strip under the tiles.
    await tester.tapAt(Offset(bar.left + 4, bar.center.dy));
    await tester.tapAt(Offset(bar.center.dx, bar.bottom - 2));
    expect(behind, 0);
    await tester.tap(find.bySemanticsLabel('Home'));
    expect(tab, 1);
    // Content above the bar still gets taps.
    await tester.tapAt(Offset(bar.center.dx, bar.top - 40));
    expect(behind, 1);
  });
}
