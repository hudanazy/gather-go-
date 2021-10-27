class UesrInfo {
  final String uid;
  final String name;
  final String bio;
  final String email;
  final String status;
  final String imageUrl = "https://picsum.photos/200/300";

  UesrInfo({
    required this.uid,
    required this.name,
    required this.bio,
    required this.email,
    required this.status,
    imageUrl,
  });
}
