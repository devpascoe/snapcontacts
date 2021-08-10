import 'package:flutter/material.dart';
import 'package:snapcontacts/domain/entities/person.dart';

class PersonEditModal extends StatefulWidget {
  const PersonEditModal({Key? key, required this.onSave, this.person})
      : super(key: key);
  final Future Function(BuildContext context, String? uid, String firstName,
      String lastName, String? telephone, String? email) onSave;
  final Person? person;

  @override
  _PersonEditModalState createState() => _PersonEditModalState();
}

class _PersonEditModalState extends State<PersonEditModal> {
  double detailSpacing = 20;
  bool _saving = false;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _telephoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameController.text = widget.person?.firstName ?? '';
    _lastNameController = TextEditingController();
    _lastNameController.text = widget.person?.lastName ?? '';
    _telephoneController = TextEditingController();
    _telephoneController.text = widget.person?.telephone ?? '';
    _emailController = TextEditingController();
    _emailController.text = widget.person?.email ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (_firstNameController.text.length > 0 &&
        _lastNameController.text.length > 0) {
      setState(() {
        _saving = true;
      });
      // handle saving in parent
      await widget.onSave(
          context,
          widget.person?.uid,
          _firstNameController.text,
          _lastNameController.text,
          _telephoneController.text.length > 0
              ? _telephoneController.text
              : null,
          _emailController.text.length > 0 ? _emailController.text : null);
      setState(() {
        _saving = false;
      });
      Navigator.pop(context);
    }
  }

  Widget saveButton(BuildContext context) {
    return Center(
      child: _saving
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () => _save(context),
              child: Text('Save'),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, bottom: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'First Name',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' *',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'eg, Pam',
                  filled: true,
                ),
                autocorrect: false,
                controller: _firstNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: detailSpacing,
              ),
              Row(
                children: [
                  Text(
                    'Last Name',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' *',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'eg, Beasley',
                  filled: true,
                ),
                autocorrect: false,
                controller: _lastNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: detailSpacing,
              ),
              Text(
                'Telephone',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'eg, 0412345678',
                  filled: true,
                ),
                autocorrect: false,
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: detailSpacing,
              ),
              Text(
                'Email',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'eg, pam@dundermiflin.com',
                  filled: true,
                ),
                autocorrect: false,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: detailSpacing,
              ),
              saveButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
