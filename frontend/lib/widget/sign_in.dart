import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/validator.dart';
import '../user_info.dart';
import 'sign_up.dart';
import 'main.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.red,
          title: const Text('Sign in'),
        ),
        body: const SignInForm(),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  var data = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 30),
            SignInTextField(data, 'email', 'Email', false, emailValidator),
            SignInTextField(data, 'password', 'Password', true, passwordValidator, isPassword: true),
            const SignUpButton(),
            SubmitButton(data, _formKey),
          ],
        ),
      ),
    );
  }
}

class SignInTextField extends StatefulWidget {
  final Map<String, dynamic> data;
  final String dataField;
  final String labelText;
  final bool obscureText;
  final String? Function(String?) validator;
  final bool isPassword;

  const SignInTextField(
    this.data,
    this.dataField,
    this.labelText,
    this.obscureText,
    this.validator,
    {this.isPassword = false, super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return SignInTextFieldState();
  }
}

class SignInTextFieldState extends State<SignInTextField> {
  late Map<String, dynamic> _data;
  late String _dataField;
  late String _labelText;
  late bool _obscureText;
  late String? Function(String?) _validator;
  late bool _isPassword;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _dataField = widget.dataField;
    _labelText = widget.labelText;
    _obscureText = widget.obscureText;
    _validator = widget.validator;
    _isPassword = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              labelText: _labelText,
              suffixIcon: _isPassword ? TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15),
                  foregroundColor: Colors.black,
                ),
                onPressed: _showHidePassword,
                child: _obscureText ? const Text('Show') : const Text('Hide'),
              ) : null,
            ),
            obscureText: _obscureText,
            validator: _validator,
            textInputAction: TextInputAction.next,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onSaved: (value) {
              _data[_dataField] = value;
            },
          ),
        ),
      ],
    );
  }

  void _showHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: <Widget>[
            const Text(
              'Don\'t have account yet?',
              style: TextStyle(fontSize: 15),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpWidget()
                  ),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        )
    );
  }
}

class SubmitButton extends StatefulWidget {
  final Map<String, dynamic> data;
  final GlobalKey<FormState> formKey;

  const SubmitButton(
    this.data,
    this.formKey,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return SubmitButtonState();
  }
}

class SubmitButtonState extends State<SubmitButton> {
  late Map<String, dynamic> _data;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _formKey = widget.formKey;
  }

  Future<http.Response> _postData() {
    final response = http.post(
      Uri.parse('http://10.0.2.2:3000/sign-in'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_data),
    ).timeout(const Duration(seconds: 10));
    return response;
  }

  Future<void> saveData(String responseBody) async {
    UserInfo.instance.user = jsonEncode(jsonDecode(responseBody)['user']);
    UserInfo.instance.company = jsonEncode(jsonDecode(responseBody)['company']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 18),
          minimumSize: Size(MediaQuery.of(context).size.width, 48),
        ),
        onPressed: () async {
          _formKey.currentState?.save();
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      height: 16,
                      width: 16,
                      child: const CircularProgressIndicator(),
                    ),
                    const Text('Signing in')
                  ],
                ),
                duration: const Duration(seconds: 10),
              ),
            );
            _postData().then((response) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
                  jsonDecode(response.body)['message'],
                ))
              );
              if (response.statusCode == 201) {
                saveData(response.body);
                Timer(const Duration(seconds: 1), () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainWidget()
                    ),
                    (Route route) => false
                  );
                });
              }
            }).catchError((error) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign in failed: timed out')),
              );
            });
          }
        },
        child: const Text('Sign In'),
      )
    );
  }
}
