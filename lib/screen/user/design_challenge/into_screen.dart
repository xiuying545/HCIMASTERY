import 'package:flutter/material.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '☁️ Welcome to the Coffee Fun Game! ☁️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Try two cute coffee ordering flows and tell us which is better! ☕',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.brown[700]),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Start Flow A', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FlowAScreen()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
class FlowAScreen extends StatefulWidget {
  const FlowAScreen({super.key});

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
        return Column(
          children: [
            const Text('🍵 Choose your coffee:', style: TextStyle(fontSize: 20)),
            DropdownButton<String>(
              value: coffeeType,
              hint: const Text('Select Coffee'),
              items: ['Espresso', 'Latte', 'Cappuccino']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => coffeeType = val),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            const Text('🥛 Pick your milk:', style: TextStyle(fontSize: 20)),
            DropdownButton<String>(
              value: milkType,
              hint: const Text('Select Milk'),
              items: ['Whole', 'Oat', 'Almond', 'None']
                  .map((milk) => DropdownMenuItem(value: milk, child: Text(milk)))
                  .toList(),
              onChanged: (val) => setState(() => milkType = val),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            const Text('🍬 How many teaspoons of sugar?', style: TextStyle(fontSize: 20)),
            DropdownButton<int>(
              value: sugarAmount,
              hint: const Text('Select Sugar'),
              items: [0, 1, 2, 3]
                  .map((sugar) => DropdownMenuItem(value: sugar, child: Text('$sugar tsp')))
                  .toList(),
              onChanged: (val) => setState(() => sugarAmount = val),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNextEnabled = (step == 0 && coffeeType != null) ||
        (step == 1 && milkType != null) ||
        (step == 2 && sugarAmount != null);

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(title: const Text('Flow A - Step by Step')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            stepContent(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isNextEnabled
                  ? () {
                      if (step == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FlowBScreen()),
                        );
                      } else {
                        nextStep();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
              child: Text(step == 2 ? 'Next: Flow B 🌈' : 'Next ➡️'),
            )
          ],
        ),
      ),
    );
  }
}

class FlowBScreen extends StatefulWidget {
  const FlowBScreen({super.key});

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
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(title: const Text('Flow B - All in One')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌟 Choose your coffee type:'),
            DropdownButton<String>(
              value: coffeeType,
              hint: const Text('Select Coffee'),
              items: ['Espresso', 'Latte', 'Cappuccino']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => coffeeType = val),
            ),
            const SizedBox(height: 10),
            const Text('🌸 Pick your milk:'),
            Wrap(
              spacing: 10,
              children: ['Whole', 'Oat', 'Almond', 'None']
                  .map((milk) => ChoiceChip(
                        label: Text(milk),
                        selected: milkType == milk,
                        onSelected: (_) => setState(() => milkType = milk),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text('🍬 Sugar: ${sugarAmount.round()} tsp'),
            Slider(
              value: sugarAmount,
              min: 0,
              max: 3,
              divisions: 3,
              label: '${sugarAmount.round()}',
              onChanged: (value) => setState(() => sugarAmount = value),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                );
              },
              child: const Text('Give Feedback 💌'),
            )
          ],
        ),
      ),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedFlow;
  String feedbackText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text('Feedback Time 🌟')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('🌈 Which flow did you like better?', style: TextStyle(fontSize: 20)),
            ListTile(
              title: const Text('Flow A (Step-by-step)'),
              leading: Radio<String>(
                value: 'A',
                groupValue: selectedFlow,
                onChanged: (String? value) {
                  setState(() {
                    selectedFlow = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Flow B (All-in-one)'),
              leading: Radio<String>(
                value: 'B',
                groupValue: selectedFlow,
                onChanged: (String? value) {
                  setState(() {
                    selectedFlow = value;
                  });
                },
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: '💬 Why did you prefer it?'),
              onChanged: (text) {
                feedbackText = text;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExplanationScreen()),
                );
              },
              child: const Text('Submit 🎉'),
            )
          ],
        ),
      ),
    );
  }
}

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(title: const Text('HCI Learning 🌟')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '🎓 What Did You Learn?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Flow A uses a step-by-step approach. It helps users focus on one thing at a time, which is useful for beginners or kids.\n\nFlow B shows everything at once. It can be faster but may feel overwhelming.\n\nIn HCI, we learn that good design depends on who is using the system and for what purpose. 💡',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[200]),
              child: const Text('Back to Start 🔁'),
            )
          ],
        ),
      ),
    );
  }
}

