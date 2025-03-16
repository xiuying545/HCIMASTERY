import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ------------------ Base UIComponent Class ------------------
class UIComponent {
  String type;
  String text;
  Color color;
  double fontSize;
  double x;
  double y;
  double width;
  double height;
  bool isSelected;

  UIComponent({
    required this.type,
    this.text = '',
    this.color = Colors.blue,
    this.fontSize = 18,
    this.x = 50,
    this.y = 50,
    this.width = 100,
    this.height = 50,
    this.isSelected = false,
  });
}

// ------------------ Profile Picture Component ------------------
class ProfilePicture extends UIComponent {
  ProfilePicture()
      : super(
          type: 'ProfilePicture',
          text: 'Profile Picture',
          color: Colors.blue.shade900,
          x: 150,
          y: 60,
          width: 60,
          height: 60,
        );

  Widget buildWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: const CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
          "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

// ------------------ Name Component ------------------
class Name extends UIComponent {
  Name()
      : super(
          type: 'Name',
          text: 'John Doe',
          fontSize: 16,
          x: 160,
          y: 150,
          width: 300,
          height: 90,
          color: Colors.blue.shade900,
        );

  Widget buildWidget(BuildContext context) {
    double calculatedWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: calculatedWidth,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: GoogleFonts.poppins(
                    fontSize: fontSize - 2,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Bio Component ------------------
class Bio extends UIComponent {
  Bio()
      : super(
          type: 'Bio',
          text:
              'A passionate developer ',
          fontSize: 14,
          x: 40,
          y: 280,
          width: 300,
          height: 90,
          color: Colors.blue.shade900,
        );

  Widget buildWidget(BuildContext context) {
    double calculatedWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: calculatedWidth,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bio",
                  style: GoogleFonts.poppins(
                    fontSize: fontSize - 2,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Contact Info Component ------------------
class ContactInfo extends UIComponent {
  ContactInfo()
      : super(
          type: 'ContactInfo',
          text: 'john.doe@gmail.com',
          color: Colors.green,
          x: 40,
          y: 380,
          width: 300,
          height: 90,
        );

  Widget buildWidget(BuildContext context) {
    double calculatedWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: calculatedWidth,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.email, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontSize: fontSize - 2,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Address Component ------------------
class Address extends UIComponent {
  Address()
      : super(
          type: 'Address',
          text: 'Address: 123 Main St',
          color: Colors.orange,
          fontSize: 16,
          x: 20,
          y: 450,
          width: 300,
          height: 90,
        );

  Widget buildWidget(BuildContext context) {
    double calculatedWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: calculatedWidth,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Header Component ------------------
class Header extends UIComponent {
  Header()
      : super(
          type: 'Header',
          text: 'Welcome to My Profile',
          color: Colors.blue.shade900,
          x: 0,
          y: 0,
          width: 400,
          height: 100,
        );

  Widget buildWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ------------------ Edit Profile Component ------------------
class EditProfile extends UIComponent {
  EditProfile()
      : super(
          type: 'EditProfile',
          text: 'Edit Profile',
          color: Colors.grey, // Default color (can be overridden)
          x: 150,
          y: 500,
          width: 160,
          fontSize:10,
          height: 60, // Adjusted height for a button
        );

  Widget buildWidget(BuildContext context) {
  return Container(
      width: width, 
      height: height, 
      decoration: BoxDecoration(
        color: color, 
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2), 
            )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Match button padding
      alignment: Alignment.center, // Center the text
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );

}
}


