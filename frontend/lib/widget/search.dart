import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './job_card.dart';

class SearchWidget extends StatefulWidget {
  final String jobs;

  const SearchWidget({this.jobs = '', super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchWidgetState();
  }
}

class SearchWidgetState extends State<SearchWidget> {
  late String _jobs;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _jobs = widget.jobs;
  }

  Future<http.Response> _search(String data) {
    final response = http.post(
      Uri.parse('http://10.0.2.2:3000/search'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'value': data
      }),
    ).timeout(const Duration(seconds: 10));
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    _search(value).then((response) {
                      String jobs = jsonEncode(jsonDecode(response.body)['jobs']);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchWidget(jobs: jobs);
                          }
                        )
                      );
                    });
                  },
                )
              ),
              SearchResult(_jobs),
            ],
          ),
        ),
      )
    );
  }
}

class SearchResult extends StatefulWidget {
  final String jobs;

  const SearchResult(
    this.jobs,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {
  late String _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = widget.jobs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: jobList(_jobs),
      ),
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
