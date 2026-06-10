import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_a_to_z_user/auth/auth_service.dart';
import 'package:shop_a_to_z_user/pages/cart_page.dart';
import 'package:shop_a_to_z_user/pages/checkout_page.dart';
import 'package:shop_a_to_z_user/pages/login_page.dart';
import 'package:shop_a_to_z_user/pages/telescope_details_page.dart';
import 'package:shop_a_to_z_user/pages/view_telescope_page.dart';
import 'package:shop_a_to_z_user/providers/cart_provider.dart';
import 'package:shop_a_to_z_user/providers/order_provider.dart';
import 'package:shop_a_to_z_user/providers/telescope_provider.dart';
import 'package:shop_a_to_z_user/providers/user_provider.dart';
import 'package:shop_a_to_z_user/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider()),
        ChangeNotifierProvider(create: (context)=> TelescopeProvider()),
        ChangeNotifierProvider(create: (context)=> CartProvider()),
        ChangeNotifierProvider(create: (context)=> OrderProvider()),
      ],
  child:  MyApp()));
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  ThemeData _buildShrineTheme() {
    final ThemeData base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: kShrinePink100,
        onPrimary: kShrineBrown900,
        secondary: kShrineBrown900,
        error: kShrineErrorRed
      ),
      textTheme: _buildShrineTextTheme(GoogleFonts.ralewayTextTheme()),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: kShrinePink100
      )
    );
  }

  //Default theme color
  TextTheme _buildShrineTextTheme(TextTheme base){
    return base.copyWith(
      headlineSmall: base.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
      titleLarge: base.titleLarge!.copyWith(fontSize: 18.0),
      bodySmall: base.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14.0
      ),
        bodyLarge: base.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16.0
        )
    ).apply(
        displayColor: kShrineBrown900,
        bodyColor: kShrineBrown900
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, //"_router object"
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: _buildShrineTheme(),
    );
  }

final _router = GoRouter(
    initialLocation: ViewTelescopePage.routeName,
    debugLogDiagnostics: true,
    redirect: (context, state){
      if(AuthService.currentUser == null){
        return LoginPage.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
          name: LoginPage.routeName,
          path: LoginPage.routeName,
          builder: (context, state) => const LoginPage()
      ),
      GoRoute(
          name: ViewTelescopePage.routeName,
          path: ViewTelescopePage.routeName,
          builder: (context, state) => const ViewTelescopePage(),
        routes: [
          GoRoute(
              name: TelescopeDetailsPage.routeName,
              path: TelescopeDetailsPage.routeName,
              builder: (context, state) =>  TelescopeDetailsPage(prodId: state.extra! as String,)
          ),
          GoRoute(
              name: CartPage.routeName,
              path: CartPage.routeName,
              builder: (context, state) => const CartPage(),
            routes: [
              GoRoute(
                name: CheckoutPage.routeName,
                path: CheckoutPage.routeName,
                builder: (context, state) => const CheckoutPage(),)
            ]
          ),
        ]
      ),

    ]

);
}

