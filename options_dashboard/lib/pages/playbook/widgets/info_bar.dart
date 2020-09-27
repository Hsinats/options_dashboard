import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:options_dashboard/services/optimize_trade.dart';

import '../playbook_state.dart';

class InfoBar extends StatelessWidget {
  const InfoBar({
    @required this.playbookState,
    Key key,
  }) : super(key: key);

  final PlaybookState playbookState;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(16),
            topEnd: Radius.circular(16),
          )),
      child: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                color:
                    playbookState.index == 0 ? Colors.indigo : Colors.grey[100],
                onPressed: () {
                  playbookState.index == 0
                      ? playbookState.doNothing()
                      : playbookState.decreaseIndex();
                }),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/dashboard',
                    arguments: Strategies.values[playbookState.index]);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Make a play on this strategy.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[100]),
                  ),
                  Text('Try it out on The Dashboard now!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[100]))
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.arrow_forward),
                color: playbookState.index >= (playbookState.output.length - 1)
                    ? Colors.indigo
                    : Colors.grey[100],
                onPressed: () {
                  playbookState.index >= (playbookState.output.length - 1)
                      ? playbookState.doNothing()
                      : playbookState.increaseIndex();
                }),
          ],
        ),
      ),
    );
  }
}

class SubBar extends StatelessWidget {
  const SubBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(16),
            topEnd: Radius.circular(16),
          )),
      child: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Make a play on this strategy.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[100]),
                  ),
                  Text('Try it out on The Dashboard now!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[100]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
