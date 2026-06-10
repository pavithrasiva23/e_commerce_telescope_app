import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z_user/providers/user_provider.dart';
import '../auth/auth_service.dart';
import '../utils/colors.dart';

class RegistrationSection extends StatefulWidget {
  final VoidCallback onSuccess; //login btn pressed , success or not status as callback
  final Function(String) onFailure; //show failure msg
  const RegistrationSection({super.key, required this.onSuccess, required this.onFailure});

  @override
  State<RegistrationSection> createState() => _RegistrationSectionState();
}

class _RegistrationSectionState extends State<RegistrationSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    _emailController.text = 'user1@gmail.com';
    _passwordController.text = '123456'; //firebase requires minimum of 6 characters
    _nameController.text = 'ABC';
    _phoneController.text = '9876543210';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formKey,
      child: Column(
        children: [
          //1) Name
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Your Name (optional)',
              ),
              validator: (value){
                return null;
              },
            ),
          ),
          //2) Phone Number
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                labelText: 'Mobile Number (optional)',
              ),
              validator: (value){
                return null;
              },
            ),
          ),
          //3) Email Address
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
          //4) Password
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
          //5) Register
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kShrineBrown900,
                    foregroundColor: kShrineSurfaceWhite
                ),
                onPressed: _register,
                child: Text('SIGN UP')),
          )
        ],
      ),
    );
  }

  void _register() async {
   if(_formKey.currentState!.validate()) {
     EasyLoading.show(status: 'Please Wait...');
     final name = _nameController.text;
     final phone = _phoneController.text;
     final email = _emailController.text;
     final password = _passwordController.text;
     try {
       //Register the user
       final user = await AuthService.register(email, password);
       //Add that user and document it in FirebaseFirestore
       await Provider.of<UserProvider>(context, listen: false).addUser(user: user, name: name, phoneNumber: phone);
       EasyLoading.dismiss();
       widget.onSuccess();
     } on FirebaseAuthException catch(error){
       EasyLoading.dismiss();
       widget.onFailure(error.message!);
     }
   }
  }
}
