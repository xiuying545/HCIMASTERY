import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/explanation_page.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/feedback_screen.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_A.dart';

class FlowBScreen extends StatefulWidget {
  final bool fromFlowA;

  const FlowBScreen({super.key, this.fromFlowA = false});

  _FlowBScreenState createState() => _FlowBScreenState();
}

class _FlowBScreenState extends State<FlowBScreen> {
  String? coffeeType;
  String? milkType;
  double sugarAmount = 0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("☕ Flow B - All in One",
            style: TextStyle(color: Colors.brown)),
        leading: const BackButton(color: Colors.brown),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 45.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌟 Choose your coffee type:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: coffeeType,
              decoration: InputDecoration(
                hintText: "Select Coffee",
                filled: true,
                fillColor: const Color(0xFFF9F4E8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Espresso', 'Latte', 'Cappuccino']
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => coffeeType = val),
            ),
            const SizedBox(height: 45),
            const Text('🌸 Pick your milk:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
               DropdownButtonFormField<String>(
              value: milkType,
              decoration: InputDecoration(
                hintText: "Select Milk",
                filled: true,
                fillColor: const Color(0xFFF9F4E8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Whole', 'Oat', 'Almond', 'None']
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => milkType = milkType),
            ),
            
            const SizedBox(height: 45),
            Text('🍬 Sugar: ${sugarAmount.round()} tsp',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Slider(
              value: sugarAmount,
              min: 0,
              max: 3,
              divisions: 3,
              label: '${sugarAmount.round()}',
              activeColor: Colors.pink[200],
              onChanged: (value) => setState(() => sugarAmount = value),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA69E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                               if(widget.fromFlowA == true) {
                                 Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FeedbackScreen()),
                          );
                          } else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FlowAScreen(fromFlowB: true)),
                  );
                          }
                },
                child: 
                
                
                 Text(widget.fromFlowA == true
                          ? 'Give Feedback 💌'
                          : "Next: Flow A 🌈",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9F4E8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }
}
