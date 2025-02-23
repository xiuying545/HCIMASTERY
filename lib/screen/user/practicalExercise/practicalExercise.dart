import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Main App Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page Design Challenge',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileDesignChallengePage(),
    );
  }
}

/// Model representing a UI component on the design canvas.
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
    this.color = Colors.teal,
    this.fontSize = 18,
    this.x = 50,
    this.y = 50,
    this.width = 100,
    this.height = 50,
    this.isSelected = false,
  });
}

/// The main page for the design challenge.
class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() => _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState extends State<ProfileDesignChallengePage> {
  // List of components placed on the canvas.
  final List<UIComponent> components = [];
  // Feedback text after submission.
  String feedbackText = "";
  // "Design your profile page.\n"
      // "Include a profile picture, your name, a short bio, and a submit button.\n\n"
      // "HCI Guidelines:\n"
      // "• Use a clear visual hierarchy.\n"
      // "• Place interactive elements (e.g., submit button) at the bottom.\n"
      // "• Ensure text is legible and components don’t overlap.\n"
      // "• Maintain consistent colors and fonts.";

  // Size of the design canvas (for positioning logic)
  final double canvasWidth = 400;
  final double canvasHeight = 500;

  /// Adds a new component at a default position.
  void _addComponent(String type) {
    setState(() {
      switch (type) {
        case 'ProfilePicture':
          components.add(UIComponent(
            type: type,
            text: 'Profile Picture',
            color: Colors.grey,
            x: 20,
            y: 20,
            width: 100,
            height: 100,
          ));
          break;
        case 'Name':
          components.add(UIComponent(
            type: type,
            text: 'Your Name',
            fontSize: 24,
            x: 20,
            y: 140,
            width: 200,
            height: 40,
          ));
          break;
        case 'Bio':
          components.add(UIComponent(
            type: type,
            text: 'Short Bio',
            fontSize: 16,
            x: 20,
            y: 200,
            width: 300,
            height: 80,
          ));
          break;
        case 'SubmitButton':
          components.add(UIComponent(
            type: type,
            text: 'Submit Profile',
            color: Colors.teal,
            x: 20,
            y: canvasHeight - 70, // Ideally at the bottom
            width: 150,
            height: 50,
          ));
          break;
      }
    });
  }

