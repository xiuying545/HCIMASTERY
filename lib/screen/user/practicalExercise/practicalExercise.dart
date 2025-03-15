import 'package:flutter/material.dart';

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
          components.add(UIComponent(
            type: type,
            text: 'Profile Picture',
            color: Colors.blue.shade900,
            x: 20,
            y: 20,
            width: 100,
            height: 100,
          ));
          break;
        case 'Name':
          components.add(UIComponent(
            type: type,
            text: 'John Doe',
            fontSize: 24,
            x: 140,
            y: 40,
            width: 200,
            height: 40,
          ));
          break;
        case 'Bio':
          components.add(UIComponent(
            type: type,
            text: 'A passionate developer who loves Flutter and building amazing apps.',
            fontSize: 16,
            x: 20,
            y: 140,
            width: 360,
            height: 100,
          ));
          break;
        case 'SubmitButton':
          components.add(UIComponent(
            type: type,
            text: 'Submit',
            color: Colors.blue.shade900,
            x: 20,
            y: canvasHeight - 70,
            width: 100,
            height: 50,
          ));
          break;
        case 'SocialMedia':
          components.add(UIComponent(
            type: type,
            text: 'Instagram: @flutterdev',
            color: Colors.purple,
            x: 20,
            y: 260,
            width: 200,
            height: 40,
          ));
          break;
        case 'ContactInfo':
          components.add(UIComponent(
            type: type,
            text: 'Email: john.doe@example.com',
            color: Colors.green,
            x: 20,
            y: 320,
            width: 250,
            height: 40,
          ));
          break;
      }
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

  void _submitDesign() {
    int newScore = 0;
    String feedback = "HCI Design Feedback:\n";
    bool hasProfilePicture = components.any((comp) => comp.type == 'ProfilePicture');
    bool hasName = components.any((comp) => comp.type == 'Name');
    bool hasBio = components.any((comp) => comp.type == 'Bio');
    bool hasSubmitButton = components.any((comp) => comp.type == 'SubmitButton');

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
          child: Container(
            width: comp.width,
            height: comp.height,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  comp.color.withOpacity(0.1),
                  comp.color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: comp.color, width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: comp.type == 'ProfilePicture'
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: comp.color,
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  )
                : comp.type == 'SubmitButton'
                    ? ElevatedButton(
                        onPressed: _submitDesign,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: comp.color,
                          textStyle: TextStyle(fontSize: comp.fontSize),
                        ),
                        child: Text(comp.text),
                      )
                    : Text(
                        comp.text,
                        style: TextStyle(fontSize: comp.fontSize, color: Colors.black),
                      ),
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
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.grey.shade900, Colors.grey.shade800]
                        : [Colors.white, Colors.grey.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                    _buildAddComponentButton(Icons.check_circle, 'Submit Button', 'SubmitButton'),
                    _buildAddComponentButton(Icons.link, 'Social Media', 'SocialMedia'),
                    _buildAddComponentButton(Icons.phone, 'Contact Info', 'ContactInfo'),
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
    return ElevatedButton.icon(
      onPressed: () {
        _addComponent(type);
        Navigator.pop(context);
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}