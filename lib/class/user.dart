class User {
  final int id;
  final String userName;
  final String firstName;
  final String lastName; 
  final String password;
  final String registerDate;
  final bool isHideMyName;
  final String imagePath;

  const User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.registerDate,
    required this.isHideMyName,
    required this.imagePath
  });

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id: json['id'] as int, 
      userName: json['username'] as String,
      firstName: json['nama_depan'] as String, 
      lastName: json['nama_belakang']as String, 
      password: json['password']as String,
      registerDate: json['tanggal_daftar']as String,
      isHideMyName: json['privasi'] as bool,
      imagePath: json['image_path'] as String
      );
  }
}