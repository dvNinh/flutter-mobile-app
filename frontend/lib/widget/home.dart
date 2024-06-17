import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../user_info.dart';
import 'job_card.dart';
import '../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late String jobs;

  @override
  void initState() {
    super.initState();
    jobs = UserInfo.instance.job;
  }

  Future<http.Response> _requestJobList() {
    final response = http.get(
      Uri.parse('http://10.0.2.2:3000/job'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    return response;
  }

  Future<String> _getJobList() {
    return _requestJobList().then((response) {
      if (response.statusCode == 200) {
        var jobs = jsonDecode(response.body)['jobs'];
        UserInfo.instance.job = jsonEncode(jobs);
        return jsonEncode(jobs);
      }
      return 'error';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getJobList(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = const HomeView();
        } else {
          child = const Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  late List<dynamic> _job;

  @override
  void initState() {
    super.initState();
    _job = jsonDecode(UserInfo.instance.job);
  }

  Widget _randomJob() {
    if (_job.isNotEmpty) {
      int random = randomNumber(0, _job.length);
      var randomJob = _job[random];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: JobCard(
          randomJob['_id'],
          randomJob['company']['name'],
          randomJob['name'],
          randomJob['address'],
          randomJob['salary']
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // TextButton(
            //   onPressed: () {
            //     print(UserInfo.instance.company);
            //   },
            //   child: const Text('Test')
            // ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                'Recommend',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
            ),
            _randomJob(),
            _randomJob(),
            _randomJob(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(
                color: Color.fromRGBO(165, 165, 165, 165),
                thickness: 16,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                'Popular',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
            ),
            _randomJob(),
            _randomJob(),
            _randomJob(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(
                color: Color.fromRGBO(165, 165, 165, 165),
                thickness: 16,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                'Latest Jobs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
            ),
            _randomJob(),
            _randomJob(),
            _randomJob(),
          ],
        ),
      ),
    );
  }
}
