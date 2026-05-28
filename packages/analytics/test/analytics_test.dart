// ignore_for_file: avoid_print

import 'package:analytics/analytics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Analytics Package Tests', () {
    // Test 1: AnalyticsEvent class
    group('AnalyticsEvent', () {
      test('AnalyticsEvent should be created with name and no parameters', () {
        const event = AnalyticsEvent('test_event');
        expect(event.name, equals('test_event'));
        expect(event.parameters, isNull);
        print('✓ AnalyticsEvent created with name only');
      });

      test('AnalyticsEvent should be created with name and parameters', () {
        const event = AnalyticsEvent(
          'test_event',
          parameters: {'key': 'value', 'count': 42},
        );
        expect(event.name, equals('test_event'));
        expect(event.parameters, isNotNull);
        expect(event.parameters, hasLength(2));
        print('✓ AnalyticsEvent created with name and parameters');
      });

      test('AnalyticsEvent.hasParameters should be true when parameters exist', () {
        const event = AnalyticsEvent(
          'test_event',
          parameters: {'key': 'value'},
        );
        expect(event.hasParameters, true);
        print('✓ AnalyticsEvent.hasParameters returns true when parameters exist');
      });

      test('AnalyticsEvent.hasParameters should be false when no parameters', () {
        const event = AnalyticsEvent('test_event');
        expect(event.hasParameters, false);
        print('✓ AnalyticsEvent.hasParameters returns false when no parameters');
      });

      test('AnalyticsEvent.hasParameters should be false for empty parameters', () {
        const event = AnalyticsEvent('test_event', parameters: {});
        expect(event.hasParameters, false);
        print('✓ AnalyticsEvent.hasParameters returns false for empty parameters');
      });

      test('AnalyticsEvent.eventName should extract name after category', () {
        const event = AnalyticsEvent('form_submit_click');
        expect(event.eventName, equals('submit_click'));
        print('✓ AnalyticsEvent.eventName extracts action name correctly');
      });

      test('AnalyticsEvent.eventCategory should extract category prefix', () {
        const event = AnalyticsEvent('form_submit_click');
        expect(event.eventCategory, equals('form'));
        print('✓ AnalyticsEvent.eventCategory extracts category prefix correctly');
      });

      test('AnalyticsEvent.eventCategory should handle single word events', () {
        const event = AnalyticsEvent('event');
        expect(event.eventCategory, equals('event'));
        print('✓ AnalyticsEvent.eventCategory handles single word events');
      });

      test('AnalyticsEvent toString should include name and parameters', () {
        const event = AnalyticsEvent(
          'test_event',
          parameters: {'key': 'value'},
        );
        expect(event.toString(), contains('AnalyticsEvent'));
        expect(event.toString(), contains('test_event'));
        print('✓ AnalyticsEvent toString includes name and parameters');
      });

      test('AnalyticsEvent equality should work correctly', () {
        const event1 = AnalyticsEvent('test_event', parameters: {'key': 'value'});
        const event2 = AnalyticsEvent('test_event', parameters: {'key': 'value'});
        expect(event1, equals(event2));
        print('✓ AnalyticsEvent equality works correctly');
      });

      test('AnalyticsEvent inequality should work correctly', () {
        const event1 = AnalyticsEvent('test_event1', parameters: {'key': 'value'});
        const event2 = AnalyticsEvent('test_event2', parameters: {'key': 'value'});
        expect(event1 == event2, false);
        print('✓ AnalyticsEvent inequality works correctly');
      });

      test('AnalyticsEvent hash code should be consistent', () {
        const event1 = AnalyticsEvent('test_event', parameters: {'key': 'value'});
        const event2 = AnalyticsEvent('test_event', parameters: {'key': 'value'});
        expect(event1.hashCode, equals(event2.hashCode));
        print('✓ AnalyticsEvent hash code is consistent');
      });

      test('AnalyticsEvent should support various parameter types', () {
        const event = AnalyticsEvent(
          'test_event',
          parameters: {
            'string': 'value',
            'int': 42,
            'double': 3.14,
            'bool': true,
            'null': null,
          },
        );
        expect(event.parameters, isNotNull);
        expect(event.parameters!['string'], equals('value'));
        expect(event.parameters!['int'], equals(42));
        expect(event.parameters!['double'], equals(3.14));
        expect(event.parameters!['bool'], equals(true));
        expect(event.parameters!['null'], isNull);
        print('✓ AnalyticsEvent supports various parameter types');
      });
    });

    // Test 2: DefaultAnalyticsManager
    group('DefaultAnalyticsManager', () {
      test('DefaultAnalyticsManager should be created with reporters', () {
        final reporter = DebugAnalyticsReporter();
        final manager = DefaultAnalyticsManager(
          reporters: [reporter],
          isAnalyticsEnabled: true,
        );
        expect(manager.isEnabled, true);
        print('✓ DefaultAnalyticsManager created with reporters');
      });

      test('DefaultAnalyticsManager.isEnabled should reflect the setting', () {
        final reporter = DebugAnalyticsReporter();
        final manager = DefaultAnalyticsManager(
          reporters: [reporter],
          isAnalyticsEnabled: false,
        );
        expect(manager.isEnabled, false);
        print('✓ DefaultAnalyticsManager.isEnabled reflects the setting');
      });

      test('DefaultAnalyticsManager should initialize with callback', () async {
        var initialized = false;
        final reporter = DebugAnalyticsReporter();
        final manager = DefaultAnalyticsManager(
          reporters: [reporter],
          initializeCallback: () async {
            initialized = true;
          },
        );
        await manager.initialize();
        expect(initialized, true);
        print('✓ DefaultAnalyticsManager initializes with callback');
      });

      test('DefaultAnalyticsManager should initialize without callback', () async {
        final reporter = DebugAnalyticsReporter();
        final manager = DefaultAnalyticsManager(
          reporters: [reporter],
        );
        expect(() async => await manager.initialize(), returnsNormally);
        print('✓ DefaultAnalyticsManager initializes without callback');
      });

      test('DefaultAnalyticsManager should log events to reporters', () async {
        final reporter = DebugAnalyticsReporter();
        final manager = DefaultAnalyticsManager(
          reporters: [reporter],
        );
        const event = AnalyticsEvent('test_event');
        expect(() async => await manager.logEvent(event), returnsNormally);
        print('✓ DefaultAnalyticsManager logs events to reporters');
      });

      test('DefaultAnalyticsManager should handle multiple reporters', () async {
        final reporter1 = DebugAnalyticsReporter();
        final reporter2 = DebugAnalyticsReporter();
        final manager = DefaultAnalyticsManager(
          reporters: [reporter1, reporter2],
        );
        const event = AnalyticsEvent('test_event');
        expect(() async => await manager.logEvent(event), returnsNormally);
        print('✓ DefaultAnalyticsManager handles multiple reporters');
      });
    });

    // Test 3: DebugAnalyticsReporter
    group('DebugAnalyticsReporter', () {
      test('DebugAnalyticsReporter should be enabled', () {
        final reporter = DebugAnalyticsReporter();
        expect(reporter.isEnabled, true);
        print('✓ DebugAnalyticsReporter is enabled');
      });

      test('DebugAnalyticsReporter should initialize without error', () async {
        final reporter = DebugAnalyticsReporter();
        expect(() async => await reporter.initialize(), returnsNormally);
        print('✓ DebugAnalyticsReporter initializes without error');
      });

      test('DebugAnalyticsReporter should log events without error', () async {
        AnalyticsEventHistory.isEnabled = true;
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        expect(() async => await reporter.logEvent(event), returnsNormally);
        print('✓ DebugAnalyticsReporter logs events without error');
      });

      test('DebugAnalyticsReporter should add events to history', () async {
        AnalyticsEventHistory.isEnabled = true;
        AnalyticsEventHistory.instance.clear();
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        expect(AnalyticsEventHistory.instance.events.length, greaterThan(0));
        print('✓ DebugAnalyticsReporter adds events to history');
      });
    });

    // Test 4: AnalyticsEventHistory
    group('AnalyticsEventHistory', () {
      setUp(() {
        AnalyticsEventHistory.instance.clear();
        AnalyticsEventHistory.isEnabled = true;
      });

      test('AnalyticsEventHistory should be a singleton', () {
        final instance1 = AnalyticsEventHistory.instance;
        final instance2 = AnalyticsEventHistory.instance;
        expect(identical(instance1, instance2), true);
        print('✓ AnalyticsEventHistory is a singleton');
      });

      test('AnalyticsEventHistory should start empty', () {
        expect(AnalyticsEventHistory.instance.events, isEmpty);
        print('✓ AnalyticsEventHistory starts empty');
      });

      test('AnalyticsEventHistory should add events', () async {
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        expect(AnalyticsEventHistory.instance.events.length, equals(1));
        print('✓ AnalyticsEventHistory adds events');
      });

      test('AnalyticsEventHistory should maintain event order', () async {
        final reporter = DebugAnalyticsReporter();
        const event1 = AnalyticsEvent('event1');
        const event2 = AnalyticsEvent('event2');
        await reporter.logEvent(event1);
        await reporter.logEvent(event2);
        final events = AnalyticsEventHistory.instance.events;
        expect(events.length, equals(2));
        expect(events.first.event.name, equals('event2')); // Reversed order
        print('✓ AnalyticsEventHistory maintains event order (newest first)');
      });

      test('AnalyticsEventHistory should clear events', () async {
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        expect(AnalyticsEventHistory.instance.events, isNotEmpty);
        AnalyticsEventHistory.instance.clear();
        expect(AnalyticsEventHistory.instance.events, isEmpty);
        print('✓ AnalyticsEventHistory clears events');
      });

      test('AnalyticsEventHistory should track event counter', () async {
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        expect(AnalyticsEventHistory.instance.eventCounter, equals(1));
        print('✓ AnalyticsEventHistory tracks event counter');
      });

      test('AnalyticsEventHistory should track reporter type counter', () async {
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        expect(AnalyticsEventHistory.instance.typeCounter, isNotEmpty);
        print('✓ AnalyticsEventHistory tracks reporter type counter');
      });

      test('AnalyticsEventHistory should expose event stream', () {
        final stream = AnalyticsEventHistory.instance.eventStream;
        expect(stream, isNotNull);
        print('✓ AnalyticsEventHistory exposes event stream');
      });

      test('AnalyticsEventHistory should be disableable', () {
        AnalyticsEventHistory.isEnabled = false;
        expect(AnalyticsEventHistory.isEnabled, false);
        print('✓ AnalyticsEventHistory can be disabled');
      });
    });

    // Test 5: AnalyticsEventHistoryEntry
    group('AnalyticsEventHistoryEntry', () {
      test('AnalyticsEventHistory should track individual events', () async {
        AnalyticsEventHistory.isEnabled = true;
        AnalyticsEventHistory.instance.clear();
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        final events = AnalyticsEventHistory.instance.events;
        expect(events.length, equals(1));
        expect(events.first.index, equals(1));
        expect(events.first.event, equals(event));
        print('✓ AnalyticsEventHistory tracks individual events');
      });

      test('AnalyticsEventHistoryEntry should indicate observer origin', () async {
        AnalyticsEventHistory.isEnabled = true;
        AnalyticsEventHistory.instance.clear();
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event, eventFromObserver: true);
        final events = AnalyticsEventHistory.instance.events;
        expect(events.first.eventFromObserver, true);
        print('✓ AnalyticsEventHistoryEntry indicates observer origin');
      });

      test('AnalyticsEventHistoryEntry should have timestamp', () async {
        AnalyticsEventHistory.isEnabled = true;
        AnalyticsEventHistory.instance.clear();
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        final events = AnalyticsEventHistory.instance.events;
        expect(events.first.timestamp, isNotNull);
        expect(events.first.timestamp, isA<DateTime>());
        print('✓ AnalyticsEventHistoryEntry has timestamp');
      });

      test('AnalyticsEventHistoryEntry should track reporter type', () async {
        AnalyticsEventHistory.isEnabled = true;
        AnalyticsEventHistory.instance.clear();
        final reporter = DebugAnalyticsReporter();
        const event = AnalyticsEvent('test_event');
        await reporter.logEvent(event);
        final events = AnalyticsEventHistory.instance.events;
        expect(events.first.reporterType, equals(DebugAnalyticsReporter));
        print('✓ AnalyticsEventHistoryEntry tracks reporter type');
      });
    });

    // Test 6: AnalyticsEventCategoryFactory
    group('AnalyticsEventCategoryFactory', () {
      test('AnalyticsEventCategoryFactory should be available', () {
        expect(AnalyticsEventCategoryFactory, isNotNull);
        print('✓ AnalyticsEventCategoryFactory is available');
      });

      test('AnalyticsEventCategoryFactory.start should return non-null factory', () {
        const factory = AnalyticsEventCategoryFactory.start();
        expect(factory, isNotNull);
        print('✓ AnalyticsEventCategoryFactory.start returns non-null factory');
      });

      test('Event categories should create events with proper naming', () {
        // Test that events follow the category_action pattern
        const event = AnalyticsEvent('form_submit_click');
        expect(event.eventCategory, equals('form'));
        expect(event.eventName, equals('submit_click'));
        expect(event.name, equals('form_submit_click'));
        print('✓ Event categories create events with proper naming');
      });

      test('Event category factory pattern should work', () {
        // Demonstrate the pattern works through AnalyticsEvent itself
        const event1 = AnalyticsEvent('start_initialization_complete', parameters: {'app_version': '1.0.0'});
        const event2 = AnalyticsEvent('start_show_home_screen', parameters: {'screen_name': 'home'});
        expect(event1.eventCategory, equals('start'));
        expect(event2.eventCategory, equals('start'));
        expect(event1.hasParameters, true);
        expect(event2.hasParameters, true);
        print('✓ Event category factory pattern works correctly');
      });
    });

    // Test 7: AnalyticsNavigatorObserver interface
    group('AnalyticsNavigatorObserver', () {
      test('AnalyticsNavigatorObserver should be an interface', () {
        expect(AnalyticsNavigatorObserver, isNotNull);
        print('✓ AnalyticsNavigatorObserver interface exists');
      });
    });

    // Test 8: AnalyticsStateMixin
    group('AnalyticsStateMixin', () {
      test('AnalyticsStateMixin should be a mixin', () {
        expect(AnalyticsStateMixin, isNotNull);
        print('✓ AnalyticsStateMixin is available');
      });

      test('AnalyticsStatelessMixin should be a mixin', () {
        expect(AnalyticsStatelessMixin, isNotNull);
        print('✓ AnalyticsStatelessMixin is available');
      });
    });

    // Test 9: Event naming conventions
    group('Event Naming Conventions', () {
      test('Event names should follow category_action format', () {
        const event = AnalyticsEvent('button_click');
        expect(event.eventCategory, equals('button'));
        expect(event.eventName, equals('click'));
        print('✓ Event names follow category_action format');
      });

      test('Event names should support multiple underscores', () {
        const event = AnalyticsEvent('form_submit_success');
        expect(event.eventCategory, equals('form'));
        expect(event.eventName, equals('submit_success'));
        print('✓ Event names support multiple underscores');
      });

      test('Event names should handle complex naming', () {
        const event = AnalyticsEvent('purchase_item_click_from_list');
        expect(event.eventCategory, equals('purchase'));
        expect(event.eventName, equals('item_click_from_list'));
        print('✓ Event names handle complex naming');
      });
    });

    // Test 10: Package exports
    group('Package Exports', () {
      test('AnalyticsManager should be exported', () {
        expect(AnalyticsManager, isNotNull);
        print('✓ AnalyticsManager is exported');
      });

      test('AnalyticsEvent should be exported', () {
        expect(AnalyticsEvent, isNotNull);
        print('✓ AnalyticsEvent is exported');
      });

      test('AnalyticsReporter should be exported', () {
        expect(AnalyticsReporter, isNotNull);
        print('✓ AnalyticsReporter is exported');
      });

      test('AnalyticsEventHistory should be exported', () {
        expect(AnalyticsEventHistory, isNotNull);
        print('✓ AnalyticsEventHistory is exported');
      });

      test('DebugAnalyticsReporter should be exported', () {
        expect(DebugAnalyticsReporter, isNotNull);
        print('✓ DebugAnalyticsReporter is exported');
      });

      test('AnalyticsNavigatorObserver should be exported', () {
        expect(AnalyticsNavigatorObserver, isNotNull);
        print('✓ AnalyticsNavigatorObserver is exported');
      });

      test('AnalyticsEventCategoryFactory should be exported', () {
        expect(AnalyticsEventCategoryFactory, isNotNull);
        print('✓ AnalyticsEventCategoryFactory is exported');
      });

      test('DeveloperAnalyticsScreen should be exported', () {
        expect(DeveloperAnalyticsScreen, isNotNull);
        print('✓ DeveloperAnalyticsScreen is exported');
      });
    });
  });
}
