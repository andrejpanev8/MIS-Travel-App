import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class ReserveDeliveryScreen extends StatefulWidget {
  const ReserveDeliveryScreen({super.key});

  @override
  State<ReserveDeliveryScreen> createState() => _ReserveDeliveryScreenState();
}

class _ReserveDeliveryScreenState extends State<ReserveDeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: Text("reserve delivery screen"),
    );
  }
}