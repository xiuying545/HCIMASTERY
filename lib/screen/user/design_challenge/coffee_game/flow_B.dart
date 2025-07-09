import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/feedback_screen.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_A.dart';

class FlowBScreen extends StatefulWidget {
  final bool fromFlowA;

  const FlowBScreen({super.key, this.fromFlowA = false});

  @override
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
        title: const Text("☕ Aliran B - Semua Sekali",
            style: TextStyle(color: Colors.brown)),
        leading: const BackButton(color: Colors.brown),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌟 Pilih jenis kopi anda:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: coffeeType,
              decoration: InputDecoration(
                hintText: "Pilih Jenis Kopi",
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
            const Text('🌸 Pilih jenis susu anda:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: milkType,
              decoration: InputDecoration(
                hintText: "Pilih Jenis Susu",
                filled: true,
                fillColor: const Color(0xFFF9F4E8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['Penuh Krim', 'Oat', 'Badam', 'Tiada']
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => milkType = val),
            ),
            const SizedBox(height: 45),
            Text('🍬 Gula: ${sugarAmount.round()} sudu',
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
                  if (widget.fromFlowA == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedbackScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const FlowAScreen(fromFlowB: true)),
                    );
                  }
                },
                child: Text(
                    widget.fromFlowA == true
                        ? 'Beri Maklum Balas 💌'
                        : "Seterusnya: Aliran A 🌈",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
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
