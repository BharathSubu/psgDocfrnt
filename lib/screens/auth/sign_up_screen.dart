import 'dart:convert';

import 'package:docfrnt/constants.dart';
import 'package:docfrnt/network/networkapi.dart';
import 'package:docfrnt/screens/auth/home.dart';
import 'package:docfrnt/screens/auth/sign_in_screen.dart';
import 'package:docfrnt/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'components/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // It's time to validat the text field
  final _formKey = GlobalKey<FormState>();
  String errorText = ""; //to check for unique user name
  bool validate = false; //as boolen type
  bool circular = false; //to show circular bar instead of circular
  final storage = new FlutterSecureStorage();

  NetworkHandler networkHandler = NetworkHandler();

  late String _userName, _email, _password, _phoneNumber;

  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // But still same problem, let's fixed it
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/icons/Sign_Up_bg.svg",
            // height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            // Now it takes 100% of our height
          ),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              )),
                          child: Text(
                            "Sign In!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    TextFieldName(text: "Username"),
                    TextFormField(
                      decoration: InputDecoration(hintText: "theflutterway"),
                      validator:
                          RequiredValidator(errorText: "Username is required"),
                      // Let's save our username
                      onSaved: (username) => _userName = username!,
                      onChanged: (username) => _userName = username,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFieldName(text: "Field"),
                    TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration:
                              InputDecoration(hintText: "theflutterway"),
                          controller: this._typeAheadController,
                        ),
                        suggestionsCallback: (pattern) async {
                          return await StateService.getSuggestions(pattern);
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.toString()),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          this._typeAheadController.text =
                              suggestion.toString();
                        }),
                    const SizedBox(height: defaultPadding),
                    // We will fixed the error soon
                    // As you can see, it's a email field
                    // But no @ on keybord
                    TextFieldName(text: "Email"),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "test@email.com"),
                      validator:
                          EmailValidator(errorText: "Use a valid email!"),
                      onSaved: (email) => _email = email!,
                      onChanged: (email) => _email = email,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFieldName(text: "Phone"),
                    // Same for phone number
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(hintText: "+123487697"),
                      validator: RequiredValidator(
                          errorText: "Phone number is required"),
                      onSaved: (phoneNumber) => _phoneNumber = phoneNumber!,
                      onChanged: (phoneNumber) => _phoneNumber = phoneNumber,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFieldName(text: "Password"),

                    TextFormField(
                      // We want to hide our password
                      obscureText: true,
                      decoration: InputDecoration(hintText: "******"),
                      validator: passwordValidator,
                      onSaved: (password) => _password = password!,
                      // We also need to validate our password
                      // Now if we type anything it adds that to our password
                      onChanged: (password) => _password = password,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFieldName(text: "Confirm Password"),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(hintText: "*****"),
                      validator: (pass) =>
                          MatchValidator(errorText: "Password do not  match")
                              .validateMatch(pass!, _password),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       if (_formKey.currentState!.validate()) {
                    //         _formKey.currentState!.save();
                    //         print(_userName);
                    //       }
                    //     },
                    //     child: Text("Sign Up"),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          circular = true;
                        });

                        if (true) {
                          //validate - if username unique
                          // we will send the data to rest server
                          var data = {
                            'name': '${_userName}',
                            'password': '${_password}',
                            'email': '${_email}',
                            'role': '${_typeAheadController.text}',
                            'phone': '${_phoneNumber}'
                          };
                          print("My dataa $data");
                          var responseRegister =
                              await networkHandler.post("duser/register", data);
                          setState(() {
                            circular = false;
                          });
                          print("Response from Signup ${responseRegister}");

                          //Login Logic added here
                          if (responseRegister.statusCode == 200 ||
                              responseRegister.statusCode == 201) {
                            Map<String, String> data = {
                              "email": _email,
                              "password": _password,
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
                              print("error");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomeScreen(),
                                  ),
                                  (route) => false);
                              //deprecated package
                              //Scaffold.of(context).showSnackBar(
                              //  SnackBar(content: Text("Netwok Error")));
                            }
                          }

                          //Login Logic end here

                          setState(() {
                            circular = false;
                          });
                        } else {
                          setState(() {
                            circular = false;
                          });
                        }
                      },
                      child: circular
                          ? CircularProgressIndicator()
                          : Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff00A86B),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
