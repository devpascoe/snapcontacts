import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/person.dart';
import '../../domain/repositories/persons_repository.dart';

class DataPersonsRepository extends PersonsRepository {
  DataPersonsRepository() {
    prepareSampleData();
  }

  List<Map<String, dynamic>> sampleData = [
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
  ];

  void prepareSampleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? personsJsonString = prefs.getString("persons");
    if (personsJsonString == null ||
        personsJsonString.length == 0 ||
        personsJsonString == '[]') {
      // seed with sample data
      prefs.setString("persons", json.encode(sampleData));
    }
  }

  @override
  Future<List<Person>> getAllPersons() async {
    // Perform heavy work eg, http
    await new Future.delayed(
        const Duration(seconds: 1)); // simulate waiting for fetch
    // fetch from shared prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? personsJsonString = prefs.getString("persons");
    if (personsJsonString != null && personsJsonString.length > 0) {
      var personsData = json.decode(personsJsonString);
      var persons =
          List<Person>.from(personsData.map((p) => Person.fromJson(p)));

      return persons;
    }
    return [];
  }

  @override
  Future<Person?> getPerson(String uid) async {
    // Perform heavy work eg, http
    await new Future.delayed(
        const Duration(seconds: 1)); // simulate waiting for fetch
    // fetch from shared prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? personsJsonString = prefs.getString("persons");
    if (personsJsonString != null && personsJsonString.length > 0) {
      var personsData = json.decode(personsJsonString);
      return Person.fromJson(
          personsData.firstWhere((p) => p["uid"] == uid, orElse: null));
    }
    return null;
  }

  @override
  Future<Person> createPerson(Person person) async {
    // Perform heavy work eg, http
    await new Future.delayed(
        const Duration(seconds: 1)); // simulate waiting for fetch
    var personJson = person.toJson();
    // send the JSON up to the API...
    var responseJson = personJson;
    // persist to shared prefs
    var persons = await this.getAllPersons();
    persons.add(person);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("persons", json.encode(persons));
    return Person.fromJson(responseJson);
  }

  @override
  Future<Person?> updatePerson(Person person) async {
    // Perform heavy work eg, http
    await new Future.delayed(
        const Duration(seconds: 1)); // simulate waiting for fetch
    var personJson = person.toJson();
    // send the JSON up to the API...
    var responseJson = personJson;
    // persist to shared prefs
    var persons = await this.getAllPersons();
    int index = persons.indexWhere((p) => p.uid == person.uid);
    if (index >= 0) {
      persons[index] = person;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("persons", json.encode(persons));
      return Person.fromJson(responseJson);
    }
    return null;
  }

  @override
  Future<void> deletePerson(String uid) async {
    // Perform heavy work eg, http
    await new Future.delayed(
        const Duration(seconds: 1)); // simulate waiting for fetch
    // persist to shared prefs
    var persons = await this.getAllPersons();
    int index = persons.indexWhere((p) => p.uid == uid);
    if (index >= 0) {
      persons.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("persons", json.encode(persons));
      return;
    }
    return;
  }
}
