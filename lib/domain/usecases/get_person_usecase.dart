import 'dart:async';

import '../entities/person.dart';
import '../repositories/persons_repository.dart';

class GetPersonUseCase {
  final PersonsRepository personsRepository;
  GetPersonUseCase(this.personsRepository);

  Future<Person?> getPerson(String uid) async {
    try {
      return await personsRepository.getPerson(uid);
    } catch (err) {
      print('An error occurred in getPerson');
      print(err);
      return null;
    }
  }
}
