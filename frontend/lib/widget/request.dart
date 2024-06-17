import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../user_info.dart';
import './user_detail.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<StatefulWidget> createState() {
    return RequestState();
  }
}

class RequestState extends State<Request> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = UserInfo.instance.company;
  }

  Future<String> _getApplied() {
    var company = jsonDecode(_company);
    return http.get(
      Uri.parse('http://10.0.2.2:3000/applied/company?companyId=${company['_id']}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      var applieds = jsonDecode(response.body)['applieds'];
      return jsonEncode(applieds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getApplied(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = snapshot.data == '[]' ? const Center(
            child: Text(
              'Empty',
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
              ),
            ),
          ) : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: userList(snapshot.data!),
              ),
            ),
          );
        } else {
          child = const Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}

List<Widget> userList(String data) {
  var list = jsonDecode(data);
  List<Widget> ret = [];
  for (var e in list) {
    String user = jsonEncode(e["user"]);
    String job = jsonEncode(e["job"]);
    ret.add(Candidate(user, job));
  }
  return ret;
}

class Candidate extends StatefulWidget {
  final String user;
  final String job;

  const Candidate(
    this.user,
    this.job,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CandidateState();
  }
}

class CandidateState extends State<Candidate> {
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
    var user = jsonDecode(_user);
    var job = jsonDecode(_job);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
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
                    body: UserDetail(_user, _job),
                  ),
                );
              }
            )
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          minRadius: 22,
                          foregroundImage: AssetImage('assets/images/default_avatar.jpg'),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  user["firstName"] + ' ' + user["lastName"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blue,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.mail_outline, size: 15),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user["email"],
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.phone_outlined, size: 15),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user["phoneNumber"],
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Apply for job',
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    job["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
