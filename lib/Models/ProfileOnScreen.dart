class ProfileOnScreen {
  final String name;
  final String bio;
  final String email;
  final String imageUrl =
      "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80";
  final bool isDarkMode = false;

  ProfileOnScreen(
      {required this.name,
      required this.bio,
      required this.email,
      imageUrl,
      isDarkMode});
}

class ProfileData {
  final String uid;
  final String name;
  final String bio;
  final String email;
  final String status;
  final String imageUrl =
      "https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80";

  ProfileData({
    required this.uid,
    required this.name,
    required this.bio,
    required this.email,
    required this.status,
    imageUrl,
  });
}
