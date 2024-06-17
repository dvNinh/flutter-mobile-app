import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import '../user_info.dart';

class EditDescriptionWidget extends StatefulWidget {
  const EditDescriptionWidget({super.key});

  @override
  EditDescriptionWidgetState createState() {
    return EditDescriptionWidgetState();
  }
}

class EditDescriptionWidgetState extends State<EditDescriptionWidget> {
  final _formKey = GlobalKey<FormState>();
  var data = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    var user = jsonDecode(UserInfo.instance.user);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.red,
          title: const Text('Describe yourself'),
          actions: [
            SubmitButton(data, _formKey),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                  textInputAction: TextInputAction.newline,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    data['description'] = value;
                  },
                  onSaved: (value) {
                    data['description'] = value;
                  },
                  initialValue: user['description'],
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ),
      ),
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
    String userId = jsonDecode(UserInfo.instance.user)['_id'];
    final response = http.post(
      Uri.parse('http://10.0.2.2:3000/user/update?_id=$userId'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(_data),
    ).timeout(const Duration(seconds: 10));
    return response;
  }

  void _updateUserInfo(String responseBody) {
    UserInfo.instance.user = jsonEncode(jsonDecode(responseBody)['user']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: IconButton(
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
        icon: const Icon(Icons.done),
      )
    );
  }
}
