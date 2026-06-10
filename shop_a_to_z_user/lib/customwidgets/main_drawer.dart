import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_service.dart';
import '../pages/cart_page.dart';
import '../pages/login_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            height: 150,
          ),
          ListTile(
            onTap: (){},
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: (){
              context.pop(); //first pop drawer
              context.goNamed(CartPage.routeName);
            },
            leading: const Icon(Icons.shopping_cart_outlined),
            title: const Text('My Cart'),
          ),
          ListTile(
            onTap: (){},
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          ListTile(
            onTap: (){
              AuthService.logout().then((value)=> context.goNamed(LoginPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
          )
        ],
      ),
    );
  }
}
