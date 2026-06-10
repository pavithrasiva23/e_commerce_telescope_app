import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_a_to_z/auth/auth_service.dart';
import 'package:shop_a_to_z/customwidgets/dashboard_item_view.dart';
import 'package:shop_a_to_z/models/dashboard_model.dart';
import 'package:shop_a_to_z/pages/login_page.dart';
import 'package:shop_a_to_z/providers/order_provider.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shop_a_to_z/providers/user_provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background using a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'new_order'){
      print('Order Doc ID: ${message.data['value']}'); //replace with order list navigation screen

    }
  }
  @override
  void initState() {
    setupInteractedMessage();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    Provider.of<TelescopeProvider>(context, listen: false).getAllBrands();
    Provider.of<TelescopeProvider>(context, listen: false).getAllTelescopes();
    Provider.of<OrderProvider>(context, listen: false).getAllOrders();
    Provider.of<UserProvider>(context, listen: false).getAllUsers();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            AuthService.logout().then((value)=> context.goNamed(LoginPage.routeName));
          },
              icon: Icon(Icons.logout))
        ],
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: dashboardList.length,
          itemBuilder: (context, index){
            final model = dashboardList[index];
            return DashboardItemView(
                model: model, onPress: (route){
                  context.goNamed(route);
            });
          })
    );
  }
}
