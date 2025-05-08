import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/feedback_screen.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_B.dart';

class FlowAScreen extends StatefulWidget {
  final bool fromFlowB;

  const FlowAScreen({super.key, this.fromFlowB = false});

  @override
  _FlowAScreenState createState() => _FlowAScreenState();
}

class _FlowAScreenState extends State<FlowAScreen> {
  String? coffeeType;
  String? milkType;
  int? sugarAmount;
  int step = 0;


  void nextStep() {
    setState(() {
      step++;
    });
  }

  Widget stepContent() {
    switch (step) {
      case 0:
        return stepCard(
          emoji: '☕',
          label: 'Choose your coffee:',
          child: DropdownButtonFormField<String>(
            value: coffeeType,
            decoration: inputDecoration('Select Coffee'),
            items: ['Espresso', 'Latte', 'Cappuccino']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (val) => setState(() => coffeeType = val),
          ),
        );
      case 1:
        return stepCard(
          emoji: '🥛',
          label: 'Pick your milk:',
          child: DropdownButtonFormField<String>(
            value: milkType,
            decoration: inputDecoration('Select Milk'),
            items: ['Whole', 'Oat', 'Almond', 'None']
                .map((milk) => DropdownMenuItem(value: milk, child: Text(milk)))
                .toList(),
            onChanged: (val) => setState(() => milkType = val),
          ),
        );
      case 2:
        return stepCard(
          emoji: '🍬',
          label: 'How many teaspoons of sugar?',
          child: DropdownButtonFormField<int>(
            value: sugarAmount,
            decoration: inputDecoration('Select Sugar'),
            items: [0, 1, 2, 3]
                .map((sugar) =>
                    DropdownMenuItem(value: sugar, child: Text('$sugar tsp')))
                .toList(),
            onChanged: (val) => setState(() => sugarAmount = val),
          ),
        );
      default:
        return Container();
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Color(0xFFFFD6E0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget stepCard(
      {required String emoji, required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji  $label',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  
    bool isNextEnabled = (step == 0 && coffeeType != null) ||
        (step == 1 && milkType != null) ||
        (step == 2 && sugarAmount != null);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("☕ Flow A — Step by Step",
            style: TextStyle(color: Colors.brown)),
        leading: const BackButton(color: Colors.brown),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            stepContent(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isNextEnabled
                    ? () async {
                        if (step == 2) {
                          if(widget.fromFlowB == true) {
                                 Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FeedbackScreen()),
                          );
                          } else{
                 
                             Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FlowBScreen(fromFlowA: true,)),
                          );
                          }
                        } else {
                          nextStep();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA69E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  step == 2
                      ? (widget.fromFlowB  == true
                          ? "Give Feedback 💌"
                          : "Next: Flow B 🌈")
                      : "Next ➡️",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
