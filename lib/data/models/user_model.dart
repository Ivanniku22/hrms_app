class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? siteId;
  final String? designation;
  final String? department;
  final String? manager;
  final String? contact;
  final String? site;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.siteId,
    this.designation,
    this.department,
    this.manager,
    this.contact,
    this.site,
  });

  factory UserModel.fromFirestore(
      String uid,
      Map<String, dynamic> data,
      ) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      siteId: data['siteId'],
      designation: data['designation'],
      department: data['department'],
      manager: data['manager'],
      contact: data['contact']?.toString(),
      site: data['site'],
    );
  }
}