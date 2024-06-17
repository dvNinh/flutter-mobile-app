import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'job_detail.dart';
import '../user_info.dart';

class JobCard extends StatefulWidget {
  final String id;
  final String company;
  final String jobName;
  final String address;
  final String salary;

  const JobCard(
    this.id,
    this.company,
    this.jobName,
    this.address,
    this.salary,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return JobCardState();
  }
}

class JobCardState extends State<JobCard> {
  late String id;
  late String company;
  late String jobName;
  late String address;
  late String salary;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    company = widget.company;
    jobName = widget.jobName;
    address = widget.address;
    salary = widget.salary;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: GestureDetector(
        onTap: () {
          if (UserInfo.instance.user != '') {
            if (jsonDecode(UserInfo.instance.user)['role'] != 'Employer') {
              String userId = jsonDecode(UserInfo.instance.user)['_id'];
              String jobId = id;
              http.post(
                Uri.parse('http://10.0.2.2:3000/viewed'),
                headers: <String, String> {
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({
                  'userId': userId,
                  'jobId': jobId
                })
              );
            }
          }

          http.get(
            Uri.parse('http://10.0.2.2:3000/job?_id=$id'),
            headers: <String, String> {
              'Content-Type': 'application/json; charset=UTF-8',
            },
          ).then((response) {
            if (response.statusCode == 200) {
              String job = jsonEncode(jsonDecode(response.body)['jobs'][0]);
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
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          minRadius: 9,
                          foregroundImage: AssetImage('assets/images/default_avatar.jpg'),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            company,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  child: Text(
                    jobName,
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
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.location_on_outlined, size: 15),
                      ),
                      Expanded(
                        child: Text(
                          address,
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
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.attach_money, size: 15),
                      ),
                      Expanded(
                        child: Text(
                          salary,
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
            ),
          ),
        ),
      ),
    );
  }
}
