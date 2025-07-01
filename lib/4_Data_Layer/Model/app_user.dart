import 'package:goiabeira/0_Core/Enums/user_rights.dart';

class AppUser {
  final int id;
  final int? idFirebase;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String country;
  final String age;
  final UserRights userRights;
  final DateTime creationDate;
  DateTime lastLogin;
  int loginCount;

  final String firebaseMessagingToken;

  AppUser({
    required this.id,
    this.idFirebase,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.country,
    required this.age,
    required this.userRights,
    required this.creationDate,
    required this.lastLogin,
    required this.loginCount,
    this.firebaseMessagingToken = '',
  });

  AppUser.empty()
    : id = 0,
      idFirebase = 0,
      email = '',
      firstName = '',
      lastName = '',
      phoneNumber = '',
      country = '',
      age = '',
      userRights = UserRights.none,
      firebaseMessagingToken = '',
      lastLogin = DateTime.now(),
      loginCount = 0,
      creationDate = DateTime.now();

  AppUser copyWith({
    int? id,
    int? idFirebase,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? country,
    String? age,
    UserRights? userRights,
    DateTime? creationDate,
    DateTime? lastLogin,
    int? loginCount,
    String? firebaseMessagingToken,
  }) {
    return AppUser(
      id: id ?? this.id,
      idFirebase: idFirebase ?? this.idFirebase,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      age: age ?? this.age,
      userRights: userRights ?? this.userRights,
      creationDate: creationDate ?? this.creationDate,
      lastLogin: lastLogin ?? this.lastLogin,
      loginCount: loginCount ?? this.loginCount,
      firebaseMessagingToken:
          firebaseMessagingToken ?? this.firebaseMessagingToken,
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idFirebase': idFirebase,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'country': country,
      'age': age,
      'userRights': userRights.toString(),
      'creationDate': creationDate.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'loginCount': loginCount,
      'firebaseMessagingToken': firebaseMessagingToken,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      idFirebase: json['idFirebase'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      country: json['country'],
      age: json['age'],
      userRights: UserRights.values.firstWhere(
        (e) => e.toString() == json['userRights'],
      ),
      creationDate: DateTime.parse(json['creationDate']),
      lastLogin: DateTime.parse(json['lastLogin']),
      loginCount: json['loginCount'],
      firebaseMessagingToken: json['firebaseMessagingToken'],
    );
  }

  @override
  String toString() {
    String idF =
        idFirebase == null ? 'idFirebase: null' : 'idFirebase: $idFirebase';
    return 'AppUser{id: $id, idFirebase: $idF  ,email: $email, firstName: $firstName, lastName: $lastName phoneNumber: $phoneNumber, country: $country, age: $age, userRights: $userRights, creationDate: $creationDate , firebaseMessagingToken: $firebaseMessagingToken , lastLogin: $lastLogin, loginCount: $loginCount}';
  }
}
