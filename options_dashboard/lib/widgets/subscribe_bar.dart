import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscribeBar extends StatelessWidget {
  const SubscribeBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(16),
              topEnd: Radius.circular(16),
            )),
        child: SizedBox.expand(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[200],
                ),
                Text(
                  ' Get trade ideas in your inbox every morning!',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[300]),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
