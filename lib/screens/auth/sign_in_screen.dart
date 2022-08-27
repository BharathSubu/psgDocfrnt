import 'dart:convert';

import 'package:docfrnt/network/networkapi.dart';
import 'package:docfrnt/screens/auth/sign_up_screen.dart';
import 'package:docfrnt/screens/auth/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../constants.dart';
import 'components/sign_in_form.dart';
import 'components/sign_up_form.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // It's time to validat the text field
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  NetworkHandler networkHandler = NetworkHandler();
  String errorText = " ";
  bool validate = false;
  bool circular = false;
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    // But still same problem, let's fixed it
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(
              "assets/icons/Sign_Up_bg.svg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign In",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            ),
                            child: Text(
                              "Sign Up!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldName(text: "Email"),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration:
                                  InputDecoration(hintText: "test@email.com"),
                              validator: EmailValidator(
                                  errorText: "Use a valid email!"),
                              onSaved: (email) => _email = email!,
                              onChanged: (email) => _email = email,
                            ),
                            const SizedBox(height: defaultPadding),
                            TextFieldName(text: "Password"),
                            TextFormField(
                              // We want to hide our password
                              obscureText: true,
                              decoration: InputDecoration(hintText: "******"),
                              validator: passwordValidator,
                              onSaved: (password) => _password = password!,
                              onChanged: (password) => _password = password,
                            ),
                            const SizedBox(height: defaultPadding),
                          ],
                        ),
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            circular = true;
                          });
                          //Login Logic start here
                          Map<String, String> data = {
                            'password': '${_password}',
                            'email': '${_email}',
                          };
                          var response =
                              await networkHandler.post("duser/login", data);
                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Map<String, dynamic> output =
                                json.decode(response.body);
                            print(output["token"]);
                            await storage.write(
                                key: "token", value: output["token"]);
                            await storage.write(
                                key: "email", value: output["email"]);
                            setState(() {
                              validate = true;
                              circular = false;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                                (route) => false);
                          } else {
                            String output = json.decode(response.body);
                            setState(() {
                              validate = false;
                              errorText = output;
                              circular = false;
                            });
                          }
                          // login logic End here
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff00A86B),
                          ),
                          child: Center(
                            child: circular
                                ? CircularProgressIndicator()
                                : Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
