import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'job_card.dart';
import 'sign_in.dart';
import '../user_info.dart';

class MyJobs extends StatefulWidget {
  const MyJobs({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyJobsState();
  }
}

class MyJobsState extends State<MyJobs> {
  late String _user;
  final List<String> _tabLabels = ['Viewed', 'Saved', 'Applied'];

  @override
  void initState() {
    super.initState();
    _user = UserInfo.instance.user;
  }

  List<Widget> _createTabs(List<String> labels) {
    List<Widget> tabs = [];
    for (String label in labels) {
      tabs.add(
        Tab(text: label),
      );
    }
    return tabs;
  }

  Future<String> _getViewed() {
    var user = jsonDecode(_user);
    return http.get(
      Uri.parse('http://10.0.2.2:3000/viewed?userId=${user['_id']}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      var vieweds = jsonDecode(response.body)['vieweds'];
      var jobs = [];
      for (var viewed in vieweds) {
        jobs.add(viewed['job']);
      }
      return jsonEncode(jobs);
    });
  }

  Future<String> _getSaved() {
    var user = jsonDecode(_user);
    return http.get(
      Uri.parse('http://10.0.2.2:3000/saved?userId=${user['_id']}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      var saveds = jsonDecode(response.body)['saveds'];
      var jobs = [];
      for (var saved in saveds) {
        jobs.add(saved['job']);
      }
      return jsonEncode(jobs);
    });
  }

  Future<String> _getApplied() {
    var user = jsonDecode(_user);
    return http.get(
      Uri.parse('http://10.0.2.2:3000/applied?userId=${user['_id']}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      var applieds = jsonDecode(response.body)['applieds'];
      var jobs = [];
      for (var applied in applieds) {
        jobs.add(applied['job']);
      }
      return jsonEncode(jobs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabLabels.length,
      child: Scaffold(
        appBar: TabBar(
          tabs: _createTabs(_tabLabels),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
        ),
        body: _user == '' ? const TabBarView(
          children: <Widget>[
            UnLoggedJobList(
              Icons.assignment_outlined,
              'Jobs you just viewed recently',
              'viewed',
            ),
            UnLoggedJobList(
              Icons.favorite_border_outlined,
              'Your saved jobs',
              'saved',
            ),
            UnLoggedJobList(
              Icons.send_outlined,
              'Your applied jobs',
              'applied',
            ),
          ],
        ) : TabBarView(
          children: <Widget>[
            FutureBuilder<String>(
              future: _getViewed(),
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
                        children: jobList(snapshot.data!),
                      ),
                    ),
                  );
                } else {
                  child = const Center(child: CircularProgressIndicator());
                }
                return child;
              },
            ),
            FutureBuilder<String>(
              future: _getSaved(),
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
                        children: jobList(snapshot.data!),
                      ),
                    ),
                  );
                } else {
                  child = const Center(child: CircularProgressIndicator());
                }
                return child;
              },
            ),
            FutureBuilder<String>(
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
                        children: jobList(snapshot.data!),
                      ),
                    ),
                  );
                } else {
                  child = const Center(child: CircularProgressIndicator());
                }
                return child;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UnLoggedJobList extends StatelessWidget {
  final IconData icon;
  final String description;
  final String tab;

  const UnLoggedJobList(
    this.icon,
    this.description,
    this.tab,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 70,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.grey,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInWidget()
              ),
            );
          },
          child: const Text(
            'Sign in now',
            style: TextStyle(fontSize: 16),
          )
        ),
      ],
    );
  }
}

List<Widget> jobList(String jobs) {
  if (jobs == '') return [];
  var jobList = jsonDecode(jobs);
  List<Widget> jobsWidget = [];
  for (var job in jobList) {
    jobsWidget.add(Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: JobCard(
        job['_id'],
        job['company']['name'],
        job['name'],
        job['address'],
        job['salary'],
      ),
    ));
  }
  return jobsWidget;
}
