import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/features/welcome/presentation/screens/welcome_screen.dart';

Widget _welcomeAt(Size size) {
  return ProviderScope(
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const WelcomeScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'welcome onboarding adapts across phone, tablet and desktop',
    fileName: 'welcome_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _welcomeAt(s),
          ),
      ],
    ),
  );
}
