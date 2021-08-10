// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapcontacts/app/pages/home_page.dart';
import 'package:snapcontacts/app/widgets/person_edit_modal.dart';

import 'package:snapcontacts/main.dart';

void main() {
  var defaultData = {
    "persons": json.encode([
      {
        'uid': '11',
        'firstName': 'Michael',
        'lastName': 'Scott',
        'telephone': '0411111111',
        'email': 'michael@dundermifflin.com',
        'createdAt': '2021-01-01 10:00'
      },
      {
        'uid': '22',
        'firstName': 'Jim',
        'lastName': 'Halpert',
        'telephone': '0422222222',
        'email': 'jim@dundermifflin.com',
        'createdAt': '2021-02-02 10:00'
      }
    ])
  };

  testWidgets('Happy path', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Jim Halpert'), findsOneWidget);
    expect(find.text('0422222222'), findsOneWidget);
    expect(find.byIcon(Icons.contact_mail), findsNWidgets(2));
    expect(find.byIcon(Icons.call), findsNWidgets(2));
    expect(find.byIcon(Icons.arrow_upward), findsNWidgets(2));
    expect(find.text('Remove'), findsNWidgets(2));
    expect(find.text('Edit'), findsNWidgets(2));
    expect(find.text('Details'), findsNWidgets(2));
  });

  testWidgets('Tap to expand', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    final finder = find.byType(AnimatedOpacity);
    AnimatedOpacity widget = tester.firstWidget(finder);
    expect(widget.opacity, equals(0));
    await tester.tap(find.text('Jim Halpert'));
    await tester.pumpAndSettle();
    widget = tester.firstWidget(finder);
    expect(widget.opacity, equals(1));
  });

  testWidgets('Show edit modal from row', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    await tester.tap(find.text('Jim Halpert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').first);
    await tester.pumpAndSettle();
    expect(find.byType(PersonEditModal), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Jim'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Halpert'), findsOneWidget);
    expect(find.text('Telephone'), findsOneWidget);
    expect(find.text('0422222222'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('jim@dundermifflin.com'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Edit modal update person from row', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    await tester.tap(find.text('Jim Halpert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit').first);
    await tester.pumpAndSettle();
    expect(find.byType(PersonEditModal), findsOneWidget);
    var firstNameTextField = find.text('Jim');
    await tester.enterText(firstNameTextField, 'James');
    expect(find.text('James'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('James Halpert'), findsOneWidget);
  });

  testWidgets('Remove person', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    await tester.tap(find.text('Jim Halpert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove').first);
    await tester.pumpAndSettle();
    expect(find.text('Are you sure you want to remove Jim Halpert?'),
        findsOneWidget);
    expect(find.text('This will delete the record.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    var removeTextButton = find.widgetWithText(TextButton, 'Remove');
    expect(removeTextButton, findsOneWidget);
    await tester.tap(removeTextButton);
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.text('Jim Halpert'), findsNothing);
  });

  testWidgets('Tap telephone', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    await tester.tap(find.text('0422222222'));
    await tester.pumpAndSettle();
    expect(find.text('Call Jim Halpert?'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Call Jim Halpert?'), findsNothing);
  });

  // TODO: test for creating new person record
  // TODO: test for empty telephone, email
}
