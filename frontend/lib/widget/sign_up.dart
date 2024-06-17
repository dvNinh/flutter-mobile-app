import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/validator.dart';
import '../widget/sign_in.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: const SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  var data = <String, dynamic>{};
  List<String> list = <String>['Candidate', 'Employer'];
  late bool _isCandidate;

  @override
  void initState() {
    _isCandidate = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(height: 30),
            SignUpTextField(data, 'email', 'Email', false, emailValidator),
            SignUpTextField(data, 'password', 'Password', true, passwordValidator, isPassword: true),
            SignUpTextField(data, 'firstName', 'First name', false, nullValidator),
            SignUpTextField(data, 'lastName', 'Last name', false, nullValidator),
            SignUpTextField(data, 'phoneNumber', 'Phone number', false, nullValidator),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  labelText: 'Role',
                ),
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _isCandidate = value == 'Candidate' ? true : false;
                  });
                },
                onSaved: (value) {
                  data['role'] = value;
                },
              ),
            ),
            _isCandidate ? Container() : SignUpTextField(data, 'companyName', 'Company Name', false, nullValidator),
            _isCandidate ? Container() : SignUpTextField(data, 'companyAddress', 'Company Address', false, nullValidator),
            SubmitButton(data, _formKey),
            Container(height: 50),
          ],
        ),
      ),
    );
  }
}

class SignUpTextField extends StatefulWidget {
  final Map<String, dynamic> data;
  final String dataField;
  final String labelText;
  final bool obscureText;
  final String? Function(String?) validator;
  final bool isPassword;

  const SignUpTextField(
    this.data,
    this.dataField,
    this.labelText,
    this.obscureText,
    this.validator,
    {this.isPassword = false, super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return SignUpTextFieldState();
  }
}

class SignUpTextFieldState extends State<SignUpTextField> {
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
    return Padding(
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
    );
  }

  void _showHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
      Uri.parse('http://10.0.2.2:3000/sign-up'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_data),
    ).timeout(const Duration(seconds: 10));
    return response;
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
                    const Text('Signing up')
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
                )),
              );
              if (response.statusCode == 201) {
                Timer(const Duration(seconds: 1), () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInWidget()
                    ),
                  );
                });
              }
            }).catchError((error) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up failed: timed out')),
              );
            });
          }
        },
        child: const Text('Sign Up'),
      )
    );
  }
}
