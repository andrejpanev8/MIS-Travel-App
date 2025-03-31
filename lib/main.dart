import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/screens/add_delivery_screen.dart';
import 'package:travel_app/presentation/screens/add_ride_screen.dart';
import 'package:travel_app/presentation/screens/client_ride_details_screen.dart';
import 'package:travel_app/presentation/screens/delivery_details_screen.dart';
import 'package:travel_app/presentation/screens/login_screen.dart';
import 'package:travel_app/presentation/screens/my_rides_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/presentation/screens/register_screen.dart';
import 'package:travel_app/presentation/screens/reserve_delivery_screen.dart';
import 'package:travel_app/presentation/screens/reserve_ride_screen.dart';
import 'package:travel_app/presentation/screens/ride_details_screen.dart';
import 'package:travel_app/utils/string_constants.dart';

import 'data/enums/user_role.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/widgets/custom_app_bar.dart';
import 'utils/image_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => UserBloc()),
    BlocProvider(create: (context) => HomeScreenBloc()),
    BlocProvider(create: (context) => MapBloc()),
    BlocProvider(create: (context) => AuthBloc()..add(CheckAuthState())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const MyHomePage(),
        "/rideDetails": (context) => RideDetailsScreen(),
        "/clientRideDetails": (context) => ClientRideDetailsScreen(),
        "/deliveryDetails": (context) => DeliveryDetailsScreen(),
        "/reserveRide": (context) => ReserveRideScreen(),
        "/reserveDelivery": (context) => ReserveDeliveryScreen(),
        "/addRide": (context) {
          context.read<UserBloc>().add(GetAllDrivers(forceRefresh: true));
          return AddRideScreen();
        },
        "/addDelivery": (context) => AddDeliveryScreen(),
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen()
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
            _dispatchEvent(index);
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

  void _dispatchEvent(int index) {
    if (index == 1) {
      var state = context.read<AuthBloc>().state;
      if (state is UserIsLoggedIn) {
        switch (state.user.role) {
          case UserRole.DRIVER:
            context.read<UserBloc>().add(LoadDriverTripsDeliveries());
            break;
          case UserRole.ADMIN:
            context.read<UserBloc>().add(LoadDriversInvitations());
            break;
          case UserRole.CLIENT:
            context.read<UserBloc>().add(LoadClientTripsDeliveries());
            break;
        }
      }
    } else if (index == 0) {
      context.read<MapBloc>().add(ClearMapEvent());
    }
  }
}

Widget _transportIconWidget() {
  return SvgPicture.asset(
    transportIcon,
    colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
  );
}
