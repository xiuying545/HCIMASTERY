// Shared Base Class
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class UIComponent {
  final GlobalKey _key = GlobalKey(); 
  String type;
  String text;
  Color color;
  int fontSize;
  double x;
  double y;
  double width;
  double height;
  bool isEditable;

  UIComponent({
    required this.type,
    this.text = '',
    this.color = Colors.blue,
    this.fontSize = 18,
    this.x = 50,
    this.y = 50,
    this.width = 100,
    this.height = 50,
    this.isEditable = false,
  });

  Widget buildWidget(BuildContext context);


  Widget wrapWithSizeUpdater(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? box = _key.currentContext?.findRenderObject() as RenderBox?;
          if (box != null) {
            final newHeight = box.size.height;
            final newWidth = box.size.width;
            if ((height - newHeight).abs() > 1 || (width - newWidth).abs() > 1) {
              height = newHeight;
              width = newWidth;
              debugPrint('📏 $type updated → height: $height, width: $width');
            }
          }
        });
        return Container(key: _key, child: child);
      },
    );
  }
}

// ------------------ Profile Picture ------------------
class ProfilePicture extends UIComponent {
  ProfilePicture()
      : super(
          type: 'ProfilePicture',
          text: '',
          color: Colors.orange,
          x: 150,
          y: 50,
          width: 120,
          height: 120,
        );

  @override
  Widget buildWidget(BuildContext context) {
    return wrapWithSizeUpdater(
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: width / 2,
          backgroundColor: Colors.white,
          backgroundImage: const AssetImage("assets/Animation/profile.png"),
        ),
      ),
    );
  }
}

// ------------------ Reusable Label Component ------------------
Widget buildLabeledCard({
  required IconData icon,
  required String label,
  required String value,
  required Color background,
  required Color shadow,
  required double fontSize,
  required Color color,
}) {
  return Container(
    width: 320,
    height: fontSize * 4,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: shadow, offset: const Offset(4, 4))],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: fontSize * 2),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.fredoka(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fredoka(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Color getDarkerColor(Color color, [double amount = .2]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

// ------------------ Name ------------------
class Name extends UIComponent {
  Name()
      : super(
          type: 'Name',
          text: 'John Doe',
          fontSize: 20,
          color: const Color(0xFFF26722),
          x: 40,
          y: 200,
          width: 320,
          isEditable: true,
        );

  @override
  Widget buildWidget(BuildContext context) {
    return wrapWithSizeUpdater(buildLabeledCard(
      icon: Icons.person,
      label: 'Name',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize.toDouble(),
      color: Colors.white,
    ));
  }
}

// ------------------ Bio ------------------
class Bio extends UIComponent {
  Bio()
      : super(
          type: 'Bio',
          text: 'A developer',
          fontSize: 10,
          color: const Color(0xFFFABD42),
          x: 40,
          y: 300,
          width: 320,
          isEditable: true,
        );

  @override
  Widget buildWidget(BuildContext context) {
    return wrapWithSizeUpdater(buildLabeledCard(
      icon: Icons.info,
      label: 'Bio',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize.toDouble(),
      color: Colors.white,
    ));
  }
}

// ------------------ Contact Info ------------------
class ContactInfo extends UIComponent {
  ContactInfo()
      : super(
          type: 'ContactInfo',
          text: 'john@gmail.com',
          fontSize: 25,
          color: const Color(0xffEEEEEE),
          x: 40,
          y: 400,
          width: 320,
          isEditable: true,
        );

  @override
  Widget buildWidget(BuildContext context) {
    return wrapWithSizeUpdater(buildLabeledCard(
      icon: Icons.email,
      label: 'Email',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize.toDouble(),
      color: Colors.white,
    ));
  }
}

// ------------------ Edit Profile ------------------
class EditProfile extends UIComponent {
  EditProfile()
      : super(
          type: 'Button',
          text: 'Edit Profile',
          fontSize: 18,
          color: Color(0xFFF26722),
          x: 100,
          y: 550,
          width: 200,
          isEditable: true,
        );

  @override
  Widget buildWidget(BuildContext context) {
    return wrapWithSizeUpdater(
      Container(
        width: width,
        height: height + (fontSize - 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: getDarkerColor(color), offset: const Offset(4, 4))
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.fredoka(
            fontSize: fontSize.toDouble(),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
