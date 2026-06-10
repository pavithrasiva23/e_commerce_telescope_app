import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z_user/customwidgets/login_section.dart';
import 'package:shop_a_to_z_user/customwidgets/registration_section.dart';
import 'package:shop_a_to_z_user/pages/view_telescope_page.dart';
import 'package:shop_a_to_z_user/utils/colors.dart';

import '../auth/auth_service.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';

enum AuthChoice {
  login,
  register
}

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errMsg = '';
  AuthChoice _authChoice = AuthChoice.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          shrinkWrap: true,
          children: [
            //1) Welcome Banner
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('Welcome, User',
              style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            //2) Segmented Button:
            SegmentedButton<AuthChoice>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states){
                  //Check with the state
                  if(states.contains(WidgetState.selected)) {
                    return kShrineBrown900;
                  }
                  return null; //return default color
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states){
                  if(states.contains(WidgetState.selected)){
                  return kShrineSurfaceWhite;
                }
                return kShrineBrown900;
                }),
                shape: WidgetStateProperty.resolveWith((states){
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  );
                })
              ),
                showSelectedIcon: false, //selected button's icon not needs to show, so it is false
                segments: const [
                  ButtonSegment<AuthChoice>(
                      value: AuthChoice.login,
                      label: Text('LOGIN')
                  ),
                  ButtonSegment<AuthChoice>(
                      value: AuthChoice.register,
                      label: Text('REGISTER')
                  )
                ],
                selected: {_authChoice}, //initially selected button's state 'AuthChoice' in "Set {}"
                onSelectionChanged: (choice){
                setState(() {
                  _authChoice = choice.first;
                });

                },
            ),
            //3)Login/Registration Actions
            Card(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: AnimatedCrossFade(
                      firstChild: LoginSection(
                          onSuccess: (){
                            Utils.showMsg(context, 'LoginIn Successful');
                          },
                          onFailure: (value){
                            setState(() {
                              _errMsg = value;
                            });
                          }),
                      secondChild: RegistrationSection(
                          onSuccess: (){
                            Utils.showMsg(context, 'Registration Successful');
                          },
                          onFailure: (value){
                            setState(() {
                              _errMsg = value;
                            });
                          }),
                      crossFadeState: _authChoice == AuthChoice.login ? CrossFadeState.showFirst : CrossFadeState.showSecond,//shows one widget at a time based on 'AuthChoice'
                      duration: const Duration(milliseconds: 500) //transition from 1st to 2nd and 2nd to 1st child),
              ),
            )),
            //4) Error Msg
            if(_errMsg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_errMsg,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red
              ),
              ),
            ),
            //5)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('----OR----',
              textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            //6) Google Sign In
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kShrineBrown900,
                foregroundColor: kShrineSurfaceWhite
              ),
                onPressed: _signInWithGoogle,
                icon: Icon(Icons.g_mobiledata),
                label: const Text('SIGNIN WITH GOOGLE'),

            )

          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    final credential = await AuthService.signInWithGoogle();
    //If user exists in firebase document will redirect to next page orelse will retrieve the new credential from user object and add it
    final exists = await Provider.of<UserProvider>(context, listen: false).doesUserExist(credential.user!.uid);
    //First time authentication
    if(!exists) {
      EasyLoading.show(status: 'Please Wait...');
      await Provider.of<UserProvider>(context, listen: false).addUser(user: credential.user!, name: credential.user!.displayName,
      phoneNumber: credential.user!.phoneNumber
      );
    }
    if(EasyLoading.isShow){
      EasyLoading.dismiss();
    }
    context.goNamed(ViewTelescopePage.routeName);
  }
}
