import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo_notification/intro_pages/page_one.dart';
import 'package:todo_notification/intro_pages/page_two.dart';
import 'package:todo_notification/pages/home_screen.dart';

// ignore: must_be_immutable
class IntroScreen extends StatefulWidget {
  IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController _controller = PageController();

  bool onLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                onLast = (value == 1);
              });
            },
            children: [PageOne(), PageTwo()],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                    );
                  },
                  child:
                      // Text(onLast ? "previous" : "previous")
                      onLast ? Icon(Icons.arrow_back) : Icon(Icons.remove),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 2,
                  effect: WormEffect(activeDotColor: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    if (onLast) {
                      print("To home");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    }
                  },
                  child: onLast ? Icon(Icons.done) : Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
