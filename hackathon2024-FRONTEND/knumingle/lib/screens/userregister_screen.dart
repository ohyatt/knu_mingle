import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:knumingle/constants/url.dart';
import 'package:knumingle/screens/login_screen.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _checkingNumberController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String? _selectedFaculty;
  String? _selectedGender;
  String? _selectedNation;

  List<String> _nations = [];
  List<String> _faculties = [];

  bool _isEmailVerified = false;
  bool _isPasswordMatch = false;
  bool _isEmailValid = false;
  bool _isNumberValid = false;
  String? checkNum;

  @override
  void initState() {
    super.initState();
    _fetchNations();
    _fetchFaculties();
  }

  Future<void> _fetchNations() async {
    final response = await http.get(Uri.parse('$ApiAddress/lists/nations'));
    if (response.statusCode == 200) {
      final List<dynamic> nations = jsonDecode(response.body);
      setState(() {
        _nations = nations.cast<String>();
      });
    } else {
      _showErrorDialog('Failed to load nations.');
    }
  }

  Future<void> _fetchFaculties() async {
    final response = await http.get(Uri.parse('$ApiAddress/lists/faculties'));
    if (response.statusCode == 200) {
      final List<dynamic> faculties = jsonDecode(response.body);
      setState(() {
        _faculties = faculties.cast<String>();
      });
    } else {
      _showErrorDialog('Failed to load faculties.');
    }
  }

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _verifyEmail() {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email.');
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showErrorDialog('Invalid email format.');
      return;
    }

    setState(() {
      _isEmailValid = true;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showIdentityVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Identity Verification'),
          content: const Text(
              'An identity verification code has been sent to the email address you entered. Please check it and enter it below "Number for Checking Email."'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyIdentity() async {
    final url =
        '$ApiAddress/auth/sendMail?email=${Uri.encodeComponent(_emailController.text)}';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(checkNum);
      checkNum = response.body; // 응답으로 오는 문자열을 checkNum 변수에 저장
      setState(() {
        _isEmailVerified = true;
      });
      _showIdentityVerificationDialog();
    } else {
      print(response.statusCode);
      _showErrorDialog('Error sending identity verification email.');
    }
  }

  Future<void> _checkVerificationNumber() async {
    if (_checkingNumberController.text.isEmpty) {
      _showErrorDialog('Please enter the number sent to your email.');
      return;
    }

    // 쿼리 파라미터로 요청하기 위한 URL 생성
    final url = Uri.parse(
        '$ApiAddress/auth/checkMail?key=$checkNum&insertKey=${_checkingNumberController.text}&email=${_emailController.text}');
    print(url);
    final response = await http.post(
      url,
    );

    if (response.statusCode == 200) {
      final bool success = jsonDecode(response.body);
      if (success) {
        setState(() {
          _isNumberValid = true;
        });
        _showSuccessDialog('Verification successful!');
      } else {
        _showErrorDialog(
            'The verification number is incorrect. Please try again.');
      }
    } else {
      print('Error: ${response.statusCode}');
      _showErrorDialog('Error occurred during verification.');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkForDuplicates() async {
    final url = '$ApiAddress/auth/duplicate?email=${_emailController.text}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final bool isDuplicate = jsonDecode(response.body);
      if (!isDuplicate) {
        setState(() {
          _isEmailValid = true;
        });
      } else {
        _showErrorDialog('There is the duplicated Email. Please try again');
      }
    } else {
      print('Error');
    }
  }

  Future<void> _register() async {
    final String modifiedNation = _selectedNation?.replaceAll(' ', '_') ?? '';
    final String modifiedFaculty = _selectedFaculty?.replaceAll(' ', '_') ?? '';

    final url = '$ApiAddress/auth/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'gender': _selectedGender,
        'email': _emailController.text,
        'password': _passwordController.text,
        'nation': modifiedNation,
        'faculty': modifiedFaculty,
      }),
    );

    if (response.statusCode == 200) {
      _showSuccessDialog('Register Success!');

      // 성공 모달이 닫힌 후 로그인 페이지로 이동
      Navigator.of(context).pop(); // 모달 닫기
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()), // 로그인 화면으로 이동
        ); // 로그인 페이지로 이동
      });
    } else {
      print('Error: ${response.statusCode}');
      _showErrorDialog('Registration failed. Please try again.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _checkingNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Register',
              style: TextStyle(fontFamily: 'ggsansBold'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontFamily: 'ggsansBold'),
                      controller: _emailController,
                      enabled: !_isEmailValid,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Email',
                        suffixIcon: Icon(
                          _isEmailValid ? Icons.check_circle : Icons.cancel,
                          color: _isEmailValid ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _checkForDuplicates,
                      child: const Text('Check for duplicates',
                          style: TextStyle(fontFamily: 'ggsansBold')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isEmailValid ? _verifyIdentity : null,
                      child: const Text('Identity Verification',
                          style: TextStyle(fontFamily: 'ggsansBold')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    style: const TextStyle(fontFamily: 'ggsansBold'),
                    controller: _checkingNumberController,
                    enabled: _isEmailVerified && !_isNumberValid,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Number for Checking Email',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNumberValid ? Icons.check_circle : Icons.cancel,
                          color: _isNumberValid ? Colors.green : Colors.red,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed:
                          _isEmailVerified ? _checkVerificationNumber : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) => _checkPasswordMatch(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                onChanged: (value) => _checkPasswordMatch(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  suffixIcon: Icon(
                    _isPasswordMatch ? Icons.check_circle : Icons.cancel,
                    color: _isPasswordMatch ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(fontFamily: 'ggsansBold'),
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(fontFamily: 'ggsansBold'),
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 16),
              // Gender 드롭다운 추가
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: <String>['MALE', 'FEMALE']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gender',
                ),
              ),
              const SizedBox(height: 16),

              // Nation 드롭다운 추가
              DropdownButtonFormField<String>(
                value: _selectedNation,
                items: _nations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNation = newValue;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nation',
                ),
              ),
              const SizedBox(height: 24),

              // Faculty 드롭다운 추가
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedFaculty,
                      items: _faculties
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2 // 텍스트가 넘칠 경우 말줄임표로 처리
                              ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFaculty = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Faculty',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Register 버튼
              ElevatedButton(
                onPressed: _isEmailVerified &&
                        _isPasswordMatch &&
                        _firstNameController.text.isNotEmpty &&
                        _lastNameController.text.isNotEmpty &&
                        _selectedNation != null &&
                        _selectedFaculty != null &&
                        _selectedGender != null
                    ? () {
                        _register(); // Register 버튼 클릭 시 _register 호출
                      }
                    : null,
                child: const Text('Register',
                    style: TextStyle(fontFamily: 'ggsansBold')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
