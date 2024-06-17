import 'dart:convert';

import 'package:flutter/material.dart';

import 'job_card.dart';

class CompanyDetail extends StatefulWidget {
  final String company;

  const CompanyDetail(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyDetailState();
  }
}

class CompanyDetailState extends State<CompanyDetail> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CompanyDetailHead(_company),
          CompanyDetailBody(_company)
        ],
      ),
    );
  }
}

class CompanyDetailHead extends StatefulWidget {
  final String company;

  const CompanyDetailHead(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyDetailHeadState();
  }
}

class CompanyDetailHeadState extends State<CompanyDetailHead> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    var company = jsonDecode(_company);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            company['name'],
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class CompanyDetailBody extends StatefulWidget {
  final String company;

  const CompanyDetailBody(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyDetailBodyState();
  }
}

class CompanyDetailBodyState extends State<CompanyDetailBody> {
  late String _company;
  late int _viewPage;

  late List<String> _pageTitle;
  late List<Widget> _pageBody;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
    _viewPage = 0;
    _pageTitle = ['About', 'Jobs'];
    _pageBody = [
      CompanyAbout(_company),
      CompanyJobs(_company),
    ];
  }

  List<Widget> _tabButton() {
    List<Widget> button = [];
    for (int i = 0; i < _pageTitle.length; i++) {
      button.add(Container(
        width: MediaQuery.of(context).size.width / _pageTitle.length,
        decoration: i == _viewPage ? const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Colors.blue
            ),
          ),
        ) : null,
        child: TextButton(
          onPressed: () {
            setState(() {
              _viewPage = i;
            });
          },
          child: Text(
            _pageTitle[i],
            style: TextStyle(
              fontSize: 16,
              color: i == _viewPage ? Colors.blue : Colors.grey
            ),
          )
        )
      ));
    }
    return button;
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
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: _tabButton()
            ),
          ),
          _pageBody[_viewPage]
        ],
      ),
    );
  }
}

class CompanyAbout extends StatefulWidget {
  final String company;

  const CompanyAbout(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyAboutState();
  }
}

class CompanyAboutState extends State<CompanyAbout> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CompanyInformation(_company),
          CompanyIntroduction(_company)
        ],
      ),
    );
  }
}

class CompanyInformation extends StatefulWidget {
  final String company;

  const CompanyInformation(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyInformationState();
  }
}

class CompanyInformationState extends State<CompanyInformation> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    var company = jsonDecode(_company);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconText(
            Icons.link_outlined,
            company['website'] ?? 'website',
            company['website'] == null ? Colors.grey : Colors.black
          ),
          iconText(
            Icons.location_on_outlined,
            company['address'] ?? 'address',
            company['address'] == null ? Colors.grey : Colors.black
          ),
          iconText(
              Icons.mail_outline,
              company['employer']['email'] ?? 'email',
              company['employer']['email'] == null ? Colors.grey : Colors.black
          ),
          iconText(
              Icons.phone_outlined,
              company['employer']['phoneNumber'] ?? 'phoneNumber',
              company['employer']['phoneNumber'] == null ? Colors.grey : Colors.black
          ),
        ]
      ),
    );
  }
}

Widget iconText(IconData iconData, String text, Color textColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(iconData, size: 18),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16
            )
          ),
        ),
      ],
    ),
  );
}

class CompanyIntroduction extends StatefulWidget {
  final String company;

  const CompanyIntroduction(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyIntroductionState();
  }
}

class CompanyIntroductionState extends State<CompanyIntroduction> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    var company = jsonDecode(_company);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Introduction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            company['introduction'],
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class CompanyJobs extends StatefulWidget {
  final String company;

  const CompanyJobs(
    this.company,
    {super.key}
  );

  @override
  State<StatefulWidget> createState() {
    return CompanyJobsState();
  }
}

class CompanyJobsState extends State<CompanyJobs> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: jobList(_company)
      ),
    );
  }
}

List<Widget> jobList(String data) {
  var company = jsonDecode(data);
  List<Widget> jobsWidget = [];
  for (var job in company['jobs']) {
    jobsWidget.add(Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: JobCard(
        job['_id'],
        company['name'],
        job['name'],
        job['address'],
        job['salary'],
      ),
    ));
  }
  return jobsWidget;
}
