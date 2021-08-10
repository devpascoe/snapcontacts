class Person {
  final String uid;
  final String firstName;
  final String lastName;
  final String? telephone;
  final String? email;
  final DateTime createdAt;
  bool expanded = false;
  Person(this.uid, this.firstName, this.lastName, this.telephone, this.email,
      this.createdAt);

  @override
  String toString() => '$firstName $lastName';

  String fullName() => '$firstName $lastName';

  Person.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        telephone = json['telephone'],
        email = json['email'],
        createdAt = DateTime.parse(json['createdAt']);

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'telephone': telephone,
        'email': email,
        'createdAt': createdAt.toString(),
      };
}
