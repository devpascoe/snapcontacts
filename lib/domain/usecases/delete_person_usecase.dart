import 'dart:async';

import '../repositories/persons_repository.dart';

class DeletePersonUseCase {
  final PersonsRepository personsRepository;
  DeletePersonUseCase(this.personsRepository);

  Future<void> deletePerson(String uid) async {
    try {
      return await personsRepository.deletePerson(uid);
    } catch (err) {
      print('An error occurred in deletePerson');
      print(err);
      return null;
    }
  }
}
