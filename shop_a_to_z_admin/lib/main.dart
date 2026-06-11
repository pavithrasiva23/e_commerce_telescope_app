import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z/auth/auth_service.dart';
import 'package:shop_a_to_z/pages/add_telescope_page.dart';
import 'package:shop_a_to_z/pages/brand_page.dart';
import 'package:shop_a_to_z/pages/dashboard_page.dart';
import 'package:shop_a_to_z/pages/description_page.dart';
import 'package:shop_a_to_z/pages/login_page.dart';
import 'package:shop_a_to_z/pages/orders_page.dart';
import 'package:shop_a_to_z/pages/report_page.dart';
import 'package:shop_a_to_z/pages/telescope_detailed_page.dart';
import 'package:shop_a_to_z/pages/users_profile_page.dart';
import 'package:shop_a_to_z/pages/view_telescope_list_page.dart';
import 'package:shop_a_to_z/providers/order_provider.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import 'package:shop_a_to_z/providers/user_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //I removed 'Firebase.initializeApp() because already it initialized in the main() function
  if(message.notification != null){
    print("You have a notification: ${message.notification!.title}");
  }
  print('Data: ${message.data['value']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //Subscribe to the specific topic
  await FirebaseMessaging.instance.subscribeToTopic('order');
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> TelescopeProvider()),
        ChangeNotifierProvider(create: (context)=> OrderProvider()),
        ChangeNotifierProvider(create: (context)=> UserProvider())
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
  final _router = GoRouter(
    initialLocation: DashboardPage.routeName,
    redirect: (context, state){
      if(AuthService.currentUser == null){
        return LoginPage.routeName;
      }
      return null;
    },
      routes: [
        GoRoute(
            name: DashboardPage.routeName,
            path: DashboardPage.routeName,
            builder: (context, state)=> const DashboardPage(),
            routes: [
              GoRoute(
                  path: AddTelescopePage.routeName,
                  name: AddTelescopePage.routeName,
                  builder: (context, state)=> const AddTelescopePage()
              ),
              GoRoute(
                  path: ViewTelescopeListPage.routeName,
                  name: ViewTelescopeListPage.routeName,
                  builder: (context, state) => const ViewTelescopeListPage(),
                  routes: [
                    GoRoute(
                        path: TelescopeDetailedPage.routeName,
                        name: TelescopeDetailedPage.routeName,
                      builder: (context, state){
                          final telescopeId = state.extra! as String;
                          return TelescopeDetailedPage(telescopeId: telescopeId);
                      },
                      routes: [
                        GoRoute(
                          path: DescriptionPage.routeName,
                          name: DescriptionPage.routeName,
                          builder: (context, state) {
                           final telescopeId = state.extra! as String;
                           return DescriptionPage(telescopeId: telescopeId);
                          }
                        )
                      ]
                    ),

                  ]
              ),
              GoRoute(
                  path: BrandPage.routeName,
                  name: BrandPage.routeName,
                  builder: (context, state) => const BrandPage()
              ),
              GoRoute(
                  path: OrdersPage.routeName,
                  name: OrdersPage.routeName,
                  builder: (context, state) => const OrdersPage()
              ),
              GoRoute(
                  path: UsersProfilePage.routeName,
                  name: UsersProfilePage.routeName,
                  builder: (context, state) => const UsersProfilePage()
              ),
              GoRoute(
                  path: ReportPage.routeName,
                  name: ReportPage.routeName,
                  builder: (context, state) => const ReportPage()
              ),
            ]
        ),
        GoRoute(
            name: LoginPage.routeName,
            path: LoginPage.routeName,
            builder: (context, state)=> const LoginPage()
        ),
      ]);
}

