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
import 'package:snapcontacts/app/pages/person_page.dart';
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
    await tester.tap(find.text('Jim Halpert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Details').first);
    await tester.pumpAndSettle();
    expect(find.byType(PersonPage), findsOneWidget);
    expect(find.text('View Contact'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.text('Jim Halpert'), findsOneWidget);
    expect(find.text('Telephone: '), findsOneWidget);
    expect(find.text('0422222222'), findsOneWidget);
    expect(find.text('Email: '), findsOneWidget);
    expect(find.text('jim@dundermifflin.com'), findsOneWidget);
    expect(find.text('Created: '), findsOneWidget);
    expect(find.text('2/2/2021'), findsOneWidget);
  });

  testWidgets('Edit modal update person from detail',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(defaultData);
    await tester.pumpWidget(MyApp());
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(HomePage), findsOneWidget);
    await tester.tap(find.text('Jim Halpert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Details').first);
    await tester.pumpAndSettle();
    expect(find.byType(PersonPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(PersonEditModal), findsOneWidget);
    var firstNameTextField = find.text('Jim');
    await tester.enterText(firstNameTextField, 'James');
    expect(find.text('James'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('James Halpert'), findsOneWidget);
  });

  // TODO: test for empty telephone, email
}
