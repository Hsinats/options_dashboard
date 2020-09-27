import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stanish Finacial'),
      ),
      body: Row(
        children: [
          Expanded(child: Container()),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _MenuItem(
                'The Dashboard',
                description:
                    'An easy to use dashboard for reaserching options trades',
                image: 'dashboard.jpg',
                route: 'dashboard',
                height: screenHeight / 3.7,
                width: screenWidth * .95,
              ),
              _MenuItem(
                'The Playbook',
                description:
                    'Find trades to suit your outlooks and risk profile',
                image: 'playbook.jpg',
                route: 'playbook',
                height: screenHeight / 3.7,
                width: screenWidth * .95,
              ),
              _MenuItem(
                'FAQ',
                image: 'faq.jpg',
                route: 'faq',
                height: screenHeight / 3.7,
                width: screenWidth * .95,
              ),
            ],
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  _MenuItem(
    this.text, {
    @required this.image,
    this.description,
    this.route,
    this.height,
    this.width,
  });

  final String text;
  final String description;
  final String route;
  final String image;
  final double height;
  final double width;
  // final String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/$route');
      },
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black45,
              offset: const Offset(3, 3),
              blurRadius: 15.0,
              spreadRadius: 2.0)
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: height,
                width: width,
                child: Image.asset(
                  'assets/images/$image',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    description != null
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              description,
                              textAlign: TextAlign.right,
                              maxLines: 5,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                decoration:
                    BoxDecoration(color: Colors.indigo.withOpacity(0.8)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
