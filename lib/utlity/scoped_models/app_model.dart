import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  String _name = '';

  String _email = '';

  String get username => _name;

  String get userEmail => _email;

  void setName(String name){
    this._name  = name;
  }

  void setEmail(String email) {
    this._email = email;
  }
}