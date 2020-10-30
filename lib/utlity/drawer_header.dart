import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({Key key});

  @override
  Widget build(BuildContext context) {
    final user = ScopedModel.of<AppModel>(context, rebuildOnChange: false);
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/war.png'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: user.imageProfile.isNotEmpty
          ? Image.network(user.imageProfile)
          : Image.asset('images/theone.jpg'),
      accountName: Text(
        user.username ?? '',
        style: TextStyle(color: Colors.blue[900]),
      ),
      accountEmail: Text(
        user.userEmail ?? '',
        style: TextStyle(color: Colors.blue[900]),
      ),
    );
  }
}
