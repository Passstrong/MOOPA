import 'package:flutter/material.dart';
import 'package:tongmoopa/widget/authen.dart';


main()=>runApp(MyApp());

 class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authen(),
      theme: ThemeData(primarySwatch: Colors.blue), //shade??
    );
  }
}


// Test
// class MyApp2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Authen(),
//       theme: ThemeData(primarySwatch: Color.),
//     );
//   }
// }