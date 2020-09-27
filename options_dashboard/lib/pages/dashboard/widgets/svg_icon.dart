import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String iconName;
  final String tooltipProperty;
  final bool filled;
  final double size;
  final Function onTap;
  final String tooltipMessage;

  SvgIcon(
    this.iconName, {
    this.filled = false,
    this.size = 32,
    this.onTap,
    this.tooltipProperty,
    this.tooltipMessage,
  });
  @override
  Widget build(BuildContext context) {
    String tooltipShows;
    if (tooltipMessage == null) {
      if (filled) {
        tooltipShows = 'Hide $tooltipProperty';
      } else {
        tooltipShows = 'Show $tooltipProperty';
      }
    } else {
      tooltipShows = tooltipMessage;
    }
    return Tooltip(
      message: tooltipShows,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: SvgPicture.asset(
            'assets/icons/$iconName.svg',
            color: filled ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class SvgIconSimple extends StatelessWidget {
  final String iconName;
  final double size;

  SvgIconSimple(
    this.iconName, {
    this.size = 32,
  });
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
    );
  }
}
