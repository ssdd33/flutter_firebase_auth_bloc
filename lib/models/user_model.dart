import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String profileImage;
  final int point;
  final String rank;

  const User(
      {required this.id,
      required this.email,
      required this.name,
      required this.profileImage,
      required this.point,
      required this.rank});

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;
    return User(
        id: userDoc.id,
        email: userData!['email'],
        name: userData['name'],
        profileImage: userData['profileImage'],
        point: userData['point'],
        rank: userData['rank']);
  }
  factory User.initial() {
    return const User(
      id: '',
      email: '',
      name: '',
      profileImage: '',
      point: -1,
      rank: '',
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      email,
      name,
      profileImage,
      point,
      rank,
    ];
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, profileImage: $profileImage, point: $point, rank: $rank)';
  }
}
