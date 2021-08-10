import '../entities/person.dart';

abstract class PersonsRepository {
  Future<List<Person>> getAllPersons();
  Future<Person?> getPerson(String uid);
  Future<Person> createPerson(Person person);
  Future<Person?> updatePerson(Person person);
  Future<void> deletePerson(String uid);
}
