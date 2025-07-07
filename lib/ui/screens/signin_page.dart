import 'package:flutter/material.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/ui/root_page.dart';
import 'package:cdewsv2/ui/screens/forgot_password.dart';
// import 'package:cdewsv2/ui/screens/signup_page.dart';
// import 'package:cdewsv2/ui/screens/widgets/custom_textfield.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  loginPressed(String nameController, String passwordController) async {
    final url = Uri.parse('https://c-dews.synqbox.com/api/login');
    final response = await http.post(url,
        body: {'username': nameController, 'password': passwordController});
    Map responseMap = jsonDecode(response.body);
    print(responseMap);

    if (responseMap.values.first == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('scopeValue', '${responseMap['data']['scope']}');
      prefs.setString(
          'permissionValue', '${responseMap['data']['permission']}');
      prefs.setString('name', '${responseMap['data']['name']}');
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const RootPage(), type: PageTransitionType.bottomToTop));
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${responseMap['status']}'),
            content: Text('${responseMap['message']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TextEditingController _nameController = TextEditingController();
    // TextEditingController _passwordController = TextEditingController();
    // var _text = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0, left: 5.0),
                            child: Image.asset('assets/images/cdewsIcon.png'),
                          )),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Container(
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'C-DEWS',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(251, 8, 145, 178),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Container(
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Community-Dengue Early Warning System',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(251, 8, 145, 178),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                // Image.asset('assets/images/cdews.png'),
                Container(
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle),
                      labelText: 'Enter Username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Enter Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Constants.cyanColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 2, vertical: 18),
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      loginPressed(
                          _nameController.text, _passwordController.text);
                      // print('clicked!');
                    },
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     // loginPressed(_nameController.text, _passwordController.text);
                //     print('Button');
                //   },
                //   child: Container(
                //     width: size.width,
                //     decoration: BoxDecoration(
                //       color: Constants.cyanColor,
                //       borderRadius: BorderRadius.circular(40),
                //     ),
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                //     margin: const EdgeInsets.only(left: 8, right: 8),
                //     child: const Center(
                //       child: Text(
                //         'Login',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 18.0,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const ForgotPassword(),
                            type: PageTransitionType.bottomToTop));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          // text: 'Forgot Password? ',
                          style: TextStyle(
                            color: Constants.blackColor,
                          ),
                        ),
                        TextSpan(
                          // text: 'Reset Here',
                          style: TextStyle(
                            color: Constants.primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
