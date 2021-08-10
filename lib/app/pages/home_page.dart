import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapcontacts/app/widgets/person_edit_modal.dart';
import 'package:snapcontacts/app/widgets/person_row.dart';
import 'package:snapcontacts/domain/entities/person.dart';
import 'package:snapcontacts/domain/providers/persons_provider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _onAddPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PersonEditModal(
          onSave: _onSave,
          person: null,
        );
      },
      isScrollControlled: true,
    );
  }

  Future<void> _onSave(BuildContext context, String? uid, String firstName,
      String lastName, String? telephone, String? email) async {
    if (uid == null) {
      var newPerson = Person(
          Uuid().v4(), firstName, lastName, telephone, email, DateTime.now());
      await context.read<PersonsProvider>().createPerson(newPerson);
    } else {
      print("handle error uid should not be returned when creating new person");
    }
  }

  void onExpand(BuildContext context, String uid) {
    context.read<PersonsProvider>().toggleExpand(uid);
  }

  void onDelete(BuildContext context, String uid) {
    context.read<PersonsProvider>().deletePerson(uid);
  }

  @override
  Widget build(BuildContext context) {
    var personsProvider = context.watch<PersonsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: context.read<PersonsProvider>().fetchAll,
        child: ListView.builder(
          itemCount: personsProvider.persons.length,
          itemBuilder: (BuildContext ctx, int index) => PersonRow(
            person: personsProvider.persons[index],
            onExpand: onExpand,
            onDelete: onDelete,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onAddPressed(context);
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
