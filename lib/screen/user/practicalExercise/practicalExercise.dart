import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/practicalExercise/components.dart';
import 'package:fyp1/screen/user/practicalExercise/helpers.dart';
import 'package:google_fonts/google_fonts.dart';

// ------------------ Main Page ------------------
class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() =>
      _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState
    extends State<ProfileDesignChallengePage> {
  final List<UIComponent> components = [ProfilePicture(),Bio(),ContactInfo(),EditProfile()];
  String feedbackText = "";
  double canvasWidth = 400; // Will be updated dynamically
  double canvasHeight = 600; // Will be updated dynamically
  int score = 0;
  bool isSnapToGridEnabled = true;
  bool isDarkMode = false;
  int? selectedIndex;
  Color canvasBackgroundColor = Colors.white;
  OverlayEntry? _overlayEntry;

  void _showCustomOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 100, // Stick to the top
          left: MediaQuery.of(context).size.width * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: Colors.blue.shade900.withOpacity(0.8),
            elevation: 8,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildOverlayIconButton(
                      Icons.account_circle, 'ProfilePicture'),
                  _buildOverlayIconButton(Icons.person, 'Name'),
                  _buildOverlayIconButton(Icons.info, 'Bio'),
                  _buildOverlayIconButton(Icons.phone, 'ContactInfo'),
                  _buildOverlayIconButton(Icons.edit, 'EditProfile'),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildOverlayIconButton(IconData icon, String type) {
    return IconButton(
      icon: Icon(icon, color: Colors.white), // White icon
      onPressed: () {
        _addComponent(type);
        _hideCustomOverlay();
      },
      tooltip: type, // Optional: Add tooltip for accessibility
    );
  }

  void _hideCustomOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    // Initialize canvas size based on screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        canvasWidth = MediaQuery.of(context).size.width;
        canvasHeight =
            MediaQuery.of(context).size.height * 0.8; // 80% of screen height
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100, // Light grey background
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          title: Text(
            'Profile Page',
            style: GoogleFonts.poppins(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                            if (components.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      16.0), // Add padding for better spacing
                                  child: Text(
                                    'Drag elements onto the canvas to design a profile page',
                                    style: GoogleFonts.poppins(
                                      // Use Poppins font
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .grey.shade700, // Subtle text color
                                    ),
                                    textAlign: TextAlign
                                        .center, // Center-align the text
                                  ),
                                ),
                              ),
                            for (int i = 0; i < components.length; i++)
                              _buildDraggableComponent(components[i], i),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue.shade900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Feedback Button
              ElevatedButton.icon(
                onPressed: _submitDesign,
                icon: Icon(Icons.tips_and_updates, color: Colors.white),
                label: Text(
                  'Feedback',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.orange, width: 2),
                  ),
                  elevation: 0,
                ),
              ),
              // Add Button
              ElevatedButton.icon(
                onPressed: () {
                  if (_overlayEntry == null) {
                    _showCustomOverlay();
                  } else {
                    _hideCustomOverlay();
                  }
                },
                icon: Icon(Icons.widgets, color: Colors.white),
                label: Text(
                  'Add',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.orange, width: 2),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ));
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

      case 'EditProfile':
        return (comp as EditProfile).buildWidget(context);
      default:
        return const SizedBox();
    }
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
        case 'EditProfile':
          components.add(EditProfile());
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


    String feedback = "";
    if (strengths.isNotEmpty) {
      feedback += "✅ **Strengths**: ${strengths.join(", ")}.\n\n";
    }
    if (improvements.isNotEmpty) {
      feedback += "⚠️ **Improvements**: ${improvements.join(", ")}.\n\n";
    }
    feedback += "🎯 **Your Score**: ${newScore.clamp(0, 100)}/100.";

    // Show feedback in a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Design Feedback',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (strengths.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Strengths',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...strengths
                          .map((strength) => Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Text(
                                  '• $strength',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ))
                          .toList(),
                      const SizedBox(height: 16),
                    ],
                  ),
                if (improvements.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning,
                              color: Colors.orange.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Improvements',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...improvements
                          .map((improvement) => Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Text(
                                  '• $improvement',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ))
                          .toList(),
                      const SizedBox(height: 16),
                    ],
                  ),
                // Score
                Row(
                  children: [
                    Icon(Icons.assessment,
                        color: Colors.blue.shade900, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Score: $newScore/100',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: newScore / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    newScore >= 80
                        ? Colors.green.shade600
                        : newScore >= 50
                            ? Colors.orange.shade600
                            : Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ],
        );
      },
    );

    setState(() {
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
}
