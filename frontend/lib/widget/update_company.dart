import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/validator.dart';
import 'main.dart';
import '../user_info.dart';

class UpdateCompanyWidget extends StatelessWidget {
  const UpdateCompanyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.red,
          title: const Text('Update company'),
        ),
        body: const UpdateCompanyForm(),
      ),
    );
  }
}

class UpdateCompanyForm extends StatefulWidget {
  const UpdateCompanyForm({super.key});

  @override
  UpdateCompanyFormState createState() {
    return UpdateCompanyFormState();
  }
}

class UpdateCompanyFormState extends State<UpdateCompanyForm> {
  final _formKey = GlobalKey<FormState>();
  var data = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    var company = jsonDecode(UserInfo.instance.company);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 30),
            UpdateCompanyTextField(data, 'name', 'Company Name', defaultValue: company['name']),
            UpdateCompanyTextField(data, 'address', 'Address', defaultValue: company['address']),
            UpdateCompanyTextField(data, 'introduction', 'Introduction', multiLine: true, defaultValue: company['introduction']),
            UpdateCompanyTextField(data, 'website', 'Website', defaultValue: company['website']),
            SubmitButton(data, _formKey),
          ],
        ),
      ),
    );
  }
}

class UpdateCompanyTextField extends StatefulWidget {
  final Map<String, dynamic> data;
  final String dataField;
  final String labelText;
  final bool obscureText;
  final String? Function(String?) validator;
  final bool isPassword;
  final String defaultValue;
  final bool multiLine;

  const UpdateCompanyTextField(
    this.data,
    this.dataField,
    this.labelText,
    {
      this.multiLine = false,
      this.defaultValue = '',
      this.validator = nullValidator,
      this.obscureText = false,
      this.isPassword = false,
      super.key
    }
  );

  @override
  State<StatefulWidget> createState() {
    return UpdateCompanyTextFieldState();
  }
}

class UpdateCompanyTextFieldState extends State<UpdateCompanyTextField> {
  late Map<String, dynamic> _data;
  late String _dataField;
  late String _labelText;
  late bool _obscureText;
  late String? Function(String?) _validator;
  late bool _isPassword;
  late String _defaultValue;
  late bool _multiLine;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _dataField = widget.dataField;
    _labelText = widget.labelText;
    _obscureText = widget.obscureText;
    _validator = widget.validator;
    _isPassword = widget.isPassword;
    _defaultValue = widget.defaultValue;
    _multiLine = widget.multiLine;
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
            textInputAction: _multiLine ? TextInputAction.newline : TextInputAction.next,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onSaved: (value) {
              _data[_dataField] = value;
            },
            initialValue: _defaultValue,
            keyboardType: _multiLine ? TextInputType.multiline : null,
            maxLines: _multiLine ? null : 1,
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
    String companyId = jsonDecode(UserInfo.instance.company)['_id'];
    final response = http.post(
      Uri.parse('http://10.0.2.2:3000/company/update?_id=$companyId'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_data),
    ).timeout(const Duration(seconds: 10));
    return response;
  }

  void _updateUserInfo(String responseBody) {
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
                      const Text('Progressing')
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
                  _updateUserInfo(response.body);
                  Timer(const Duration(seconds: 1), () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainWidget()
                      ),
                    );
                  });
                }
              }).catchError((error) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update failed: timed out')),
                );
              });
            }
          },
          child: const Text('Submit'),
        )
    );
  }
}
