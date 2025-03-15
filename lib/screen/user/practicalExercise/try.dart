import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Profile Picture",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
        ),
      ],
    );
  }
}

// Name Component
class Name extends UIComponent {
  Name()
      : super(
          type: 'Name',
          text: 'John Doe',
          fontSize: 24,
          x: 160,
          y: 40,
          width: 200,
          height: 80,
        );

  Widget buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900,
            ),
          ),
        ),
      ],
    );
  }
}

// Bio Component
class Bio extends UIComponent {
  Bio()
      : super(
          type: 'Bio',
          text: 'A passionate developer who loves Flutter and building amazing apps.',
          fontSize: 16,
          x: 20,
          y: 160,
          width: 360,
          height: 140,
        );

  Widget buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bio",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

// Submit Button Component
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

// Social Media Component
class SocialMedia extends UIComponent {
  SocialMedia()
      : super(
          type: 'SocialMedia',
          text: 'Instagram: @flutterdev',
          color: Colors.purple,
          x: 20,
          y: 300,
          width: 240,
          height: 80,
        );

  Widget buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Social Media",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.link, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Contact Info Component
class ContactInfo extends UIComponent {
  ContactInfo()
      : super(
          type: 'ContactInfo',
          text: 'Email: john.doe@example.com',
          color: Colors.green,
          x: 20,
          y: 380,
          width: 280,
          height: 80,
        );

  Widget buildWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Info",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.email, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() => _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState extends State<ProfileDesignChallengePage> {
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
    bool hasProfilePicture = components.any((comp) => comp.type == 'ProfilePicture');
    bool hasName = components.any((comp) => comp.type == 'Name');
    bool hasBio = components.any((comp) => comp.type == 'Bio');
    bool hasSubmitButton = components.any((comp) => comp.type == 'SubmitButton');

    // HCI Rules
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
      feedback += "❌ Consider adding a short bio to share more about yourself.\n";
    }
    if (hasSubmitButton) {
      UIComponent submitButton = components.firstWhere((comp) => comp.type == 'SubmitButton');
      if (submitButton.y >= canvasHeight - 80) {
        feedback += "✅ Submit button is well positioned at the bottom. (+20 points)\n";
        newScore += 20;
      } else {
        feedback += "❌ The submit button should be placed at the bottom for easier access.\n";
      }
    } else {
      feedback += "❌ Include a submit button so users can save their profile.\n";
    }

    setState(() {
      feedbackText = feedback;
      score = newScore.clamp(0, 100);
    });
  }

  void _editComponent(int index) {
    UIComponent comp = components[index];
    TextEditingController textController = TextEditingController(text: comp.text);
    double currentFontSize = comp.fontSize;
    Color currentColor = comp.color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${comp.type}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Text'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Font Size: '),
                    Expanded(
                      child: Slider(
                        value: currentFontSize,
                        min: 12,
                        max: 36,
                        divisions: 6,
                        label: currentFontSize.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(() {
                            currentFontSize = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Color: '),
                    IconButton(
                      icon: const Icon(Icons.circle, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.blue;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle, color: Colors.orange),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.orange;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.green;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle, color: Colors.purple),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.purple;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  comp.text = textController.text;
                  comp.fontSize = currentFontSize;
                  comp.color = currentColor;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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
            comp.x = (comp.x + details.delta.dx).clamp(0, canvasWidth - comp.width);
            comp.y = (comp.y + details.delta.dy).clamp(0, canvasHeight - comp.height);
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
          IconButton(
            tooltip: 'Toggle Dark Mode',
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
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
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedbackText,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    'Score: $score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade900),
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
                    for (int i = 0; i < components.length; i++) _buildDraggableComponent(components[i], i),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitDesign,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Submit Design'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 10,
                  children: [
                    _buildAddComponentButton(Icons.account_circle, 'Profile Picture', 'ProfilePicture'),
                    _buildAddComponentButton(Icons.person, 'Name', 'Name'),
                    _buildAddComponentButton(Icons.info, 'Bio', 'Bio'),
                    _buildAddComponentButton(Icons.check_circle, 'Submit