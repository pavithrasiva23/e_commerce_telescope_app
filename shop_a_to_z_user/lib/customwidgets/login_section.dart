import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z_user/pages/view_telescope_page.dart';
import 'package:shop_a_to_z_user/utils/colors.dart';

import '../auth/auth_service.dart';
import '../providers/user_provider.dart';

class LoginSection extends StatefulWidget {
  final VoidCallback onSuccess; //login btn pressed , success or not status as callback
  final Function(String) onFailure; //show failure msg
  const LoginSection({super.key, required this.onSuccess, required this.onFailure});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = 'user1@gmail.com';
    _passwordController.text = '123456'; //firebase requires minimum of 6 characters
    super.initState();
  }

  @override
  void dispose() {
   _emailController.dispose();
   _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //1) Email Address
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email Address',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Provide a email address';
                }
                return null;
              },
            ),
          ),
          //2) Password
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true, //can't see the password
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Provide a password';
                }
                else if(value.length < 6){
                  return 'Please provide minimum 6 characters';
                }
                return null;
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kShrineBrown900,
                foregroundColor: kShrineSurfaceWhite
              ),
                onPressed: _login,
                child: Text('SIGN IN')),
          )
        ],
      ),
    );
  }

void _login() async {
  if(_formKey.currentState!.validate()) {
    EasyLoading.show(status: 'Please Wait...');
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      //Login with user credentials
      final user = await AuthService.login(email, password);
      //Go to new page
      context.goNamed(ViewTelescopePage.routeName);
      EasyLoading.dismiss();
      widget.onSuccess();
    } on FirebaseAuthException catch(error){
      EasyLoading.dismiss();
      widget.onFailure(error.message!);
    }
  }
}
}
