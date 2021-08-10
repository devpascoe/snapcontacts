import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapcontacts/app/widgets/person_edit_modal.dart';
import 'package:snapcontacts/domain/entities/person.dart';
import 'package:snapcontacts/domain/providers/persons_provider.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  Future<void> _onSave(BuildContext context, String? uid, String firstName,
      String lastName, String? telephone, String? email) async {
    if (uid != null) {
      var newPerson =
          Person(uid, firstName, lastName, telephone, email, DateTime.now());
      await context.read<PersonsProvider>().updatePerson(newPerson);
    } else {
      print("handle error with no uid returned when updating a person");
    }
  }

  Widget detailRow(BuildContext context, String title, String? value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$title: ',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? 'No value',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  void editPersonTapped(BuildContext context, Person? person) {
    if (person != null) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return PersonEditModal(
            onSave: _onSave,
            person: person,
          );
        },
        isScrollControlled: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var personsProvider = context.watch<PersonsProvider>();
    var person = personsProvider.selectedPerson;
    return Scaffold(
      appBar: AppBar(
        title: Text('View Contact'),
        actions: [
          GestureDetector(
            onTap: () {
              editPersonTapped(context, person);
            },
            child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: person != null
          ? Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      person.fullName(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          detailRow(context, 'Telephone', person.telephone),
                          detailRow(context, 'Email', person.email),
                          detailRow(context, 'Created',
                              '${person.createdAt.month}/${person.createdAt.day}/${person.createdAt.year}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
