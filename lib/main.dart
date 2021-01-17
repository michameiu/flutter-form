import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app/auth/dashboard.dart';
import 'app/auth/login.dart';
import 'app/providers/auth.dart';
import 'app/screens/homepage.dart';
import 'app/theme/colors.dart';
import 'init.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final auth = Auth();
  final _init = Init();

  Future<bool> intitializeApp() async {
    // await auth.logout();
    var logged_in = await auth.getStorageToken();
    if (!logged_in) {
      return false;
    }
    print("the profile is ");
    print(auth.myProfile);
    Init.initializeApp(userId: auth.myProfile.id);
    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: auth,
        ),
//         ChangeNotifierProvider.value(
// //          create: (context)=>VehicleProvider(auth: Provider.of<Auth>(context)),
//           value: RepairProvider(auth: auth),
//         )
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: '',
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: createMaterialColor(Colors.white),
                accentColor: Colors.green,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: "nunitosans",
                cursorColor: Colors.green,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(vertical: 28),
                  border: UnderlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.7),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.7),
                  ),
                ),
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.green,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.elliptical(40, 30))),
                )),

            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: createMaterialColor(Colors.white),
              accentColor: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: "nunitosans",
              scaffoldBackgroundColor: Colors.white,
              cursorColor: Colors.grey,
              textTheme: TextTheme(
                  button: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.green,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.elliptical(40, 30))),
              ),
              chipTheme:
                  ChipTheme.of(context).copyWith(backgroundColor: Colors.white),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: EdgeInsets.symmetric(vertical: 28),
                border: UnderlineInputBorder(),
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300], width: 1.7),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.7),
                ),
              ),

//            fontFamily: "nunitosans"
            ),
//          home: Center(child: Text('Hello world !'),),
            home: FutureBuilder(
              future: intitializeApp(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Scaffold(
                      body: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Error: ${snapshot.error}');
                    } else {
                      if (snapshot.data) {
                        print("logged in");
                        // if (auth.myProfile.role == Role.V ||
                        //     auth.myProfile.role == Role.T) {
                        //   return TechnicianHomeScreen();
                        // }

                        // if (auth.myProfile.role == Role.N || auth.myProfile.role == Role.T) {
                        //   // return Navigator.of(context)
                        //   //     .pushReplacementNamed(TechnicianHomeScreen.routeName);
                        // }
                        return DashboardScreen();
                      } else {
                        print("not logged in ");
                        return DashboardScreen();
                      }
                    }
                }
              },
            ),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              HomePageScreen.routeName: (ctx) => HomePageScreen(),
              DashboardScreen.routeName: (ctx) => DashboardScreen(),
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VTrack App')),
      body: Center(child: Text("Welcome home  Safari Njema")),
    );
  }
}
