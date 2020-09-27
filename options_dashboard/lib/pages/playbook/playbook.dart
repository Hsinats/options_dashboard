import 'package:flutter/material.dart';
import 'package:options_dashboard/pages/playbook/playbook_state.dart';
import 'package:options_dashboard/pages/playbook/widgets/info_bar.dart';
import 'package:provider/provider.dart';

class Playbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playbookState = Provider.of<PlaybookState>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Playbook'),
      ),
      body: SizedBox.expand(
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
            if (dragEndDetails.primaryVelocity < -300) {
              playbookState.increaseIndex();
            } else if (dragEndDetails.primaryVelocity > 300) {
              playbookState.decreaseIndex();
            }
          },
          child: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                playbookState.playbookSection()[playbookState.index],
                Expanded(child: Container()),
                InfoBar(
                  playbookState: playbookState,
                )
              ],
            ),
          ),
        ),
      ),
      // drawer: Drawer(
      //   child: DrawerItems(),
      // ),
    );
  }
}

class LongStrangle extends StatelessWidget {
  final double _width;
  final double _height;
  LongStrangle(this._width, this._height);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Long straddle',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'Volatile strategy',
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.fade,
          ),
          Divider(
            height: 2,
            color: Colors.indigo,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'How to',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('buy an OTM call,'),
                          Text('buy an OTM put')
                        ],
                      )),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Max risk',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft, child: Text('limited')),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Max reward',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('unlimited')),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Effect of volatility',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('helps position')),
                ],
              ),
              TableRow(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Effect of time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('hurts position')),
                ],
              ),
            ],
          ),
          Divider(
            height: 2,
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }
}
