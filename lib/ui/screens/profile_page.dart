import 'package:flutter/material.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/ui/screens/signin_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cdewsv2/ui/screens/widgets/profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String myData = '';

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences().then((value) {
      setState(() {
        myData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Constants.primaryColor.withOpacity(.5),
                  width: 5.0,
                ),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: ExactAssetImage('assets/images/avatar.jpeg'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * .4,
              child: Row(
                children: [
                  Text(
                    myData,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 15,
                    ),
                  ),
                  // SizedBox(
                  //     height: 24,
                  //     child: Image.asset("assets/images/verified.png")),
                ],
              ),
            ),
            // Text(
            //   'johndoe@gmail.com',
            //   style: TextStyle(
            //     color: Constants.blackColor.withOpacity(.3),
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: const SignIn(),
                        type: PageTransitionType.leftToRight));
              },
              child: SizedBox(
                height: size.height * .6,
                width: size.width,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileWidget(
                      icon: Icons.logout,
                      title: 'Log Out',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

Future<String> getDataFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userName =
      prefs.getString('name') ?? ''; // Replace 'myDataKey' with your own key
  return userName;
}
