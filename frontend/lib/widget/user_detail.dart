import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'job_detail.dart';

class UserDetail extends StatefulWidget {
  final String user;
  final String job;

  const UserDetail(
    this.user,
    this.job,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return UserDetailState();
  }
}

class UserDetailState extends State<UserDetail> {
  late String _user;
  late String _job;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _job = widget.job;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            UserDetailHead(_user),
            JobButton(_job),
            UserDetailBody(_user),
          ],
        ),
      ),
    );
  }
}

class UserDetailHead extends StatefulWidget {
  final String user;

  const UserDetailHead(
    this.user,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return UserDetailHeadState();
  }
}

class UserDetailHeadState extends State<UserDetailHead> {
  late Map<String, dynamic> _user;

  @override
  void initState() {
    super.initState();
    _user = jsonDecode(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  minRadius: 20,
                  foregroundImage: AssetImage('assets/images/default_avatar.jpg'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      _user['firstName'] + ' ' + _user['lastName'],
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.email_outlined, size: 16),
                ),
                Expanded(
                  child: Text(
                    _user["email"],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.phone_outlined, size: 16),
                ),
                Expanded(
                  child: Text(
                    _user["phoneNumber"],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.location_on_outlined, size: 16),
                ),
                Expanded(
                  child: Text(
                    _user["address"],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.cake_outlined, size: 16),
                ),
                Expanded(
                  child: Text(
                    _user["dob"],
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JobButton extends StatefulWidget {
  final String job;

  const JobButton(
    this.job,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return JobButtonState();
  }
}

class JobButtonState extends State<JobButton> {
  late Map<String, dynamic> _job;

  @override
  void initState() {
    super.initState();
    _job = jsonDecode(widget.job);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'Job applied',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              http.get(
                Uri.parse('http://10.0.2.2:3000/job?_id=${_job['_id']}'),
                headers: <String, String> {
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              ).then((response) {
                if (response.statusCode == 200) {
                  String job = jsonEncode(jsonDecode(response.body)['jobs'][0]);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SafeArea(
                            child: Scaffold(
                              appBar: AppBar(
                                // backgroundColor: Colors.red,
                                title: const Text('Job Detail'),
                              ),
                              body: JobDetail(job),
                            ),
                          );
                        }
                       )
                     );
                } else if (response.statusCode == 400) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                      jsonDecode(response.body)['message'],
                    ))
                  );
                }
              }).catchError((error) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Load failed: timed out')),
                );
              });
            },
            child: Text(
              _job['name'],
              style: const TextStyle(
                fontSize: 18
              ),
            )
          ),
        ],
      ),
    );
  }
}

class UserDetailBody extends StatefulWidget {
  final String user;

  const UserDetailBody(
    this.user,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return UserDetailBodyState();
  }
}

class UserDetailBodyState extends State<UserDetailBody> {
  late Map<String, dynamic> _user;

  @override
  void initState() {
    super.initState();
    _user = jsonDecode(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _user['description'],
              style: const TextStyle(
                  fontSize: 16
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
