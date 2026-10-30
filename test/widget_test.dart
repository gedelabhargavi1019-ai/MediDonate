import 'package:flutter_test/flutter_test.dart';

import 'package:medidonate/main.dart';

void main() {
  testWidgets('shows the app splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MediDonateApp());

    expect(find.text('MediDonate'), findsOneWidget);
    expect(find.text('Connecting Hearts Through Medicine'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
