class AdminModel {
  final String username;
  final String avatar;
  final String phone;
  final String role;

  AdminModel({this.username, this.avatar, this.phone, this.role});

  factory AdminModel.fromDocument(Map<String, dynamic> doc) {
    return AdminModel(
        username: doc['username'],
        avatar: doc['avatar'],
        phone: doc['mobile_full_number'],
        role: doc['role']);
  }
  Map<String, dynamic> convertUser(AdminModel admin) {
    Map<String, dynamic> map = {};
    map['username'] = admin.username;
    map['avatar'] = admin.avatar;
    map['mobile_full_number'] = admin.phone;
    map['role'] = admin.role;
    return map;
  }

  Map<String, dynamic> toJson(AdminModel admin) => {
        'username': admin.username,
        'avatar': admin.avatar,
        'mobile_full_number': admin.phone,
        'role': admin.role,
      };
}

class AdminGridModel {
  final bool selected;
  final AdminModel adminModel;
  AdminGridModel(this.selected, this.adminModel);
}
