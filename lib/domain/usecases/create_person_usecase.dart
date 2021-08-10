import 'dart:async';

import '../entities/person.dart';
import '../repositories/persons_repository.dart';

class CreatePersonUseCase {
  final PersonsRepository personsRepository;
  CreatePersonUseCase(this.personsRepository);

  Future<Person?> createPerson(Person person) async {
    try {
      return await personsRepository.createPerson(person);
    } catch (err) {
      print('An error occurred in createPerson');
      print(err);
      return null;
    }
  }
}
