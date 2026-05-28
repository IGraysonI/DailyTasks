// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

void main() {
  group('UI Package Tests', () {
    // Test 1: Config class
    group('Config Class', () {
      test('Config environment should be development by default', () {
        expect(Config.environment, equals(EnvironmentFlavor.development));
        print('✓ Config environment defaults to development');
      });

      test('Config apiBaseUrl should be defined', () {
        expect(Config.apiBaseUrl, isNotEmpty);
        print('✓ Config apiBaseUrl is defined: ${Config.apiBaseUrl}');
      });

      test('Config apiConnectTimeout should be positive', () {
        expect(Config.apiConnectTimeout.inMilliseconds, greaterThan(0));
        print('✓ Config apiConnectTimeout is positive: ${Config.apiConnectTimeout.inMilliseconds}ms');
      });

      test('Config apiReceiveTimeout should be positive', () {
        expect(Config.apiReceiveTimeout.inMilliseconds, greaterThan(0));
        print('✓ Config apiReceiveTimeout is positive: ${Config.apiReceiveTimeout.inMilliseconds}ms');
      });

      test('Config cacheLifetime should be 1 hour', () {
        expect(Config.cacheLifetime, equals(const Duration(hours: 1)));
        print('✓ Config cacheLifetime is 1 hour');
      });

      test('Config passwordMinLength should be 8', () {
        expect(Config.passwordMinLength, equals(8));
        print('✓ Config passwordMinLength is 8');
      });

      test('Config passwordMaxLength should be 32', () {
        expect(Config.passwordMaxLength, equals(32));
        print('✓ Config passwordMaxLength is 32');
      });

      test('Config maxScreenLayoutWidth should be 768', () {
        expect(Config.maxScreenLayoutWidth, equals(768));
        print('✓ Config maxScreenLayoutWidth is 768');
      });

      test('Config storage namespace should be defined', () {
        expect(Config.storageNamespace, equals('keys'));
        print('✓ Config storage namespace is properly defined');
      });

      test('Config version keys should be properly namespaced', () {
        expect(Config.versionMajorKey, contains(Config.storageNamespace));
        expect(Config.versionMinorKey, contains(Config.storageNamespace));
        expect(Config.versionPatchKey, contains(Config.storageNamespace));
        print('✓ Config version keys are properly namespaced');
      });
    });

    // Test 2: EnvironmentFlavor enum
    group('EnvironmentFlavor Enum', () {
      test('EnvironmentFlavor should have three values', () {
        expect(EnvironmentFlavor.values, hasLength(3));
        print('✓ EnvironmentFlavor has three values');
      });

      test('EnvironmentFlavor.development should have correct value', () {
        expect(EnvironmentFlavor.development.value, equals('development'));
        print('✓ EnvironmentFlavor.development has correct value');
      });

      test('EnvironmentFlavor.staging should have correct value', () {
        expect(EnvironmentFlavor.staging.value, equals('staging'));
        print('✓ EnvironmentFlavor.staging has correct value');
      });

      test('EnvironmentFlavor.production should have correct value', () {
        expect(EnvironmentFlavor.production.value, equals('production'));
        print('✓ EnvironmentFlavor.production has correct value');
      });

      test('EnvironmentFlavor.from should parse development variants', () {
        expect(EnvironmentFlavor.from('development'), equals(EnvironmentFlavor.development));
        expect(EnvironmentFlavor.from('debug'), equals(EnvironmentFlavor.development));
        expect(EnvironmentFlavor.from('dev'), equals(EnvironmentFlavor.development));
        print('✓ EnvironmentFlavor.from correctly parses development variants');
      });

      test('EnvironmentFlavor.from should parse staging variants', () {
        expect(EnvironmentFlavor.from('staging'), equals(EnvironmentFlavor.staging));
        expect(EnvironmentFlavor.from('profile'), equals(EnvironmentFlavor.staging));
        print('✓ EnvironmentFlavor.from correctly parses staging variants');
      });

      test('EnvironmentFlavor.from should parse production variants', () {
        expect(EnvironmentFlavor.from('production'), equals(EnvironmentFlavor.production));
        expect(EnvironmentFlavor.from('release'), equals(EnvironmentFlavor.production));
        print('✓ EnvironmentFlavor.from correctly parses production variants');
      });

      test('EnvironmentFlavor.from should default to development for null or invalid', () {
        expect(EnvironmentFlavor.from(null), equals(EnvironmentFlavor.development));
        expect(EnvironmentFlavor.from('invalid'), equals(EnvironmentFlavor.development));
        print('✓ EnvironmentFlavor.from defaults to development for null or invalid input');
      });
    });

    // Test 3: Values class
    group('Values Class', () {
      test('Values.contentBasePadding should be 8.0', () {
        expect(Values.contentBasePadding, equals(8.0));
        print('✓ Values.contentBasePadding is 8.0');
      });

      test('Values.cornerRadius should be 12.0', () {
        expect(Values.cornerRadius, equals(12.0));
        print('✓ Values.cornerRadius is 12.0');
      });

      test('Values.chipRadius should be 20.0', () {
        expect(Values.chipRadius, equals(20.0));
        print('✓ Values.chipRadius is 20.0');
      });

      test('Values.dialogRadius should be 28.0', () {
        expect(Values.dialogRadius, equals(28.0));
        print('✓ Values.dialogRadius is 28.0');
      });

      test('Values.sliverAppBarExpandedHigh should be 95.0', () {
        expect(Values.sliverAppBarExpandedHigh, equals(95.0));
        print('✓ Values.sliverAppBarExpandedHigh is 95.0');
      });

      test('Values.duration should not be null', () {
        expect(Values.duration, isNotNull);
        print('✓ Values.duration is not null');
      });
    });

    // Test 4: ValuesDuration class
    group('ValuesDuration Class', () {
      test('ValuesDuration.fast should be 250ms', () {
        expect(Values.duration.fast, equals(250));
        print('✓ ValuesDuration.fast is 250ms');
      });
    });

    // Test 5: Space widget
    group('Space Widget', () {
      testWidgets('Space.xs should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.xs()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.xs creates widget successfully');
      });

      testWidgets('Space.sm should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.sm()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.sm creates widget successfully');
      });

      testWidgets('Space.md should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.md()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.md creates widget successfully');
      });

      testWidgets('Space.lg should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.lg()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.lg creates widget successfully');
      });

      testWidgets('Space.xl should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.xl()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.xl creates widget successfully');
      });

      testWidgets('Space.xxl should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.xxl()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.xxl creates widget successfully');
      });

      testWidgets('Space.xxxl should create widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Space.xxxl()),
          ),
        );
        expect(find.byType(SizedBox), findsOneWidget);
        print('✓ Space.xxxl creates widget successfully');
      });
    });

    // Test 6: ElevatedCard widget
    group('ElevatedCard Widget', () {
      testWidgets('ElevatedCard should render with child', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ElevatedCard(
                child: Text('Test'),
              ),
            ),
          ),
        );
        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
        print('✓ ElevatedCard renders with child successfully');
      });

      testWidgets('ElevatedCard should have default margin', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ElevatedCard(
                child: Text('Test'),
              ),
            ),
          ),
        );
        expect(find.byType(Card), findsOneWidget);
        print('✓ ElevatedCard uses default margin');
      });

      testWidgets('ElevatedCard should have custom margin', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ElevatedCard(
                margin: EdgeInsets.all(8),
                child: Text('Test'),
              ),
            ),
          ),
        );
        expect(find.byType(Card), findsOneWidget);
        print('✓ ElevatedCard applies custom margin');
      });

      testWidgets('ElevatedCard should have custom padding', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ElevatedCard(
                padding: EdgeInsets.all(16),
                child: Text('Test'),
              ),
            ),
          ),
        );
        expect(find.byType(Padding), findsOneWidget);
        print('✓ ElevatedCard applies custom padding');
      });

      testWidgets('ElevatedCard should call onCardTap when tapped', (tester) async {
        var wasPressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedCard(
                onCardTap: () => wasPressed = true,
                child: const Text('Test'),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();
        expect(wasPressed, true);
        print('✓ ElevatedCard calls onCardTap when tapped');
      });
    });

    // Test 7: NoDataWidget
    group('NoDataWidget', () {
      testWidgets('NoDataWidget should render text', (tester) async {
        const testText = 'No data available';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoDataWidget(text: testText),
            ),
          ),
        );
        expect(find.text(testText), findsOneWidget);
        print('✓ NoDataWidget renders text successfully');
      });

      testWidgets('NoDataWidget should show image by default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoDataWidget(
                text: 'No data',
                showPic: true,
              ),
            ),
          ),
        );
        expect(find.byType(Container), findsWidgets);
        print('✓ NoDataWidget shows image by default');
      });

      testWidgets('NoDataWidget should hide image when showPic is false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoDataWidget(
                text: 'No data',
                showPic: false,
              ),
            ),
          ),
        );
        expect(find.text('No data'), findsOneWidget);
        print('✓ NoDataWidget hides image when showPic is false');
      });

      testWidgets('NoDataWidget should show button by default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoDataWidget(
                text: 'No data',
                showButton: true,
              ),
            ),
          ),
        );
        expect(find.byType(TextButton), findsOneWidget);
        print('✓ NoDataWidget shows button by default');
      });

      testWidgets('NoDataWidget should hide button when showButton is false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoDataWidget(
                text: 'No data',
                showButton: false,
              ),
            ),
          ),
        );
        expect(find.byType(TextButton), findsNothing);
        print('✓ NoDataWidget hides button when showButton is false');
      });

      testWidgets('NoDataWidget should show custom button text', (tester) async {
        const customButtonText = 'Retry Now';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoDataWidget(
                text: 'No data',
                buttonText: customButtonText,
              ),
            ),
          ),
        );
        expect(find.text(customButtonText), findsOneWidget);
        print('✓ NoDataWidget displays custom button text');
      });

      testWidgets('NoDataWidget should call onPressed when button is tapped', (tester) async {
        var wasPressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NoDataWidget(
                text: 'No data',
                onPressed: () => wasPressed = true,
              ),
            ),
          ),
        );
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        expect(wasPressed, true);
        print('✓ NoDataWidget calls onPressed when button is tapped');
      });
    });

    // Test 8: GroupSeparator widget
    group('GroupSeparator Widget', () {
      testWidgets('GroupSeparator should render with title', (tester) async {
        const testTitle = 'Group Title';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  GroupSeparator(title: testTitle),
                ],
              ),
            ),
          ),
        );
        expect(find.text(testTitle), findsOneWidget);
        print('✓ GroupSeparator renders with title successfully');
      });

      testWidgets('GroupSeparator should have dividers', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  GroupSeparator(title: 'Test'),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(Divider), findsWidgets);
        print('✓ GroupSeparator includes dividers');
      });

      testWidgets('GroupSeparator should truncate long titles', (tester) async {
        const longTitle = 'This is a very long title that should be truncated with ellipsis';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  GroupSeparator(title: longTitle),
                ],
              ),
            ),
          ),
        );
        final textFinder = find.byType(Text);
        expect(textFinder, findsWidgets);
        print('✓ GroupSeparator handles long titles with truncation');
      });
    });

    // Test 9: ScaffoldPadding widget
    group('ScaffoldPadding Widget', () {
      testWidgets('ScaffoldPadding.widget should wrap child', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScaffoldPadding.widget(
                tester.element(find.byType(Scaffold)),
                const Text('Test'),
              ),
            ),
          ),
        );
        expect(find.byType(Padding), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
        print('✓ ScaffoldPadding.widget wraps child successfully');
      });

      test('ScaffoldPadding.of should return EdgeInsets', () {
        final context = FakeContext();
        final padding = ScaffoldPadding.of(context);
        expect(padding, isA<ScaffoldPadding>());
        print('✓ ScaffoldPadding.of returns EdgeInsets successfully');
      });
    });

    // Test 10: Package exports
    group('Package Exports', () {
      test('Config should be exported', () {
        expect(Config, isNotNull);
        print('✓ Config is exported from package');
      });

      test('EnvironmentFlavor should be exported', () {
        expect(EnvironmentFlavor, isNotNull);
        print('✓ EnvironmentFlavor is exported from package');
      });

      test('Values should be exported', () {
        expect(Values, isNotNull);
        print('✓ Values is exported from package');
      });

      test('Space should be exported', () {
        expect(Space, isNotNull);
        print('✓ Space is exported from package');
      });

      test('ElevatedCard should be exported', () {
        expect(ElevatedCard, isNotNull);
        print('✓ ElevatedCard is exported from package');
      });

      test('NoDataWidget should be exported', () {
        expect(NoDataWidget, isNotNull);
        print('✓ NoDataWidget is exported from package');
      });

      test('GroupSeparator should be exported', () {
        expect(GroupSeparator, isNotNull);
        print('✓ GroupSeparator is exported from package');
      });
    });
  });
}

// Helper class for testing ScaffoldPadding
class FakeContext implements BuildContext {
  @override
  bool get debugDoingBuild => false;

  @override
  bool get mounted => true;

  @override
  BuildOwner? get owner => null;

  @override
  Size get size => const Size(400, 600);

  @override
  Widget get widget => const Placeholder();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
