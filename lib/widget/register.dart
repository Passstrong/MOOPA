import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tongmoopa/utlity/normal_dialog.dart';

import '../model/list_item.dart';

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

  int sosDepartmentNo;

  List<ListItem> _dropdownItems = [
    ListItem(0, "User"),
    ListItem(1, "SOS"),
  ];

  List<ListItem> _proviceList = [
    ListItem(1, "กรุงเทพ"),
    ListItem(2, "กระบี่"),
    ListItem(3, "กาญจนบุรี"),
    ListItem(4, "กาฬสินธุ์"),
    ListItem(5, " กำแพงเพชร"),
    ListItem(6, "ขอนแก่น"),
    ListItem(7, "จันทบุรี"),
    ListItem(8, "ฉะเชิงเทรา"),
    ListItem(9, "ชลบุรี"),
    ListItem(10, "ชัยนาท"),
    ListItem(11, "ชัยภูมิ"),
    ListItem(12, "ชุมพร"),
    ListItem(13, "เชียงราย"),
    ListItem(14, "เชียงใหม่"),
    ListItem(15, "ตรัง"),
    ListItem(16, "ตราด"),
    ListItem(17, "ตาก"),
    ListItem(18, "นครนายก"),
    ListItem(19, "นครปฐม"),
    ListItem(20, "นครพนม"),
    ListItem(21, "นครราชสีมา"),
    ListItem(22, "นครศรีธรรมราช"),
    ListItem(23, "นครสวรรค์"),
    ListItem(24, "นนทบุรี"),
    ListItem(25, "นราธิวาส"),
    ListItem(26, "น่าน"),
    ListItem(27, "หนองคาย"),
    ListItem(28, "หนองบัวลำภู"),
    ListItem(29, "บึงกาฬ"),
    ListItem(30, "บุรีรัมย์"),
    ListItem(31, "ปทุมธานี"),
    ListItem(32, "ประจวบคีรีขันธ์"),
    ListItem(33, "ปราจีนบุรี"),
    ListItem(34, "ปัตตานี"),
    ListItem(35, "พระนครศรีอยุธยา"),
    ListItem(36, "พังงา"),
    ListItem(37, "พัทลุง"),
    ListItem(38, "พิจิตร"),
    ListItem(39, "พิษณุโลก"),
    ListItem(40, "เพชรบุรี"),
    ListItem(41, "เพชรบูรณ์"),
    ListItem(42, "แพร่"),
    ListItem(43, "พะเยา"),
    ListItem(44, "ภูเก็ต"),
    ListItem(45, "มหาสารคาม"),
    ListItem(46, "แม่ฮ่องสอน"),
    ListItem(47, "มุกดาหาร"),
    ListItem(48, "ยะลา"),
    ListItem(49, "ยโสธร"),
    ListItem(50, "ร้อยเอ็ด"),
    ListItem(51, "ระนอง"),
    ListItem(52, "ระยอง"),
    ListItem(53, "ราชบุรี"),
    ListItem(54, "ลพบุรี"),
    ListItem(55, "ลำปาง"),
    ListItem(56, "ลำพูน"),
    ListItem(57, "เลย"),
    ListItem(58, "ศรีสะเกษ"),
    ListItem(59, "สกลนคร"),
    ListItem(60, "สงขลา"),
    ListItem(61, "สตูล"),
    ListItem(62, "สมุทรปราการ"),
    ListItem(63, "สมุทรสงคราม"),
    ListItem(64, "สมุทรสาคร"),
    ListItem(65, "สระแก้ว"),
    ListItem(66, "สระบุรี"),
    ListItem(67, "สิงห์บุรี"),
    ListItem(68, "สุโขทัย"),
    ListItem(69, "สุพรรณบุรี"),
    ListItem(70, "สุราษฎร์ธานี"),
    ListItem(71, "สุรินทร์"),
    ListItem(72, "อ่างทอง"),
    ListItem(73, "อุดรธานี"),
    ListItem(74, "อุทัยธานี"),
    ListItem(75, "อุตรดิตถ์"),
    ListItem(76, "อุบลราชธานี"),
    ListItem(77, "อำนาจเจริญ"),
  ];

  List<ListItem> _sosItems = [
    ListItem(0, "***กรุณาเลือกหมวดหมู่***"),
    ListItem(1, "แจ้งความตำรวจ"),
    ListItem(2, "รถพยาบาล"),
    ListItem(3, "รถดับเพลิง"),
    ListItem(4, "ช่วยชีวิต - ทางน้ำ"),
    ListItem(5, "ช่วยชีวิต - ทางบก"),
    ListItem(6, "มูลนิธิกู้ภัย"),
    ListItem(7, "ขอความช่วยเหลือจากคนใกล้ฉัน (5 Km)"),
    ListItem(8, "เรียกประกันภัย - รถยนต์"),
    ListItem(9, "เรียกประกันภัย - สุขภาพ"),
    ListItem(10, "อื่นๆ"),
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
              _selectedTypeItem.name != 'User'
                  ? buildDepartment()
                  : Container(),
              _selectedTypeItem.name != 'User'
                  ? buildProvinceType()
                  : Container(),
              _selectedTypeItem.name != 'User'
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
        hint: Text('USER (class People)'),
        value: _selectedTypeItem,
        items: _dropdownMenuItems,
        onChanged: (value) {
          setState(() {
            _selectedTypeItem = value;
            type = value.name;
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
            province = value.name;
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
            sosDepartment = value.name;
            sosDepartmentNo = value.value;
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
          userdata['department_number'] = sosDepartmentNo;
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
