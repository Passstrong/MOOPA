import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tongmoopa/utlity/scoped_models/app_model.dart';
import 'package:tongmoopa/widget/authen.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppModel model = AppModel();

    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        home: Authen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
