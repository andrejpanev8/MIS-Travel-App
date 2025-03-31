// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/image_constants.dart';

class PopupFAB extends StatefulWidget {
  VoidCallback? onTapAddRide;
  VoidCallback? onTapAddDelivery;
  PopupFAB(
      {super.key, required this.onTapAddRide, required this.onTapAddDelivery});

  @override
  State<PopupFAB> createState() => _PopupFABState();
}

class _PopupFABState extends State<PopupFAB>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _translateButton = Tween<double>(
      begin: 0.0,
      end: -20.0, // Adjusted for total height of popup
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _buildBackground(),
        _buildAnimatedButton(
          svgAsset: addRideIcon,
          heroTag: "addRide",
          positionFactor: 5,
          onTap: widget.onTapAddRide ?? () {},
        ),
        _buildAnimatedButton(
          svgAsset: addDeliveryIcon,
          heroTag: "addDelivery",
          positionFactor: 2.5,
          onTap: widget.onTapAddDelivery ?? () {},
        ),
        FloatingActionButton(
          onPressed: animate,
          backgroundColor: blueDeepColor,
          shape: const CircleBorder(),
          elevation: 0.0,
          child: const Icon(
            Icons.add,
            color: whiteColor,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedButton(
      {required String svgAsset,
      required VoidCallback onTap,
      required double positionFactor,
      required String heroTag}) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        _translateButton.value * positionFactor,
        0.0,
      ),
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: transparentColor,
        heroTag: heroTag,
        shape: const CircleBorder(),
        elevation: 0.0,
        child: SvgPicture.asset(
          svgAsset,
          colorFilter: const ColorFilter.mode(silverColor, BlendMode.srcIn),
          width: 25,
          height: 25,
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        _translateButton.value,
        0.0,
      ),
      child: Visibility(
        visible: isOpened,
        child: Container(
          height: 140,
          width: 55,
          decoration: BoxDecoration(
            color: silverColorLight,
            borderRadius: const BorderRadius.all(
              Radius.circular(24.0),
            ),
          ),
        ),
      ),
    );
  }
}
