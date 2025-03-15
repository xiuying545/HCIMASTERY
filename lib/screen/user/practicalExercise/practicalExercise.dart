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

// Profile Picture Component
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

  Widget buildWidget() {
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
        radius: 50,
        backgroundColor: color,
        child: const Icon(Icons.person, size: 60, color: Colors.white),
      ),
    );
  }
}

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

  Widget buildWidget() {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
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
        child: Padding(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated Bio Component
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

  Widget buildWidget() {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
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
        child: Padding(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated Social Media Component
class SocialMedia extends UIComponent {
  SocialMedia()
      : super(
          type: 'SocialMedia',
          text: 'Instagram: @flutterdev',
          color: Colors.purple,
          x: 20,
          y: 300,
          width: 300,
          height: 90,
        );

  Widget buildWidget() {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.link, color: color, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Social Media",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated Contact Info Component
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

  Widget buildWidget() {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
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
        child: Padding(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends UIComponent {
  SubmitButton()
      : super(
          type: 'SubmitButton',
          text: 'Submit',
          color: Colors.blue.shade900,
          x: 20,
          y: 400,
          width: 120,
          height: 50,
        );

  Widget buildWidget(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        textStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 5,
      ),
      child: Text(text),
    );
  }
}

class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() =>
      _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState
    extends State<ProfileDesignChallengePage> {
  final List<UIComponent> components = [];
  String feedbackText = "Design your profile page!";
  final double canvasWidth = 400;
  final double canvasHeight = 500;
  int score = 0;
  bool isSnapToGridEnabled = true;
  bool isDarkMode = false;
  int? selectedIndex;

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
          break;
        case 'SubmitButton':
          components.add(SubmitButton());
          break;
        case 'SocialMedia':
          components.add(SocialMedia());
          break;
        case 'ContactInfo':
          components.add(ContactInfo());
          break;
      }
    });
  }

  void _submitDesign() {
    int newScore = 0;
    String feedback = "HCI Design Feedback:\n";
    bool hasProfilePicture =
        components.any((comp) => comp.type == 'ProfilePicture');
    bool hasName = components.any((comp) => comp.type == 'Name');
    bool hasBio = components.any((comp) => comp.type == 'Bio');
    bool hasSubmitButton =
        components.any((comp) => comp.type == 'SubmitButton');
    bool hasSocialMedia = components.any((comp) => comp.type == 'SocialMedia');
    bool hasContactInfo = components.any((comp) => comp.type == 'ContactInfo');

    // HCI Rules for core components
    if (hasProfilePicture) {
      feedback += "✅ Profile picture is present. (+10 points)\n";
      newScore += 10;
    } else {
      feedback += "❌ Please add a profile picture for visual identity.\n";
    }
    if (hasName) {
      feedback += "✅ Name field is present. (+10 points)\n";
      newScore += 10;
    } else {
      feedback += "❌ A name field is needed to personalize the profile.\n";
    }
    if (hasBio) {
      feedback += "✅ Bio field is present. (+10 points)\n";
      newScore += 10;
    } else {
      feedback +=
          "❌ Consider adding a short bio to share more about yourself.\n";
    }
    if (hasSubmitButton) {
      UIComponent submitButton =
          components.firstWhere((comp) => comp.type == 'SubmitButton');
      if (submitButton.y >= canvasHeight - 80) {
        feedback +=
            "✅ Submit button is well positioned at the bottom. (+20 points)\n";
        newScore += 20;
      } else {
        feedback +=
            "❌ The submit button should be placed at the bottom for easier access.\n";
      }
    } else {
      feedback +=
          "❌ Include a submit button so users can save their profile.\n";
    }

    // Additional HCI Rules for Social Media
    if (hasSocialMedia) {
      UIComponent socialMedia =
          components.firstWhere((comp) => comp.type == 'SocialMedia');
      if (socialMedia.x == 20) {
        feedback += "✅ Social media alignment is consistent. (+10 points)\n";
        newScore += 10;
      } else {
        feedback +=
            "❌ Adjust the social media component alignment to start at x=20.\n";
      }
      if (socialMedia.color == Colors.purple) {
        feedback += "✅ Social media color is appropriate. (+5 points)\n";
        newScore += 5;
      } else {
        feedback += "❌ Social media should use the designated purple color.\n";
      }
    } else {
      feedback += "❌ Please add a social media section.\n";
    }

    // Additional HCI Rules for Contact Info
    if (hasContactInfo) {
      UIComponent contactInfo =
          components.firstWhere((comp) => comp.type == 'ContactInfo');
      if (contactInfo.x == 20) {
        feedback += "✅ Contact info alignment is consistent. (+10 points)\n";
        newScore += 10;
      } else {
        feedback +=
            "❌ Adjust the contact info component alignment to start at x=20.\n";
      }
      if (contactInfo.color == Colors.green) {
        feedback += "✅ Contact info color is appropriate. (+5 points)\n";
        newScore += 5;
      } else {
        feedback += "❌ Contact info should use the designated green color.\n";
      }
    } else {
      feedback += "❌ Please add a contact info section.\n";
    }

    setState(() {
      feedbackText = feedback;
      score = newScore.clamp(0, 100);
    });
  }

  void _editComponent(int index) {
    UIComponent comp = components[index];
    TextEditingController fontSizeController =
        TextEditingController(text: comp.fontSize.toString());
    Color currentColor = comp.color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50, // Light blue background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          title: Text(
            '${comp.type} Component',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900, // Dark blue text
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Font Size Input Field
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
                      borderSide: BorderSide(color: Colors.orange, width: 2),
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
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
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
                            pickerColor: currentColor,
                            onColorChanged: (Color color) {
                              setState(() {
                                currentColor = color;
                              });
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange, // Orange button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
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
                backgroundColor: Colors.orange, // Orange button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                setState(() {
                  comp.fontSize =
                      double.tryParse(fontSizeController.text) ?? comp.fontSize;
                  comp.color = currentColor;
                });
                Navigator.of(context).pop();
              },
              child: Text(
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
        return (comp as ProfilePicture).buildWidget();
      case 'Name':
        return (comp as Name).buildWidget();
      case 'Bio':
        return (comp as Bio).buildWidget();
      case 'SubmitButton':
        return (comp as SubmitButton).buildWidget(_submitDesign);
      case 'SocialMedia':
        return (comp as SocialMedia).buildWidget();
      case 'ContactInfo':
        return (comp as ContactInfo).buildWidget();
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.feedback, // Feedback icon
                        color: Colors.blue.shade900,
                        size: 20,
                      ),
                      SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        "Feedback",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12), // Spacing between title and list
                  // Feedback List
                  Text(
                    feedbackText,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'Score: $score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue.shade900),
                  ),
                ],
              ),
            ),
            const Divider(),
            Center(
              child: Container(
                width: canvasWidth,
                height: canvasHeight,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade900 : Colors.white,
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
            const SizedBox(height: 10),
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
            backgroundColor: Colors.white, // Light background for the modal
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), // Rounded top corners
              ),
            ),
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Fit content height
                  children: [
                    // Modal Title
                    Text(
                      "Add Component",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900, // Theme color
                      ),
                    ),
                    SizedBox(height: 16), // Spacing between title and buttons
                    // Grid of Buttons
                    GridView.count(
                      shrinkWrap: true, // Fit content height
                      crossAxisCount: 3, // 3 buttons per row
                      crossAxisSpacing: 10, // Spacing between columns
                      mainAxisSpacing: 10, // Spacing between rows
                      children: [
                        _buildAddComponentButton(
                          Icons.account_circle,
                          'Profile Picture',
                          'ProfilePicture',
                        ),
                        _buildAddComponentButton(
                          Icons.person,
                          'Name',
                          'Name',
                        ),
                        _buildAddComponentButton(
                          Icons.info,
                          'Bio',
                          'Bio',
                        ),
                        _buildAddComponentButton(
                          Icons.check_circle,
                          'Submit Button',
                          'SubmitButton',
                        ),
                        _buildAddComponentButton(
                          Icons.link,
                          'Social Media',
                          'SocialMedia',
                        ),
                        _buildAddComponentButton(
                          Icons.phone,
                          'Contact Info',
                          'ContactInfo',
                        ),
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
          Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),
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
