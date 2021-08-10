import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapcontacts/data/helpers/person_page_args.dart';

import 'domain/providers/persons_provider.dart';
import 'app/pages/home_page.dart';
import 'app/pages/person_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonsProvider()),
      ],
      // wrap app in provider's context for use within onGenerateRoute
      builder: (BuildContext providerContext, _) => MaterialApp(
        title: 'Snap Contacts',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/',
        // routes: {
        //   '/': (context) => HomePage(),
        //   '/person': (context) => PersonPage(),
        // },
        // using onGenerateRoute instead so we can pass params into constructor
        onGenerateRoute: (settings) {
          if (settings.name == '/person') {
            final args = settings.arguments as PersonPageArgs;
            var personsProvider = providerContext.read<PersonsProvider>();
            personsProvider.selectPerson(args.uid);
            return MaterialPageRoute(
              builder: (context) {
                return PersonPage(
                  uid: args.uid,
                );
              },
            );
          }
          // default
          return MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          );
        },
      ),
    );
  }
}