  /// Opens an editing dialog for the component.
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
                // For components that display text (skip editing text for Profile Picture)
                if (comp.type != 'ProfilePicture') ...[
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
                ],
                const SizedBox(height: 10),
                // Color selection
                Row(
                  children: [
                    const Text('Color: '),
                    IconButton(
                      icon: const Icon(Icons.circle, color: Colors.teal),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.teal;
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
                      icon: const Icon(Icons.circle, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.blue;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          currentColor = Colors.red;
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
              onPressed: () => Navigator.of(context).pop(), // Cancel editing
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

  /// Evaluates the design against HCI rules and provides feedback.
  void _submitDesign() {
    String feedback = "HCI Design Feedback:\n";
    bool hasProfilePicture = components.any((comp) => comp.type == 'ProfilePicture');
    bool hasName = components.any((comp) => comp.type == 'Name');
    bool hasBio = components.any((comp) => comp.type == 'Bio');
    bool hasSubmitButton = components.any((comp) => comp.type == 'SubmitButton');

    if (!hasProfilePicture) {
      feedback += "• Please add a profile picture for visual identity.\n";
    } else {
      feedback += "• Profile picture is present.\n";
    }
    if (!hasName) {
      feedback += "• A name field is needed to personalize the profile.\n";
    } else {
      feedback += "• Name field is present.\n";
    }
    if (!hasBio) {
      feedback += "• Consider adding a short bio to share more about yourself.\n";
    } else {
      feedback += "• Bio field is present.\n";
    }
    if (!hasSubmitButton) {
      feedback += "• Include a submit button so users can save their profile.\n";
    } else {
      // Check if the submit button is at the bottom (within 80 pixels of canvas bottom)
      UIComponent submitButton = components.firstWhere((comp) => comp.type == 'SubmitButton');
      if (submitButton.y < canvasHeight - 80) {
        feedback += "• The submit button should be placed at the bottom for easier access.\n";
      } else {
        feedback += "• Submit button is well positioned at the bottom.\n";
      }
    }
    // Check for potential overlapping (a simple rule: x coordinate should be greater than 10)
    for (var comp in components) {
      if (comp.x < 10 || comp.y < 10) {
        feedback += "• Some components may be too close to the edge; ensure adequate padding.\n";
        break;
      }
    }
    // Final note on visual hierarchy and clarity
    feedback += "• Ensure that your design follows a clear visual hierarchy and avoids clutter.\n";

    setState(() {
      feedbackText = feedback;
    });
  }

  /// Displays a dialog with HCI guidelines.
  void _showHCIGuidelines() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('HCI Design Guidelines'),
          content: const SingleChildScrollView(
            child: Text(
              "1. Visibility of system status: Provide immediate feedback for user actions.\n"
              "2. Match between system and the real world: Use familiar icons and layout conventions.\n"
              "3. User control and freedom: Allow easy repositioning and editing of components.\n"
              "4. Consistency and standards: Keep colors, fonts, and styles consistent.\n"
              "5. Error prevention: Avoid overlapping elements and ensure proper spacing.\n"
              "6. Aesthetic and minimalist design: Keep the interface uncluttered and clear.\n"
              "7. Help users recognize, diagnose, and recover from errors: Provide clear feedback on design issues.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Builds a draggable UI component widget.
  Widget _buildDraggableComponent(UIComponent comp, int index) {
    return Positioned(
      left: comp.x,
      top: comp.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            comp.x += details.delta.dx;
            comp.y += details.delta.dy;
            // Constrain within canvas
            comp.x = comp.x.clamp(0.0, canvasWidth - comp.width);
            comp.y = comp.y.clamp(0.0, canvasHeight - comp.height);
          });
        },
        onTap: () => _editComponent(index),
        child: Container(
          width: comp.width,
          height: comp.height,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: comp.color.withOpacity(0.2),
            border: Border.all(color: comp.color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: comp.type == 'ProfilePicture'
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: comp.color,
                  child: Text(
                    "PP",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              : comp.type == 'SubmitButton'
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: comp.color,
                        textStyle: TextStyle(fontSize: comp.fontSize),
                      ),
                      child: Text(comp.text),
                    )
                  : Text(
                      comp.text,
                      style: TextStyle(fontSize: comp.fontSize, color: comp.color),
                    ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page Design Challenge'),
        actions: [
          IconButton(
            tooltip: 'HCI Guidelines',
            icon: const Icon(Icons.info_outline),
            onPressed: _showHCIGuidelines,
          ),
        ],
      ),
      body: Column(
        children: [
          // Display feedback/instructions at the top.
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            width: double.infinity,
            child: Text(
              feedbackText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const Divider(),
          // The design canvas where components are arranged.
          Center(
            child: Container(
              width: canvasWidth,
              height: canvasHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  // Render each UI component in the canvas.
                  for (int i = 0; i < components.length; i++) _buildDraggableComponent(components[i], i),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Submit design button.
          ElevatedButton(
            onPressed: _submitDesign,
            child: const Text('Submit Design'),
          ),
        ],
      ),
      // Bottom palette for adding new components.
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                tooltip: 'Add Profile Picture',
                icon: const Icon(Icons.account_circle, size: 30),
                onPressed: () => _addComponent('ProfilePicture'),
              ),
              IconButton(
                tooltip: 'Add Name',
                icon: const Icon(Icons.person, size: 30),
                onPressed: () => _addComponent('Name'),
              ),
              IconButton(
                tooltip: 'Add Bio',
                icon: const Icon(Icons.info, size: 30),
                onPressed: () => _addComponent('Bio'),
              ),
              IconButton(
                tooltip: 'Add Submit Button',
                icon: const Icon(Icons.check_circle, size: 30),
                onPressed: () => _addComponent('SubmitButton'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}