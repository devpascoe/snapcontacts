import 'dart:async';

import '../entities/person.dart';
import '../repositories/persons_repository.dart';

class UpdatePersonUseCase {
  final PersonsRepository personsRepository;
  UpdatePersonUseCase(this.personsRepository);

  Future<Person?> updatePerson(Person person) async {
    try {
      return await personsRepository.updatePerson(person);
    } catch (err) {
      print('An error occurred in updatePerson');
      print(err);
      return null;
    }
  }
}
