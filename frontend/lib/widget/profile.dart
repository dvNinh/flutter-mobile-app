import 'dart:convert';

import 'package:flutter/material.dart';

import 'sign_in.dart';
import 'main.dart';
import '../user_info.dart';
import 'add_new_job.dart';
import './update_profile.dart';
import 'edit_description.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  late String _user;

  @override
  void initState() {
    super.initState();
    _user = UserInfo.instance.user;
  }

  @override
  Widget build(BuildContext context) {
    if (_user == '') {
      return const UnLoggedProfile();
    } else {
      return LoggedProfile(_user);
    }
  }
}

class UnLoggedProfile extends StatelessWidget {
  const UnLoggedProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Card(
            elevation: 5,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 40,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Sign in to apply!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            minimumSize: Size(MediaQuery.of(context).size.width - 168, 38),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInWidget()
                              ),
                            );
                          },
                          child: const Text('Sign In')
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoggedProfile extends StatelessWidget {
  final String _user;

  const LoggedProfile(
    this._user,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    var user = jsonDecode(_user);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AccountCard(_user),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                'Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Info(_user),
            user['role'] == 'Candidate' ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ) : const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text(
                'Add new job',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            user['role'] == 'Candidate' ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const EditDescriptionWidget();
                      }
                    )
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              )
            ) : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AddNewJobWidget();
                      }
                    )
                  );
                },
                icon: const Icon(Icons.add_circle),
                label: const Text('Add new job'),
              )
            ),
            user['role'] == 'Candidate' ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Text(
                user['description'],
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            ) : Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const UpdateProfileWidget();
              }
            )
          );
        },
        child: const Icon(Icons.edit)
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final String _user;

  const AccountCard(
    this._user,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              const Avatar(),
              SignInButton(_user)
            ],
          )
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        minRadius: 40,
        foregroundImage: AssetImage('assets/images/default_avatar.jpg'),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  final String _user;

  const ProfileName(
    this._user,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '${jsonDecode(_user)['firstName']} ${jsonDecode(_user)['lastName']}',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final String _user;

  const SignInButton(
    this._user,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            '${jsonDecode(_user)['firstName']} ${jsonDecode(_user)['lastName']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18),
              minimumSize: Size(MediaQuery.of(context).size.width - 168, 38),
            ),
            onPressed: () {
              UserInfo.instance.user = '';
              UserInfo.instance.company = '';
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainWidget()
                ),
                (Route route) => false
              );
            },
            child: const Text('Sign Out')
          ),
        ),
      ],
    );
  }
}

class Info extends StatelessWidget {
  final String _user;

  const Info(
    this._user,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 15),
                    Text(' ${jsonDecode(_user)['address']}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 15),
                    Text(' ${jsonDecode(_user)['phoneNumber']}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 15),
                    Text(' ${jsonDecode(_user)['email']}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_outline, size: 15),
                    Text(' ${jsonDecode(_user)['gender']}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(Icons.cake_outlined, size: 15),
                    Text(' ${jsonDecode(_user)['dob']}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}