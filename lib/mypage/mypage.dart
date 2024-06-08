import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mojadel2/colors/colors.dart';
import 'package:mojadel2/mypage/profile/modifyprofile.dart';
import 'package:mojadel2/mypage/signup/signup.dart';
import 'package:mojadel2/mypage/signup/tabbar_using_controller.dart';
import 'package:mojadel2/mypage/signup/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'getboardcount/getBoardCount.dart';
import 'login/loginpage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class MyPageSite extends StatefulWidget {
  const MyPageSite({Key? key}) : super(key: key);

  @override
  State<MyPageSite> createState() => _MyPageSiteState();
}

class _MyPageSiteState extends State<MyPageSite> with SingleTickerProviderStateMixin {
  String? _nickname;
  File? _imageFile;
  String? _userEmail;
  String? _jwtToken;
  int? _userBoardCount;
  String? _profileImageUrl;
  ImagePicker picker = ImagePicker();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _tabController = TabController(length: TABS.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF8F8FA),
      // appBar: AppBar(
      //   title: Text('Test Title'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _UserInformation(context),
            const SizedBox(height: 10.0),
            TabBarUsingController(),
          ],
        ),
      ),
    );
  }

  Widget _statisticOne(String title, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(title, style: TextStyle(fontSize: 12.0, color: Colors.black54)),
        SizedBox(width: 5.0),
        Text(value.toString(),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            )),
      ],
    );
  }

  Widget _UserInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                    // 태두리 선의 색상 설정
                    width: 0.5, // 태두리 선의 두께 설정
                  ),
                ),
                child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white10,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _nickname ?? '비회원',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(child: _statisticOne('YOMO', 14)),
                        Expanded(child: _statisticOne('Followers', 20)),
                        Expanded(child: _statisticOne('Following', 25)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(240, 20.0),
                        side: BorderSide(color: Color(0xFFDBDBDB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ModifyProfile(),
                          ),
                        );
                      },
                      child: Text(
                        '프로필 편집',
                        style: TextStyle(color: Colors.black, fontSize: 10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _jwtToken = prefs.getString('jwtToken'); // jwtToken 가져오기
    if (_jwtToken != null) {
      final userInfo = await _getUserInfo(_jwtToken!);
      setState(() {
        _nickname = userInfo['nickname'];
        _userEmail = userInfo['email'];
        _profileImageUrl = userInfo['profileImage'];
      });
    }
  }

  Future<Map<String, dynamic>> _getUserInfo(String jwtToken) async {
    final String uri = 'http://10.0.2.2:4000/api/v1/user/';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
    };
    try {
      final response = await http.get(
        Uri.parse(uri),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        return {
          'nickname': responseData['nickname'],
          'email': responseData['email'],
          'profileImage': responseData['profileImage'], // 수정된 키 사용
        };
        print('${responseData}');
      } else {
        print('Failed to get user info: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {};
      }
    } catch (error) {
      print('Failed to get user info: $error');
      return {};
    }
  }

  Future<String?> _getNickname(String jwtToken) async {
    final String uri =
        'http://10.0.2.2:4000/api/v1/user'; // 사용자 정보를 가져오는 API 엔드포인트
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken', // JWT 토큰을 인증 헤더에 포함
    };
    try {
      final response = await http.get(
        Uri.parse(uri),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        final String? nickname = responseData['nickname'];
        return nickname;
      } else {
        print('Failed to get nickname: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Failed to get nickname: $error');
      return null;
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    setState(() {
      _nickname = null;
      _jwtToken = null; // jwtToken 초기화
      _profileImageUrl = null;
    });
  }

  Future<void> _uploadImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    if (jwtToken != null) {
      try {
        Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        };
        Uri url = Uri.parse('http://10.0.2.2:4000/api/v1/user/profile-image');
        http.Response response = await http.patch(
          url,
          headers: headers,
          body: jsonEncode({'profileImage': imageFile.path}),
        );
        if (response.statusCode == 200) {
          final imageUrl = jsonDecode(response.body)['imageFile'];
          setState(() {
            _imageFile = imageFile;
            _profileImageUrl = imageUrl;
          });
          print('Image uploaded successfully');
          print('Image imageFile: $imageFile');
        } else {
          print('Failed to upload image: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
  }

  Future<void> _getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final File permanentFile = await _saveImagePermanently(imageFile);
      if (permanentFile.existsSync()) {
        // 파일이 존재하는지 확인
        setState(() {
          _imageFile = permanentFile; // 변경된 이미지를 상태에 저장
        });
        await _uploadImage(permanentFile);
      } else {
        print('파일이 존재하지 않습니다.');
      }
    } else {
      print('이미지를 선택하지 않았습니다.');
    }
  }

  Future<File> _saveImagePermanently(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = basename(imageFile.path);
    final File permanentFile = await imageFile.copy('$path/$fileName');
    return permanentFile;
  }
}
