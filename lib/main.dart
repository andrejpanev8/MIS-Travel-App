import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/screens/my_rides_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/widgets/custom_app_bar.dart';
import 'utils/color_constants.dart';
import 'utils/image_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => UserBloc()),
    BlocProvider(create: (context) => HomeScreenBloc()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickRide',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: _transportIconWidget(), label: 'My rides'),
          const NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        selectedIndex: currentPageIndex,
      ),
      body: [HomeScreen(), MyRidesScreen(), ProfileScreen()][currentPageIndex],
    );
  }
}

Widget _transportIconWidget() {
  return SvgPicture.asset(
    transportIcon,
    colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
  );
}
