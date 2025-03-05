import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: Text("Delivery screen details"),
    );
  }
}