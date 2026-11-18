import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';
import 'constants/app_constants.dart';
import 'configData/commande.dart';
import 'screens/login_page.dart';
import 'screens/precommande_page.dart';
import 'screens/precommander_form_page.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => CartProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.primaryBlue,
        scaffoldBackgroundColor: AppConstants.scaffoldBg,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppConstants.textBlack,
          elevation: 0.5,
        ),
      ),
      home: HomeScreen(),
            onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/suivi':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LoginPage(),
            );

          case '/suivi/commande':
            final commande = settings.arguments;
            if (commande is Commande) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => PrecommandePage(commande: commande),
              );
            }
            // Page rechargée sans commande : retour à la connexion
            return MaterialPageRoute(
              settings: const RouteSettings(name: '/suivi'),
              builder: (_) => const LoginPage(),
            );
            
                    case '/precommander':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PrecommanderFormPage(),
            );

          default:
            return MaterialPageRoute(
              settings: const RouteSettings(name: '/'),
              builder: (_) => HomeScreen(),
            );
        }
      },
    ),
  ),
);
