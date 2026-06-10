import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_a_to_z/auth/auth_service.dart';
import 'package:shop_a_to_z/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextCtrl = TextEditingController();
  final _passwordTextCtrl = TextEditingController();
  String _errorMsg = '';

  @override
  void dispose() {
    _emailTextCtrl.dispose();
    _passwordTextCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            shrinkWrap: true,
            children: [
             //Email
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _emailTextCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.mail),
                    labelText: 'Email Address'
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Provide a valid email adddress';
                    }
                    return null;
                  },
                ),
              ),
              //Password
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  obscureText: true, //will be seen as an asterieks
                  controller: _passwordTextCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.password),
                      labelText: 'Password (at least 6 characters)'
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Provide a valid password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: _authenticate,
                  child: const Text('Login as Admin')),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_errorMsg, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),))
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate() async {
    if(_formKey.currentState!.validate()){
      EasyLoading.show(status: 'Please wait...');
      final email = _emailTextCtrl.text;
      final password = _passwordTextCtrl.text;
      try {
        final status = await AuthService.loginAdmin(email, password);
        EasyLoading.dismiss();
        if(status){
          context.goNamed(DashboardPage.routeName);
        }
        else {
          await AuthService.logout();
          setState(() {
            _errorMsg = 'This is not an admin account';
          });
        }

      } on FirebaseAuthException catch(error){
        EasyLoading.dismiss();
        setState(() {
          _errorMsg = error.message!;
        });
      }
    }
  }
}
