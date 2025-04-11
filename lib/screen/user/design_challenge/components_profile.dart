// Shared Base Class
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class UIComponent {
  String type;
  String text;
  Color color;
  double fontSize;
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
}

// ------------------ Profile Picture ------------------
class ProfilePicture extends UIComponent {
  ProfilePicture()
      : super(
          type: 'ProfilePicture',
          text: '',
          color: Colors.orange,
          x: 150,
          y: 120,
          width: 120,
          height: 120,
        );

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 2, // Spread radius
        blurRadius: 5, // Blur radius
        offset: const Offset(4, 4), // Offset in x and y directions
      ),
    ],
  ),
  child: CircleAvatar(
    radius: width / 2,
    backgroundColor: Colors.white,
    backgroundImage: const AssetImage("assets/Animation/profile.png"),
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
      child: 
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: fontSize*2),
            const SizedBox(width: 16),
           
     Flexible(
           child:Column(
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
      
     )),
      ]));
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
          color: const Color(0xFFED5546),
          x: 40,
          y: 250,
          width: 320,
          height: 70,
          isEditable:true
        );

  @override
  Widget buildWidget(BuildContext context) {
    return buildLabeledCard(
      icon: Icons.person,
      label: 'Name',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize,
      color: Colors.white,
    );
  }
}

// ------------------ Bio ------------------
class Bio extends UIComponent {
  Bio()
      : super(
          type: 'Bio',
          text: 'A passionate developer',
          fontSize: 10,
          color: const Color(0xFF0033A0),
          x: 120,
          y: 330,
          width: 320,
          height: 80,
               isEditable:true
        );

  @override
  Widget buildWidget(BuildContext context) {
    return buildLabeledCard(
      icon: Icons.info,
      label: 'Bio',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize,
      color: Colors.white,
    );
  }
}

// ------------------ Contact Info ------------------
class ContactInfo extends UIComponent {
  ContactInfo()
      : super(
          type: 'ContactInfo',
          text: 'john@gmail.com',
          fontSize: 25,
          color: const Color.fromARGB(255, 242, 240, 240),
          x: 40,
          y: 450,
          width: 320,
          height: 70,
               isEditable:true
        );

  @override
  Widget buildWidget(BuildContext context) {
    return buildLabeledCard(
      icon: Icons.email,
      label: 'Email',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize,
      color: Colors.white,
    );
  }
}

// ------------------ Address ------------------
class Address extends UIComponent {
  Address()
      : super(
          type: 'Address',
          text: '123 Main St',
          fontSize: 20,
          color: Colors.white,
          x: 40,
          y: 440,
          width: 320,
          height: 70,
               isEditable:true
        );

  @override
  Widget buildWidget(BuildContext context) {
    return buildLabeledCard(
      icon: Icons.location_on,
      label: 'Address',
      value: text,
      background: color,
      shadow: getDarkerColor(color),
      fontSize: fontSize,
      color: Colors.white,
    );
  }
}

// ------------------ Edit Profile ------------------
class EditProfile extends UIComponent {
  EditProfile()
      : super(
          type: 'Button',
          text: 'Edit Profile',
          fontSize: 18,
          color: Colors.white,
          x: 100,
          y: 50,
          width: 200,
          height: 60,
               isEditable:true
        );

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      width: width,
      height: height + (fontSize - 18),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.red.shade700, offset: const Offset(4, 4))
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.fredoka(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
