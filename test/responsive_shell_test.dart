import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/widgets/shared/common/responsive_shell.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Logical sizes of real devices, smallest to largest.
const _devices = <String, Size>{
  'iPhone SE (1st)': Size(320, 568),
  'Small Android': Size(360, 640),
  'iPhone 13 mini': Size(375, 812),
  'iPhone 15': Size(393, 852),
  'Pixel 7': Size(412, 915),
  'iPhone Pro Max': Size(430, 932),
  'Foldable unfolded': Size(673, 841),
  'iPad': Size(820, 1180),
};

Widget _app({double textScale = 1}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: ResponsiveShell(child: child!),
    ),
    home: FigmaHeaderScaffold(
      title: 'Forgot Password',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the 6-digit OTP sent to your mobile number',
                textAlign: TextAlign.center,
              ),
              context.gapLg,
              const FigmaCard(child: TextField()),
              context.gapMd,
              FigmaButton(label: 'Send OTP', showArrow: true, onPressed: () {}),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  for (final entry in _devices.entries) {
    for (final textScale in [1.0, 1.5]) {
      testWidgets('${entry.key} @ text ${textScale}x has no overflow', (
        tester,
      ) async {
        tester.view.physicalSize = entry.value * 2;
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_app(textScale: textScale));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);

        final shown = tester.getSize(find.byType(FigmaButton)).width;
        expect(
          shown,
          lessThanOrEqualTo(AppDimensions.appMaxWidth),
          reason: 'content must be capped on wide screens',
        );
      });
    }
  }

  test('scale is bounded', () {
    expect(Responsive.scaleFor(100), 0.85);
    expect(Responsive.scaleFor(390), 1.0);
    expect(Responsive.scaleFor(2000), 1.2);
  });
}
