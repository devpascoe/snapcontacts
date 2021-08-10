import 'dart:async';

import '../entities/person.dart';
import '../repositories/persons_repository.dart';

class GetAllPersonsUseCase {
  final PersonsRepository personsRepository;
  GetAllPersonsUseCase(this.personsRepository);

  Future<List<Person>> getAllPersons() async {
    try {
      final persons = await personsRepository.getAllPersons();
      return persons;
    } catch (err) {
      print('An error occurred in getAllPersons');
      print(err);
      return [];
    }
  }
}
