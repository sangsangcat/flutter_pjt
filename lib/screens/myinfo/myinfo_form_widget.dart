import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyinfoFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyinfoFormWidgetState();
  }
}

class MyinfoFormWidgetState extends State<MyinfoFormWidget> {
  //Form 을 이용한다고 하더라도..
  //유저 입력값 획득에서는 controller 가 필요 없지만..
  //화면이 나올때.. 이전 입력값이 미리 화면에 출력되게 하려면 controller 있어야 한다..
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? profileImagePath; //프사 경로..
  ImagePicker picker = ImagePicker();

  void showImagePickerDialog() {
    //dialog 띄우기..
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('프로필 사진 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context); //dialog 닫기..
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('갤러리에서 선택'),
                onTap: () {
                  Navigator.pop(context); //dialog 닫기..
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        //화면 업데이트..
        setState(() {
          profileImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다.')));
      print(e);
    }
  }

  void saveUserInfo() async {
    //유저 입력 데이터 획득..
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이름 또는 이메일을 입력해 주세요.')));
      return;
    }

    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('사용자 정보가 저장되었습니다.')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('저장 중 오류가 발생했습니다.')));
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  //profileImagePath 값이 있는지에 따라...
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath!))
                      : AssetImage('assets/images/user_basic.jpg')
                            as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: showImagePickerDialog,
                    child: Icon(Icons.camera_alt),
                    mini: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: '이름',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: '이메일',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: saveUserInfo,
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
