import 'package:flutter/material.dart';
import 'package:options_dashboard/pages/dashboard/widgets/custom_list_tile.dart';

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _drawer = [
      Container(
        height: 88,
        child: DrawerHeader(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(200)),
          child: Row(
            children: [
              // SvgPicture.asset(
              //   'assets/icons/insights.svg',
              //   color: Colors.white,
              //   height: 24,
              //   width: 24,
              // ),
              Text(
                'Option Dash',
                // style: GoogleFonts.lobster(
                // textStyle: TextStyle(color: Colors.white, fontSize: 20))
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
      CustomListTile(
        text: 'Home',
        heading: true,
        specialRoute: '/',
      ),
      CustomListTile(
        text: 'Dashboard',
        heading: true,
        specialRoute: '/dashboard',
      ),
      CustomListTile(
        text: 'Playbook',
        heading: true,
        index: 0,
      ),
      CustomListTile(
        text: 'Bullish Strategies',
        subheading: true,
        index: 0,
        leading: Icon(Icons.trending_up),
      ),
      CustomListTile(
        text: 'Bearish Strategies',
        subheading: true,
        index: 6,
        leading: Icon(Icons.trending_down),
      ),
      CustomListTile(
        text: 'Neutral Strategies',
        subheading: true,
        index: 10,
        leading: Icon(Icons.trending_flat),
      ),
      CustomListTile(
        text: 'Volatile Strategies',
        subheading: true,
        index: 14,
        leading: Icon(Icons.flare),
      ),
      CustomListTile(
        text: 'FAQ',
        heading: true,
        specialRoute: '/faq',
      ),
    ];
    return ListView(
      padding: EdgeInsets.zero,
      children: _drawer,
    );
  }
}
