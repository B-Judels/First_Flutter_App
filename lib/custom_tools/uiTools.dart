import 'package:flutter/material.dart';

class Uitools {
  const Uitools();

  // ─────────────────────────────────────────────────────────────────────────
  // App colour palette
  // Calm, high-contrast neutrals with a single teal accent.
  // ─────────────────────────────────────────────────────────────────────────
  Color pageBackgroundColor() => const Color(0xFFF4F7F9);
  Color appBarColor() => const Color(0xFF1F3545);
  Color appBarIconColor() => Colors.white;
  Color sectionHeaderColor() => const Color(0xFFDCEBEA);
  Color titleColor() => Colors.white;
  Color cardColor() => Colors.white;
  Color borderColor() => const Color(0xFFD5DEE5);
  Color textColor() => const Color(0xFF263746);
  Color mutedTextColor() => const Color(0xFF61717D);
  Color accentColor() => const Color(0xFF2F6F6D);
  Color accentLightColor() => const Color(0xFFE7F2F1);

  // Category colours are intentionally soft so they remain pleasant beside
  // the main teal palette.
  Color debitOrderColor() => const Color(0xFFD96B5F);
  Color serviceColor() => const Color(0xFF5C8FB3);
  Color medicalInsuranceColor() => const Color(0xFF5E9B78);
  Color dailyHabitColor() => const Color(0xFF8970AD);

  Color tableRowColor() => const Color(0xFFF0F6F5);

  // Existing page APIs kept for compatibility with the current pages.
  Color pageBackgroundColor1() => pageBackgroundColor();
  Color appBarColor1() => appBarColor();
  Color sectionHeaderColor1() => sectionHeaderColor();
  Color titleColor1() => titleColor();
  Color cardColor1() => cardColor();
  Color borderColor1() => Colors.black;
  Color textColor1() => textColor();
  Color debitOrderColor1() => debitOrderColor();
  Color serviceColor1() => serviceColor();
  Color medicalInsuranceColor1() => medicalInsuranceColor();
  Color dailyHabitColor1() => dailyHabitColor();
  Color tableRowColor1() => tableRowColor();

  // ─────────────────────────────────────────────────────────────────────────
  // Consistent typography
  // ─────────────────────────────────────────────────────────────────────────
  TextStyle appBarTitleStyle() => const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  TextStyle pageIntroStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textColor(),
  );

  TextStyle sectionTitleStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: textColor(),
  );

  TextStyle summaryTextStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: textColor(),
  );

  TextStyle bodyTextStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textColor(),
  );

  TextStyle tableTextStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textColor(),
  );

  TextStyle tableHeaderStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  TextStyle tileTitleStyle() => TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: textColor(),
  );

  InputDecoration inputDecoration({
    required String labelText,
    required String hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: mutedTextColor(),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 13,
        color: mutedTextColor(),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor(), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentColor(), width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor(), width: 1),
      ),
    );
  }

  ButtonStyle primaryButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: accentColor(),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
      side: BorderSide(color: accentColor(), width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Image / navigation tiles
  // ─────────────────────────────────────────────────────────────────────────
  Widget imgBtnTitleContainer(
    String title,
    String imgDir,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor(), width: 1),
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: tileTitleStyle()),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor(), width: 1),
      ),
      child: Column(
        children: [
          btn2(imgDir, onPressed),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: tileTitleStyle()),
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
        color: cardColor(),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor(), width: 1),
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: tileTitleStyle()),
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
        foregroundColor: textColor(),
        backgroundColor: accentLightColor(),
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: borderColor(), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Image.asset(imgDir, width: 80, height: 80),
    );
  }

  OutlinedButton btn2(String imgDir, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor(),
        backgroundColor: accentLightColor(),
        side: BorderSide(color: borderColor(), width: 1),
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
        foregroundColor: textColor(),
        backgroundColor: accentLightColor(),
        padding: const EdgeInsets.all(12),
        side: BorderSide(color: borderColor(), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Image.asset(imgDir, width: 120, height: 120),
    );
  }

  OutlinedButton itemRemoveBtn(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor(),
        backgroundColor: debitOrderColor(),
        side: BorderSide(color: borderColor(), width: .75),
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: const Size(35, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset("images/trash.png", width: 20, height: 20),
    );
  }

  OutlinedButton burgerMenuBtn(VoidCallback onPressed, bool isOpen) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor(),
        backgroundColor: Colors.white,
        side: BorderSide(color: appBarColor(), width: 1),
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: const Size(45, 45),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AnimatedRotation(
        turns: isOpen ? 0.25 : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Image.asset("images/menu-burger.png", width: 30, height: 30),
      ),
    );
  }

  OutlinedButton itemEditBtn(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor(),
        backgroundColor: medicalInsuranceColor(),
        side: BorderSide(color: borderColor(), width: .75),
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
        foregroundColor: accentColor(),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: accentColor(), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accentLightColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor(), width: 1),
              ),
              child: Text(infoText, style: bodyTextStyle()),
            )
          : const SizedBox(key: ValueKey("emptyInfoContainer")),
    );
  }
}
