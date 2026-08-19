import 'package:flutter/material.dart';

class Uitools {
  const Uitools();

  Widget imgBtnTitleContainer(
    String title,
    String imgDir,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          btn1(imgDir, onPressed),
        ],
      ),
    );
  }

  Widget imgBtnTitleContainer2(
    String title,
    String imgDir,
    VoidCallback onPressed, {
    double? width,
  }) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          btn2(imgDir, onPressed),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget imgBtnTitleContainer3(
    String title,
    String imgDir,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 230,
      height: 230,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          btn3(imgDir, onPressed),
        ],
      ),
    );
  }

  OutlinedButton btn1(String imgDir, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.teal[100],
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Image.asset(imgDir, width: 80, height: 80),
    );
  }

  OutlinedButton btn2(String imgDir, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        side: BorderSide(color: Colors.black, width: 1),
        shape: const CircleBorder(),

        padding: EdgeInsets.zero,
        minimumSize: const Size(55, 55),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset(imgDir, width: 30, height: 30),
    );
  }

  OutlinedButton btn3(String imgDir, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.teal[100],
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Image.asset(imgDir, width: 120, height: 120),
    );
  }

  OutlinedButton itemRemoveBtn(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.red[100],
        shape: const CircleBorder(),

        padding: EdgeInsets.zero,
        minimumSize: const Size(35, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset("images/trash.png", width: 20, height: 20),
    );
  }

  OutlinedButton itemEditBtn(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.green[100],
        shape: const CircleBorder(),

        padding: EdgeInsets.zero,
        minimumSize: const Size(35, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset("images/pencil.png", width: 20, height: 20),
    );
  }

  PageRoute smoothPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.05, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },

      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget infoButton({required bool showInfo, required VoidCallback onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.lightBlue),
        side: BorderSide(color: Colors.lightBlue, width: 1),
      ),
      onPressed: onPressed,
      child: Text(showInfo ? "Hide Info" : "Info"),
    );
  }

  Widget infoContainer({required bool showInfo, required String infoText}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),

      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },

      child: showInfo
          ? Container(
              key: const ValueKey("infoContainer"),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Text(
                infoText,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            )
          : const SizedBox(key: ValueKey("emptyInfoContainer")),
    );
  }
}
