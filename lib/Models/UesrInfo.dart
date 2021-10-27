import 'dart:io';

class UesrInfo {
  final String uid;
  final String name;
  final String bio;
  final String email;
  final String status;
  final File imageUrl;

  UesrInfo(
      {required this.uid,
      required this.name,
      required this.bio,
      required this.email,
      required this.status,
      required this.imageUrl});
}
