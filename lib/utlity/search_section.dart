import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tongmoopa/widget/main_user.dart';

class SearchHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: TextField(
            cursorColor: Colors.grey,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 16,
              ),
              border: InputBorder.none,
              hintText: "Search google products",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainUser(),
                ),
              ),
              child: Icon(
                Icons.home,
                color: Colors.yellow,
              ),
            ),
            Container(),
            FlatButton(
              onPressed: () {},
              child: Icon(Icons.bookmark, color: Colors.yellow),
            ),
          ],
        ),
      ],
    );
  }
}
