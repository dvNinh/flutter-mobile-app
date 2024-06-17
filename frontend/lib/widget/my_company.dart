import 'package:flutter/material.dart';
import 'package:job_app/user_info.dart';

import 'company_detail.dart';
import 'update_company.dart';

class MyCompany extends StatefulWidget {
  const MyCompany({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyCompanyState();
  }
}

class MyCompanyState extends State<MyCompany> {
  late String _company;

  @override
  void initState() {
    super.initState();
    _company = UserInfo.instance.company;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CompanyDetail(_company),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const UpdateCompanyWidget();
              }
            )
          );
        },
        child: const Icon(Icons.edit)
      ),
    );
  }
}