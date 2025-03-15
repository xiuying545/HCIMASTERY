import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page Design Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue.shade900,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const ProfileDesignChallengePage(),
    );
  }
}

// Base UIComponent class
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

// ------------------ Components ------------------

// Profile Picture Component (unchanged)
class ProfilePicture extends UIComponent {
  ProfilePicture()
      : super(
          type: 'ProfilePicture',
          text: 'Profile Picture',
          color: Colors.blue.shade900,
          x: 20,
          y: 20,
          width: 120,
          height: 120,
        );

  Widget buildWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

// Name Component (intended color: blue.shade900)
class Name extends UIComponent {
  Name()
      : super(
          type: 'Name',
          text: 'John Doe',
          fontSize: 24,
          x: 160,
          y: 40,
          width: 300,
          height: 90,
        );

  Widget buildWidget(BuildContext context) {
    double calculatedWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: calculatedWidth,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
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

// Bio Component (intended color: blue.shade900)
class Bio extends UIComponent {
  Bio()
      : super(
          type: 'Bio',
          text:
              'A passionate developer who loves Flutter and building amazing apps.',
          fontSize: 16,
          x: 20,
          y: 160,
          width: 300,
          height: 90,
        );

  Widget buildWidget(BuildContext context) {
    double calculatedWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: calculatedWidth,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
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


// Contact Info Component (intended color: green)
class ContactInfo extends UIComponent {
  ContactInfo()
      : super(
          type: 'ContactInfo',
          text: 'Email: john.doe@example.com',
          color: Colors.green,
          x: 20,
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
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
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
                  "Contact Info",
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


// New Address Component (intended color: orange)
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
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
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
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.5)], // Dynamic gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 28, // Larger font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Project extends UIComponent {
  final String description;
  final String imageUrl;

  Project({required this.description, required this.imageUrl})
      : super(
          type: 'Project',
          text: 'Project',
          color: Colors.purple,
          x: 20,
          y: 400,
          width: 200,
          height: 120,
        );

  Widget buildWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ------------------ Helper Functions ------------------

// Returns the contrast ratio between two colors
double getContrastRatio(Color a, Color b) {
  double lumA = a.computeLuminance();
  double lumB = b.computeLuminance();
  double brightest = math.max(lumA, lumB);
  double darkest = math.min(lumA, lumB);
  return (brightest + 0.05) / (darkest + 0.05);
}

// Returns whether two colors are "close" in hue (within threshold degrees)
bool isColorClose(Color a, Color b, double threshold) {
  HSVColor hsvA = HSVColor.fromColor(a);
  HSVColor hsvB = HSVColor.fromColor(b);
  double diff = (hsvA.hue - hsvB.hue).abs();
  if (diff > 180) diff = 360 - diff;
  return diff < threshold;
}

// Color picker dialog helper
Future<Color?> showColorPickerDialog(
    BuildContext context, Color initialColor) async {
  Color tempColor = initialColor;
  return await showDialog<Color>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          "Pick a color",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              tempColor = color;
            },
            showLabel: true,
            pickerAreaBorderRadius: BorderRadius.circular(8),
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            displayThumbColor: true,
            enableAlpha: false,
            portraitOnly: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(context).pop(tempColor);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// ------------------ Main Page ------------------

class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() =>
      _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState
    extends State<ProfileDesignChallengePage> {
  final List<UIComponent> components = [];
  String feedbackText = "";
  final double canvasWidth = 400;
  final double canvasHeight = 500;
  int score = 0;
  bool isSnapToGridEnabled = true;
  bool isDarkMode = false;
  int? selectedIndex;
  Color canvasBackgroundColor = Colors.white;

  void _addComponent(String type) {
    setState(() {
      switch (type) {
        case 'ProfilePicture':
          components.add(ProfilePicture());
          break;
        case 'Name':
          components.add(Name());
          break;
        case 'Bio':
          components.add(Bio());
  
        case 'ContactInfo':
          components.add(ContactInfo());
          break;
        case 'Address':
          components.add(Address());
          break;
        case 'Header':
          components.add(Header());
          break;
        case 'Project':
          components.add(Project(
            description: 'Flutter App',
            imageUrl: 'https://via.placeholder.com/80',
          ));
          break;
      }
    });
  }

  // Updated _submitDesign with additional HCI rules and color harmony check
  void _submitDesign() {
    int newScore = 100;
    List<String> strengths = [];
    List<String> improvements = [];

    bool hasProfilePicture =
        components.any((comp) => comp.type == 'ProfilePicture');
    bool hasName = components.any((comp) => comp.type == 'Name');
    bool hasBio = components.any((comp) => comp.type == 'Bio');

    bool hasSocialMedia = components.any((comp) => comp.type == 'SocialMedia');
    bool hasContactInfo = components.any((comp) => comp.type == 'ContactInfo');

    // Core HCI Checks
    if (hasProfilePicture) {
      strengths.add("includes a profile picture");
    } else {
      improvements.add("add a profile picture");
      newScore -= 10;
    }
    if (hasName) {
      strengths.add("includes a name field");
      // Check color harmony for Name (should be close to blue.shade900)
      UIComponent name = components.firstWhere((comp) => comp.type == 'Name');
      if (!isColorClose(name.color, Colors.blue.shade900, 20)) {
        improvements.add("adjust Name color to match the blue theme");
        newScore -= 5;
      }
    } else {
      improvements.add("add a name field");
      newScore -= 10;
    }
    if (hasBio) {
      strengths.add("includes a bio");
      UIComponent bio = components.firstWhere((comp) => comp.type == 'Bio');
      if (!isColorClose(bio.color, Colors.blue.shade900, 20)) {
        improvements.add("adjust Bio color to match the blue theme");
        newScore -= 5;
      }
    } else {
      improvements.add("add a bio");
      newScore -= 10;
    }
    
    if (hasContactInfo) {
      UIComponent contactInfo =
          components.firstWhere((comp) => comp.type == 'ContactInfo');
      if (contactInfo.x == 20) {
        strengths.add("has consistent contact info alignment");
      } else {
        improvements.add("align contact info component to x=20");
        newScore -= 5;
      }
      if (contactInfo.color != Colors.green) {
        improvements.add("use the designated green color for contact info");
        newScore -= 5;
      }
    } else {
      improvements.add("add a contact info section");
      newScore -= 10;
    }

    // New HCI Rule: Check for overlapping components
    bool hasOverlap = false;
    for (int i = 0; i < components.length; i++) {
      for (int j = i + 1; j < components.length; j++) {
        if (_checkOverlap(components[i], components[j])) {
          hasOverlap = true;
          break;
        }
      }
      if (hasOverlap) break;
    }
    if (hasOverlap) {
      improvements.add("avoid overlapping components");
      newScore -= 10;
    } else {
      strengths.add("components are well spaced");
    }

    // New HCI Rule: Check font size consistency
    bool isFontSizeConsistent = true;
    for (var comp in components) {
      if (comp.type == 'Name' || comp.type == 'Bio') {
        if (comp.fontSize < 14 || comp.fontSize > 24) {
          isFontSizeConsistent = false;
          break;
        }
      }
    }
    if (isFontSizeConsistent) {
      strengths.add("font sizes are consistent");
    } else {
      improvements.add("ensure consistent font sizes");
      newScore -= 10;
    }

    // New HCI Rule: Check overall color harmony for text-based components
    // (For Name, Bio, SubmitButton, we expect a blue hue; for SocialMedia, purple; for ContactInfo, green)
    for (var comp in components) {
      if (comp.type == 'Name' ||
          comp.type == 'Bio' ||
          comp.type == 'SubmitButton') {
        if (!isColorClose(comp.color, Colors.blue.shade900, 20)) {
          improvements.add(
              "adjust ${comp.type} color for better harmony with blue theme");
          newScore -= 5;
        }
      }
    }

    // New HCI Rule: Check component alignment (x positions should be multiples of 20)
    bool isAligned = true;
    for (var comp in components) {
      if (comp.x % 20 != 0) {
        isAligned = false;
        break;
      }
    }
    if (isAligned) {
      strengths.add("components are properly aligned");
    } else {
      improvements.add("align components properly (multiples of 20)");
      newScore -= 10;
    }

    // New HCI Rule: Check responsiveness
    bool isResponsive = true;
    for (var comp in components) {
      if (comp.x + comp.width > canvasWidth ||
          comp.y + comp.height > canvasHeight) {
        isResponsive = false;
        break;
      }
    }
    if (isResponsive) {
      strengths.add("design is responsive");
    } else {
      improvements.add("ensure design fits within the screen");
      newScore -= 10;
    }

    // Build feedback text
    String feedback = "";
    if (strengths.isNotEmpty) {
      feedback += "Strengths: ${strengths.join(", ")}.\n";
    }
    if (improvements.isNotEmpty) {
      feedback += "Improvements: ${improvements.join(", ")}.\n";
    }
    feedback += "Your current score is ${newScore.clamp(0, 100)}/100.";

    setState(() {
      feedbackText = feedback;
      score = newScore.clamp(0, 100);
    });
  }

  // Helper function to check if two components overlap
  bool _checkOverlap(UIComponent a, UIComponent b) {
    return a.x < b.x + b.width &&
        a.x + a.width > b.x &&
        a.y < b.y + b.height &&
        a.y + a.height > b.y;
  }

  // Edit component dialog with Delete button
  void _editComponent(int index) {
    UIComponent comp = components[index];
    TextEditingController fontSizeController =
        TextEditingController(text: comp.fontSize.toString());
    Color currentColor = comp.color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            '${comp.type} Component',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fontSizeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Font Size',
                    labelStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue.shade900),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Choose Color",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    Color? chosenColor =
                        await showColorPickerDialog(context, currentColor);
                    if (chosenColor != null) {
                      setState(() {
                        currentColor = chosenColor;
                      });
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentColor,
                      border: Border.all(color: Colors.blue.shade900, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.color_lens,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Delete button
            TextButton(
              onPressed: () {
                setState(() {
                  components.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                setState(() {
                  comp.fontSize =
                      double.tryParse(fontSizeController.text) ?? comp.fontSize;
                  comp.color = currentColor;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableComponent(UIComponent comp, int index) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: comp.x.clamp(0, canvasWidth - comp.width),
      top: comp.y.clamp(0, canvasHeight - comp.height),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            comp.x =
                (comp.x + details.delta.dx).clamp(0, canvasWidth - comp.width);
            comp.y = (comp.y + details.delta.dy)
                .clamp(0, canvasHeight - comp.height);
            if (isSnapToGridEnabled) {
              comp.x = (comp.x / 20).round() * 20.0;
              comp.y = (comp.y / 20).round() * 20.0;
            }
          });
        },
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _editComponent(index);
        },
        child: Transform.scale(
          scale: selectedIndex == index ? 1.05 : 1.0,
          child: _buildComponentWidget(comp),
        ),
      ),
    );
  }

  Widget _buildComponentWidget(UIComponent comp) {
    switch (comp.type) {
      case 'ProfilePicture':
        return (comp as ProfilePicture).buildWidget(context);
      case 'Name':
        return (comp as Name).buildWidget(context);
      case 'Bio':
        return (comp as Bio).buildWidget(context);
      case 'ContactInfo':
        return (comp as ContactInfo).buildWidget(context);
      case 'Address':
        return (comp as Address).buildWidget(context);
      case 'Header':
        return (comp as Header).buildWidget(context);
      case 'Project':
        return (comp as Project).buildWidget(context);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page Design Challenge'),
        actions: [
          IconButton(
            tooltip: 'Toggle Snap-to-Grid',
            icon: Icon(isSnapToGridEnabled ? Icons.grid_on : Icons.grid_off),
            onPressed: () {
              setState(() {
                isSnapToGridEnabled = !isSnapToGridEnabled;
              });
            },
          ),
          IconButton(
            tooltip: 'Change Background Color',
            icon: const Icon(Icons.format_paint),
            onPressed: () async {
              Color? newColor =
                  await showColorPickerDialog(context, canvasBackgroundColor);
              if (newColor != null) {
                setState(() {
                  canvasBackgroundColor = newColor;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: canvasWidth,
                height: canvasHeight,
                decoration: BoxDecoration(
                  color: canvasBackgroundColor,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  children: [
                    for (int i = 0; i < components.length; i++)
                      _buildDraggableComponent(components[i], i),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Feedback panel at bottom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedbackText.isNotEmpty
                    ? feedbackText
                    : "Press 'Submit Design' to see feedback",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDesign,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Submit Design',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add Component",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildAddComponentButton(Icons.account_circle,
                            'Profile Picture', 'ProfilePicture'),
                        _buildAddComponentButton(Icons.person, 'Name', 'Name'),
                        _buildAddComponentButton(Icons.info, 'Bio', 'Bio'),
                        _buildAddComponentButton(
                            Icons.title, 'Header', 'Header'),
                        _buildAddComponentButton(
                            Icons.phone, 'Contact Info', 'ContactInfo'),
                        _buildAddComponentButton(
                            Icons.location_on, 'Address', 'Address'),
                        _buildAddComponentButton(
                            Icons.work, 'Project', 'Project'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddComponentButton(IconData icon, String label, String type) {
    return ElevatedButton(
      onPressed: () {
        _addComponent(type);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        side: BorderSide(
          color: Colors.blue.shade700,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
