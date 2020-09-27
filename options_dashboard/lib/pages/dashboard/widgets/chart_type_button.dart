import 'package:flutter/material.dart';
import 'package:options_dashboard/pages/dashboard/dashboard_state.dart';

class GraphTypeButton extends StatelessWidget {
  final GraphType thisGraphType;
  final String type;
  final DashboardState dashboardState;

  GraphTypeButton({
    @required this.type,
    @required this.thisGraphType,
    @required this.dashboardState,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          dashboardState.setGraphType(thisGraphType);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: dashboardState.graphType == thisGraphType
                ? Colors.indigo
                : null,
          ),
          padding: EdgeInsets.all(6),
          child: Text(
            type,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: dashboardState.graphType == thisGraphType
                    ? Colors.white
                    : Colors.black),
          ),
        ));
  }
}
