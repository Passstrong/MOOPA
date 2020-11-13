import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  String _name = '';

  String _lastname = '';

  String _age = '';

  String _birth = '';

  String _gender = '';

  String _email = '';

  String _telephone = '';

  String _imageUrl = '';

  double _latitude = 0.0;

  double _longtitude = 0.0;

  int _departmentNumber = 0;

  String get username => _name;

  String get userLastname => _lastname;

  String get userAge => _age;

  String get dateOfBirth => _birth;

  String get userGender => _gender;

  String get userEmail => _email;

  String get telephone => _telephone;

  String get imageProfile => _imageUrl;

  double get latittude => _latitude;

  double get longittude => _longtitude;

  int get department => _departmentNumber;

  void setName(String name) {
    this._name = name;
    notifyListeners();
  }

  void setLastName(String lastname) {
    this._lastname = lastname;
    notifyListeners();
  }

  void setAge(String age) {
    this._age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    this._gender = gender;
    notifyListeners();
  }

  void setBirth(String birth) {
    this._birth = birth;
    notifyListeners();
  }

  void setImage(String image) {
    this._imageUrl = image;
    notifyListeners();
  }

  void setEmail(String email) {
    this._email = email;
    notifyListeners();
  }

  void setTelephone(String telephone) {
    this._telephone = telephone;
    notifyListeners();
  }

  void setLocationLat(double latitude) {
    this._latitude = latitude;
    notifyListeners();
  }

  void setLocationLong(double longtitude) {
    this._longtitude = longtitude;
    notifyListeners();
  }

  void setDepartmentNumber(int departmentNumber) {
    this._departmentNumber = departmentNumber;
    notifyListeners();
  }
}
