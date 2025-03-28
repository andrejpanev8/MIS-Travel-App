import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/presentation/widgets/empty_list_indicator.dart';
import 'package:travel_app/presentation/widgets/rides_widget.dart';
import 'package:travel_app/utils/functions.dart';
import 'package:travel_app/utils/string_constants.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/DTO/TaskTripDTO.dart';
import '../../data/enums/screen_type.dart';
import '../../data/models/trip.dart';
import '../widgets/date_time_picker_widget.dart';
import '../widgets/expanded_wrapper_widget.dart';
import '../widgets/floating_action_menu.dart';
import '../widgets/home_screen_top_nav.dart';
import '../widgets/input_field.dart';
import '../widgets/widget_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskTripDTO> deliveries = [];
  List<Trip> rides = [];

  TextEditingController fromWhereController = TextEditingController();
  TextEditingController toWhereController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  FocusNode fromWhereFocusNode = FocusNode();
  FocusNode toWhereFocusNode = FocusNode();
  FocusNode dateTimeFocusNode = FocusNode();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });

    fromWhereController
        .addListener(() => _onInputChanged(context.read<UserBloc>().state));
    toWhereController
        .addListener(() => _onInputChanged(context.read<UserBloc>().state));
    dateTimeController
        .addListener(() => _onInputChanged(context.read<UserBloc>().state));

    fromWhereFocusNode.addListener(() => _onFocusLost(FromWhereString));
    toWhereFocusNode.addListener(() => _onFocusLost(ToWhereString));
    dateTimeFocusNode.addListener(() => _onFocusLost(DateTimeString));
  }

  void _onInputChanged(UserState userState) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      final fromWhere = fromWhereController.text.trim();
      final toWhere = toWhereController.text.trim();
      final dateTime = dateTimeController.text.trim().isNotEmpty
          ? DateTime.tryParse(dateTimeController.text)
          : null;

      if (fromWhere.isEmpty && toWhere.isEmpty && dateTime == null) {
        context.read<UserBloc>().add(GetUpcomingRides());
      } else {
        Functions.emitUserEvent(
          context: context,
          event: FilterEvent(fromWhere, toWhere, dateTime, userState),
        );
      }
    });
  }

  void _onFocusLost(String field) {
    if (!getFocusNode(field).hasFocus) {
      _onInputChanged(context.read<UserBloc>().state);
    }
  }

  FocusNode getFocusNode(String field) {
    switch (field) {
      case FromWhereString:
        return fromWhereFocusNode;
      case ToWhereString:
        return toWhereFocusNode;
      case DateTimeString:
        return dateTimeFocusNode;
      default:
        return FocusNode();
    }
  }

  @override
  void dispose() {
    super.dispose();
    fromWhereController.dispose();
    toWhereController.dispose();
    dateTimeController.dispose();
    fromWhereFocusNode.dispose();
    toWhereFocusNode.dispose();
    dateTimeFocusNode.dispose();

    _debounce?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Functions.emitUserEvent(context: context, event: GetUpcomingRides());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (fromWhereController.text.isNotEmpty ||
          toWhereController.text.isNotEmpty ||
          dateTimeController.text.isNotEmpty) {
        _onInputChanged(context.read<UserBloc>().state);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _ridesDeliveriesToggle(),
              _buildSearchSection(context, null),
              _buildBodySection(),
            ],
          ),
        ),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  Widget _buildBodySection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UpcomingDeliveriesLoaded) {
              deliveries = state.deliveries;
            }
            if (state is UpcomingRidesLoaded) {
              rides = state.trips;
            }
            return _buildBody(userState: state);
          },
        ),
      ),
    );
  }

  Widget _buildBody({var userState}) {
    var state = context.watch<HomeScreenBloc>().state;
    bool isRidesActive = state is RidesActive;

    return widgetBuilder(
      context: context,
      items: rides,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, rides) => RidesWidget(
        context: context,
        ride: rides,
        screenType: isRidesActive
            ? ScreenType.HOME_RIDES_SCREEN
            : ScreenType.HOME_DELIVERIES_SCREEN,
      ),
      onRefresh: () => Functions.emitUserEvent(
        context: context,
        event: GetUpcomingRides(forceRefresh: true),
      ),
      emptyWidget: emptyListIndicator(
        isRidesActive
            ? AppStrings.noUpcomingRides
            : AppStrings.noUpcomingDeliveries,
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, bool? showRides) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 4),
                  child: Form(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        expandedWidget(inputTextFieldCustom(
                          context: context,
                          controller: fromWhereController,
                          focusNode: fromWhereFocusNode,
                          prefixIcon: Icon(Icons.location_on_outlined),
                          hintText: AppStrings.fromWhere,
                        )),
                        SizedBox(width: 10),
                        expandedWidget(inputTextFieldCustom(
                          context: context,
                          controller: toWhereController,
                          focusNode: toWhereFocusNode,
                          prefixIcon: Icon(Icons.location_on_outlined),
                          hintText: AppStrings.toWhere,
                        )),
                        SizedBox(width: 10),
                        expandedWidget(
                          dateTimePicker(
                              context: context,
                              controller: dateTimeController,
                              focusNode: dateTimeFocusNode,
                              hintText: AppStrings.when,
                              icon: Icon(Icons.calendar_month_outlined),
                              onDateTimeSelected: (DateTime time) {
                                _debounce?.cancel();
                                _debounce =
                                    Timer(Duration(milliseconds: 500), () {
                                  final userState =
                                      context.read<UserBloc>().state;
                                  _onInputChanged(userState);
                                });
                              }),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is UserIsLoggedIn && state.user.role == UserRole.ADMIN) {
        return PopupFAB(
          onTapAddRide: () {
            Navigator.of(context).pushNamed("/addRide");
          },
          onTapAddDelivery: () {
            Navigator.of(context).pushNamed("/addDelivery");
          },
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _ridesDeliveriesToggle() {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        context.read<UserBloc>().add(GetUpcomingRides());
      },
      child: RidesDeliveriesToggle(),
    );
  }

  void _loadData(BuildContext context) {
    final homeScreenBloc = context.read<HomeScreenBloc>();

    if (homeScreenBloc.state is HomeScreenInitial) {
      context.read<HomeScreenBloc>().add(ToggleActiveScreen());
    }
  }
}
