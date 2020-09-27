import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    @required this.text,
    this.heading = false,
    this.subheading = false,
    this.index,
    this.specialRoute,
    this.leading,
  });
  final String text;
  final bool heading;
  final bool subheading;
  final int index;
  final String specialRoute;
  final Widget leading;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        if (specialRoute != null) {
          pushRoute(context, specialRoute, index);
        } else {
          pushRoute(context, '/playbook', index);
        }
      },
      title: Row(
        children: [
          leading ?? Container(),
          leading != null
              ? Container(
                  width: 4,
                )
              : Container(),
          Text(text,
              style: heading
                  ? TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  : subheading
                      ? TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      : null),
        ],
      ),
    );
  }
}

void pushRoute(
  BuildContext context,
  String route,
  int playpookIndex,
) {
  Navigator.of(context).pushNamed(route, arguments: playpookIndex);
}
