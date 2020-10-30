import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tongmoopa/utlity/normal_dialog.dart';
import 'package:tongmoopa/model/list_item_str.dart';

import '../model/list_item_str.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File file;

  String urlAvatar,
      name,
      lastName,
      gender,
      age,
      birth,
      email,
      password,
      department,
      province,
      sosDepartment,
      type = 'User';

  List<ListItem> _dropdownItems = [
    ListItem("User", "User"),
    ListItem("SOS", "SOS"),
  ];

  List<ListItem> _proviceList = [
    ListItem("กรุงเทพ", "กรุงเทพ"),
    ListItem("กระบี่", "กระบี่"),
    ListItem("กาญจนบุรี", "กาญจนบุรี"),
    ListItem("กาฬสินธุ์", "กาฬสินธุ์"),
    ListItem(" กำแพงเพชร", " กำแพงเพชร"),
    ListItem("ขอนแก่น", "ขอนแก่น"),
    ListItem("จันทบุรี", "จันทบุรี"),
    ListItem("ฉะเชิงเทรา", "ฉะเชิงเทรา"),
    ListItem("ชลบุรี", "ชลบุรี"),
    ListItem("ชัยนาท", "ชัยนาท"),
    ListItem("ชัยภูมิ", "ชัยภูมิ"),
    ListItem("ชุมพร", "ชุมพร"),
    ListItem("เชียงราย", "เชียงราย"),
    ListItem("เชียงใหม่", "เชียงใหม่"),
    ListItem("ตรัง", "ตรัง"),
    ListItem("ตราด", "ตราด"),
    ListItem("ตาก", "ตาก"),
    ListItem("นครนายก", "นครนายก"),
    ListItem("นครปฐม", "นครปฐม"),
    ListItem("นครพนม", "นครพนม"),
    ListItem("นครราชสีมา", "นครราชสีมา"),
    ListItem("นครศรีธรรมราช", "นครศรีธรรมราช"),
    ListItem("นครสวรรค์", "นครสวรรค์"),
    ListItem("นนทบุรี", "นนทบุรี"),
    ListItem("นราธิวาส", "นราธิวาส"),
    ListItem("น่าน", "น่าน"),
    ListItem("หนองคาย", "หนองคาย"),
    ListItem("หนองบัวลำภู", "หนองบัวลำภู"),
    ListItem("บึงกาฬ", "บึงกาฬ"),
    ListItem("บุรีรัมย์", "บุรีรัมย์"),
    ListItem("ปทุมธานี", "ปทุมธานี"),
    ListItem("ประจวบคีรีขันธ์", "ประจวบคีรีขันธ์"),
    ListItem("ปราจีนบุรี", "ปราจีนบุรี"),
    ListItem("ปัตตานี", "ปัตตานี"),
    ListItem("พระนครศรีอยุธยา", "พระนครศรีอยุธยา"),
    ListItem("พังงา", "พังงา"),
    ListItem("พัทลุง", "พัทลุง"),
    ListItem("พิจิตร", "พิจิตร"),
    ListItem("พิษณุโลก", "พิษณุโลก"),
    ListItem("เพชรบุรี", "เพชรบุรี"),
    ListItem("เพชรบูรณ์", "เพชรบูรณ์"),
    ListItem("แพร่", "แพร่"),
    ListItem("พะเยา", "พะเยา"),
    ListItem("ภูเก็ต", "ภูเก็ต"),
    ListItem("มหาสารคาม", "มหาสารคาม"),
    ListItem("แม่ฮ่องสอน", "แม่ฮ่องสอน"),
    ListItem("มุกดาหาร", "มุกดาหาร"),
    ListItem("ยะลา", "ยะลา"),
    ListItem("ยโสธร", "ยโสธร"),
    ListItem("ร้อยเอ็ด", "ร้อยเอ็ด"),
    ListItem("ระนอง", "ระนอง"),
    ListItem("ระยอง", "ระยอง"),
    ListItem("ราชบุรี", "ราชบุรี"),
    ListItem("ลพบุรี", "ลพบุรี"),
    ListItem("ลำปาง", "ลำปาง"),
    ListItem("ลำพูน", "ลำพูน"),
    ListItem("เลย", "เลย"),
    ListItem("ศรีสะเกษ", "ศรีสะเกษ"),
    ListItem("สกลนคร", "สกลนคร"),
    ListItem("สงขลา", "สงขลา"),
    ListItem("สตูล", "สตูล"),
    ListItem("สมุทรปราการ", "สมุทรปราการ"),
    ListItem("สมุทรสงคราม", "สมุทรสงคราม"),
    ListItem("สมุทรสาคร", "สมุทรสาคร"),
    ListItem("สระแก้ว", "สระแก้ว"),
    ListItem("สระบุรี", "สระบุรี"),
    ListItem("สิงห์บุรี", "สิงห์บุรี"),
    ListItem("สุโขทัย", "สุโขทัย"),
    ListItem("สุพรรณบุรี", "สุพรรณบุรี"),
    ListItem("สุราษฎร์ธานี", "สุราษฎร์ธานี"),
    ListItem("สุรินทร์", "สุรินทร์"),
    ListItem("อ่างทอง", "อ่างทอง"),
    ListItem("อุดรธานี", "อุดรธานี"),
    ListItem("อุทัยธานี", "อุทัยธานี"),
    ListItem("อุตรดิตถ์", "อุตรดิตถ์"),
    ListItem("อุบลราชธานี", "อุบลราชธานี"),
    ListItem("อำนาจเจริญ", "อำนาจเจริญ"),
  ];

  List<ListItem> _sosItems = [
    ListItem("***กรุณาเลือกหมวดหมู่***", "***กรุณาเลือกหมวดหมู่***"),
    ListItem("แจ้งความตำรวจ", "แจ้งความตำรวจ"),
    ListItem("รถพยาบาล", "รถพยาบาล"),
    ListItem("รถดับเพลิง", "รถดับเพลิง"),
    ListItem("ช่วยชีวิต - ทางน้ำ", "ช่วยชีวิต - ทางน้ำ"),
    ListItem("ช่วยชีวิต - ทางบก", "ช่วยชีวิต - ทางบก"),
    ListItem("มูลนิธิกู้ภัย", "มูลนิธิกู้ภัย"),
    ListItem("ขอความช่วยเหลือจากคนใกล้ฉัน (5 Km)",
        "ขอความช่วยเหลือจากคนใกล้ฉัน (5 Km)"),
    ListItem("เรียกประกันภัย - รถยนต์", "เรียกประกันภัย - รถยนต์"),
    ListItem("เรียกประกันภัย - สุขภาพ", "เรียกประกันภัย - สุขภาพ"),
    ListItem("อื่นๆ", "อื่นๆ"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownSosItems;
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  List<DropdownMenuItem<ListItem>> _dropdownProvinceItems;
  ListItem _selectedTypeItem, _selectedProvicne, _selectedSosItem;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedTypeItem = _dropdownMenuItems[0].value;
    _dropdownProvinceItems = buildDropDownMenuItems(_proviceList);
    _selectedProvicne = _dropdownProvinceItems[0].value;
    _dropdownSosItems = buildDropDownMenuItems(_sosItems);
    _selectedSosItem = _dropdownSosItems[0].value;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.name,
            // style: TextStyle(color: Colors.red),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAvatar(),
              buildCamera(),
              buildName(),
              buildLastName(),
              buildGender(),
              buildAge(),
              buildBirth(),
              buildEmail(),
              buildPassword(),
              buildType(),
              _selectedTypeItem.value != 'User'
                  ? buildDepartment()
                  : Container(),
              _selectedTypeItem.value != 'User'
                  ? buildProvinceType()
                  : Container(),
              _selectedTypeItem.value != 'User'
                  ? buildDepartmentType()
                  : Container(),
              buildRaisedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildRaisedButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          color: Colors.deepOrange,
          onPressed: () {
            if (file == null) {
              normalDialod(context, 'Please chose image');
            } else if (name == null ||
                name.isEmpty ||
                lastName == null ||
                lastName.isEmpty ||
                gender == null ||
                gender.isEmpty ||
                age == null ||
                age.isEmpty ||
                birth == null ||
                birth.isEmpty ||
                email == null ||
                email.isEmpty ||
                password == null ||
                password.isEmpty ||
                type == null ||
                type.isEmpty) {
              normalDialod(context, 'Have space ? Please Fill Every Blank');
            } else {
              registerThread();
            }
          },
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.purple,
          ),
          label: Text(
            'Register',
            style: TextStyle(color: Colors.yellow),
          ),
        ),
      );

  Container buildCamera() {
    return Container(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Container buildAvatar() {
    return Container(
      width: 250,
      height: 250,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name :',
          suffixIcon: Icon(Icons.account_circle),
        ),
      ),
    );
  }

  Container buildLastName() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => lastName = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'LastName :',
          suffixIcon: Icon(Icons.account_circle),
        ),
      ),
    );
  }

  Container buildGender() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => gender = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Gender :',
          suffixIcon: Icon(Icons.wc),
        ),
      ),
    );
  }

  Container buildAge() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) => age = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Age :',
          suffixIcon: Icon(Icons.nature_people),
        ),
      ),
    );
  }

  Container buildBirth() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => birth = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Birth Day :',
          suffixIcon: Icon(Icons.wb_sunny),
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'E-mail :',
          suffixIcon: Icon(Icons.alternate_email),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password :',
          suffixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Widget buildType() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: DropdownButton<ListItem>(
        hint: Text('User'),
        value: _selectedTypeItem,
        items: _dropdownMenuItems,
        onChanged: (value) {
          setState(() {
            _selectedTypeItem = value;
            type = value.value.trim();
          });
        },
      ),
    );
  }

  Widget buildDepartment() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: TextField(
        onChanged: (value) => department = value.trim(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Department :',
          suffixIcon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Widget buildProvinceType() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: DropdownButton<ListItem>(
        hint: Text('Province'),
        value: _selectedProvicne,
        items: _dropdownProvinceItems,
        onChanged: (value) {
          setState(() {
            _selectedProvicne = value;
            province = value.value.trim();
          });
        },
      ),
    );
  }

  Widget buildDepartmentType() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: DropdownButton<ListItem>(
        hint: Text('Department Type'),
        value: _selectedSosItem,
        items: _dropdownSosItems,
        onChanged: (value) {
          setState(() {
            _selectedSosItem = value;
            sosDepartment = value.value.trim();
          });
        },
      ),
    );
  }

  Future<Null> registerThread() async {
    await Firebase.initializeApp().then((value) async {
      print('Connected Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user.uid;
        print('uid ==>> $uid');
        StorageReference reference =
            FirebaseStorage.instance.ref().child('Avartar/$uid.jpg');
        StorageUploadTask task = reference.putFile(file);
        String urlAvatar = await (await task.onComplete).ref.getDownloadURL();
        print('urlAvatar = $urlAvatar');
        Map<String, dynamic> typeData = Map();
        typeData['Type'] = type;
        await FirebaseFirestore.instance
            .collection('Type')
            .doc(uid)
            .set(typeData);

        Map<String, dynamic> userdata = Map();
        userdata['UrlAvatar'] = urlAvatar;
        userdata['Name'] = name;
        userdata['LastName'] = lastName;
        userdata['Gender'] = gender;
        userdata['Age'] = age;
        userdata['Birth'] = birth;
        userdata['Email'] = email;
        userdata['Password'] = password;
        userdata['Type'] = type;

        if (type == 'SOS') {
          userdata['department'] = department;
          userdata['province'] = province;
          userdata['department_type'] = sosDepartment;
        }

        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .set(userdata)
            .then(
              (value) => Navigator.pop(context),
            );
      });
    }).catchError((value) {
      normalDialod(context, value.message);
    });
  }
}
