class ProfileOnScreen {
  final String name;
  final String bio;
  final String imageUrl;

  ProfileOnScreen(
      {required this.name, required this.bio, required this.imageUrl});
}

class ProfileData {
  final String uid;
  final String name;
  final String bio;

  ProfileData({required this.uid, required this.name, required this.bio});
}
