import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../user_info.dart';
import 'company_detail.dart';

class JobDetail extends StatefulWidget {
  final String job;

  const JobDetail(
    this.job,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return JobDetailState();
  }
}

class JobDetailState extends State<JobDetail> {
  late String _job;
  late String _company;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
    _company = jsonEncode(jsonDecode(_job)['company']);
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
            JobDetailHead(_job),
            CompanyButton(_company),
            JobDetailBody(_job),
          ],
        ),
      ),
    );
  }
}

class JobDetailHead extends StatefulWidget {
  final String job;

  const JobDetailHead(
    this.job,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return JobDetailHeadState();
  }
}

class JobDetailHeadState extends State<JobDetailHead> {
  late Map<String, dynamic> _job;

  @override
  void initState() {
    super.initState();
    _job = jsonDecode(widget.job);
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _job['name'],
              style: const TextStyle(
                fontSize: 26,
                color: Colors.blue,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _job['salary'],
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _job['address'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (UserInfo.instance.user != '') {
                          if (jsonDecode(UserInfo.instance.user)['role'] == 'Employer') return;
                          String userId = jsonDecode(UserInfo.instance.user)['_id'];
                          String jobId = _job['_id'];
                          http.post(
                            Uri.parse('http://10.0.2.2:3000/applied'),
                            headers: <String, String> {
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode({
                              'userId': userId,
                              'jobId': jobId
                            })
                          ).then((response) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Applied'))
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sign in to apply'))
                          );
                        }
                      },
                      child: const Text('Apply Now')
                    ),
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.blue,
                    ))
                  ),
                  onPressed: () {
                    if (UserInfo.instance.user != '') {
                      if (jsonDecode(UserInfo.instance.user)['role'] == 'Employer') return;
                      String userId = jsonDecode(UserInfo.instance.user)['_id'];
                      String jobId = _job['_id'];
                      http.post(
                        Uri.parse('http://10.0.2.2:3000/saved'),
                        headers: <String, String> {
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode({
                          'userId': userId,
                          'jobId': jobId
                        })
                      ).then((response) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved'))
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign in to save'))
                      );
                    }
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CompanyButton extends StatefulWidget {
  final String company;

  const CompanyButton(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyButtonState();
  }
}

class CompanyButtonState extends State<CompanyButton> {
  late Map<String, dynamic> _company;

  @override
  void initState() {
    super.initState();
    _company = jsonDecode(widget.company);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Colors.grey,
            minRadius: 18,
            foregroundImage: AssetImage('assets/images/default_avatar.jpg'),
          ),
          TextButton(
            onPressed: () {
              http.get(
                Uri.parse('http://10.0.2.2:3000/company?_id=${_company['_id']}'),
                headers: <String, String> {
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              ).then((response) {
                if (response.statusCode == 200) {
                  String company = jsonEncode(jsonDecode(response.body)['companys'][0]);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SafeArea(
                          child: Scaffold(
                            appBar: AppBar(
                              // backgroundColor: Colors.red,
                              title: const Text('Company Detail'),
                            ),
                            body: CompanyDetail(company),
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
              _company['name'],
              style: const TextStyle(
                fontSize: 16
              ),
            )
          ),
        ],
      ),
    );
  }
}

class JobDetailBody extends StatefulWidget {
  final String job;

  const JobDetailBody(
    this.job,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return JobDetailBodyState();
  }
}

class JobDetailBodyState extends State<JobDetailBody> {
  late Map<String, dynamic> _job;

  @override
  void initState() {
    super.initState();
    _job = jsonDecode(widget.job);
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
              'Job description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _job['description'],
              style: const TextStyle(
                fontSize: 16
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Job requirements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(
              _job['requirements'],
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
