import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:snapcontacts/app/widgets/person_edit_modal.dart';
import 'package:snapcontacts/data/helpers/person_page_args.dart';
import 'package:snapcontacts/domain/entities/person.dart';
import 'package:snapcontacts/domain/providers/persons_provider.dart';

class PersonRow extends StatelessWidget {
  const PersonRow(
      {Key? key,
      required this.person,
      required this.onExpand,
      required this.onDelete})
      : super(key: key);
  final Person person;
  final Function(BuildContext context, String uid) onExpand;
  final Function(BuildContext context, String uid) onDelete;

  Future<dynamic> handleDeleteTapped(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Are you sure you want to remove ${person.fullName()}?'),
        content: Text('This will delete the record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Remove');
              onDelete(context, person.uid);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> handleTelephoneTapped(BuildContext context) {
    return person.telephone == null
        ? showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Unable to call ${person.fullName()}?'),
              content: Text(
                'This contact has not entered any telephone details.',
                style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Close'),
                  child: Text('Close'),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Call ${person.fullName()}?'),
              content: Text(
                'Apologies, for now you will have to dial ${person.telephone} yourself :)',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Close'),
                  child: Text('Close'),
                ),
              ],
            ),
          );
  }

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

  Widget infoRow(BuildContext context, double angle) {
    return ListTile(
      leading: Icon(Icons.contact_mail),
      title: Text(person.fullName()),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => handleTelephoneTapped(context),
            child: Chip(
              label: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.call, size: 18),
                  ),
                  Text(person.telephone ?? 'No number'),
                ],
              ),
            ),
          ),
        ],
      ),
      trailing: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        child: Icon(Icons.arrow_upward, size: 32),
        transform: Matrix4Transform()
            .rotateByCenterDegrees(angle, Size(32, 32))
            .matrix4,
      ),
    );
  }

  void handleEditTapped(BuildContext context) {
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

  Widget expandableRow(BuildContext context, double height, double opacity) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: height,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: opacity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              icon: Icon(Icons.remove_circle),
              onPressed: () => handleDeleteTapped(context),
              label: Text('Remove'),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    handleEditTapped(context);
                  },
                  label: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white70, onPrimary: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.info_outline),
                    onPressed: () => Navigator.of(context).pushNamed(
                      '/person',
                      arguments: PersonPageArgs(person.uid),
                    ),
                    label: Text('Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = person.expanded ? 66 : 0;
    double _opacity = person.expanded ? 1 : 0;
    double _angle = person.expanded ? 180 : 90;

    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => onExpand(context, person.uid),
          child: Column(
            children: [
              infoRow(context, _angle),
              expandableRow(context, _height, _opacity),
            ],
          ),
        ),
      ),
    );
  }
}
