import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snapcontacts/data/repositories/data_persons_repository.dart';
import 'package:snapcontacts/domain/entities/person.dart';
import 'package:snapcontacts/domain/usecases/create_person_usecase.dart';
import 'package:snapcontacts/domain/usecases/delete_person_usecase.dart';
import 'package:snapcontacts/domain/usecases/get_all_persons_usecase.dart';
import 'package:snapcontacts/domain/usecases/get_person_usecase.dart';
import 'package:snapcontacts/domain/usecases/update_person_usecase.dart';

class PersonsProvider with ChangeNotifier {
  PersonsProvider() {
    this.fetchAll();
  }

  List<Person> _persons = [];
  Person? _selectedPerson;

  List<Person> get persons => _persons;
  Person? get selectedPerson => _selectedPerson;

  Future<void> fetchAll() async {
    var getAllPersonsUseCase =
        new GetAllPersonsUseCase(new DataPersonsRepository());
    _persons = await getAllPersonsUseCase.getAllPersons();
    _persons.sort(
        (a, b) => a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
    notifyListeners();
  }

  Future<void> createPerson(Person person) async {
    var createPersonUseCase =
        new CreatePersonUseCase(new DataPersonsRepository());
    var newPerson = await createPersonUseCase.createPerson(person);
    if (newPerson != null) {
      _persons.add(newPerson);
      _persons.sort((a, b) =>
          a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
      notifyListeners();
    } else {
      print('TODO: Unable to save...');
    }
  }

  Future<void> updatePerson(Person person) async {
    // update api
    var updatePersonUseCase =
        new UpdatePersonUseCase(new DataPersonsRepository());
    var newPerson = await updatePersonUseCase.updatePerson(person);
    if (newPerson != null) {
      // update persons
      int index = _persons.indexWhere((p) => p.uid == newPerson.uid);
      if (index >= 0) {
        _persons[index] = newPerson;
        _persons.sort((a, b) =>
            a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
        notifyListeners();
      } else {
        print('TODO: Unable to find the record...');
      }
      // update selectedPerson if applicable
      if (_selectedPerson != null && _selectedPerson?.uid == person.uid) {
        _selectedPerson = newPerson;
        notifyListeners();
      }
    } else {
      print('TODO: Unable to save...');
    }
  }

  void toggleExpand(String uid) {
    int index = _persons.indexWhere((p) => p.uid == uid);
    if (index >= 0) {
      _persons[index].expanded = !_persons[index].expanded;
      notifyListeners();
    } else {
      print('TODO: Unable to find the record...');
    }
  }

  void deletePerson(String uid) async {
    int index = _persons.indexWhere((p) => p.uid == uid);
    if (index >= 0) {
      _persons.removeAt(index);
      notifyListeners();
    } else {
      print('TODO: Unable to find the record...');
    }
    var deletePersonUseCase =
        new DeletePersonUseCase(new DataPersonsRepository());
    await deletePersonUseCase.deletePerson(uid);
  }

  void selectPerson(String uid) async {
    _selectedPerson = null;
    notifyListeners();
    // first fetch from memory
    int index = _persons.indexWhere((p) => p.uid == uid);
    if (index >= 0) {
      _selectedPerson = _persons[index];
      notifyListeners();
      return;
    }
    // not found in memory, fetch from api
    var getPersonUseCase = new GetPersonUseCase(new DataPersonsRepository());
    Person? person = await getPersonUseCase.getPerson(uid);
    if (person != null) {
      _selectedPerson = person;
      notifyListeners();
      return;
    }
    print('TODO: Unable to find the record...');
  }
}
