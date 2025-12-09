import 'package:flutter/material.dart';
import 'package:flying_characters/flying_characters.dart';

void main() {
  runApp(const FlyingCharactersDemo());
}

class FlyingCharactersDemo extends StatefulWidget {
  const FlyingCharactersDemo({super.key});

  @override
  State<FlyingCharactersDemo> createState() => _FlyingCharactersDemoState();
}

class _FlyingCharactersDemoState extends State<FlyingCharactersDemo> {
  String text =
      "Flying Characters ✨ – A Flutter package for beautiful flying text animations";
  Duration duration = const Duration(milliseconds: 700);
  Duration delay = const Duration(milliseconds: 50);
  double offset = 32;
  bool random = true;
  bool loop = false;
  int seed = 7;

  final inputCtrl = TextEditingController(
    text:
        "Flying Characters ✨ – A Flutter package for beautiful flying text animations",
  );
  final key = GlobalKey();

  void refresh() {
    setState(() => seed++); // new seed triggers animation rebuild
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: const Text("Flying Characters Demo")),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// 🔤 Editable text
                TextField(
                  controller: inputCtrl,
                  decoration: const InputDecoration(
                    labelText: "Enter text to animate",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => text = v),
                ),
                const SizedBox(height: 20),

                /// 🌟 Animation Widget Preview
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: FlyingCharacters(
                    key: ValueKey(seed),
                    text: text,
                    duration: duration,
                    perItemDelay: delay,
                    maxStartOffset: offset,
                    randomDirections: random,
                    loop: loop,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// 🎛 Controls Panel
                _slider(
                  title: "Duration",
                  value: duration.inMilliseconds.toDouble(),
                  max: 2000,
                  onChange: (v) => setState(
                    () => duration = Duration(milliseconds: v.toInt()),
                  ),
                ),
                _slider(
                  title: "Delay per Character",
                  value: delay.inMilliseconds.toDouble(),
                  max: 150,
                  onChange: (v) =>
                      setState(() => delay = Duration(milliseconds: v.toInt())),
                ),
                _slider(
                  title: "Start Offset (spread)",
                  value: offset,
                  max: 80,
                  onChange: (v) => setState(() => offset = v),
                ),

                Row(
                  children: [
                    Checkbox(
                      value: random,
                      onChanged: (v) => setState(() => random = v!),
                    ),
                    const Text("Random directions"),

                    const Spacer(),

                    Checkbox(
                      value: loop,
                      onChanged: (v) => setState(() => loop = v!),
                    ),
                    const Text("Loop"),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔁 Restart animation
                ElevatedButton.icon(
                  onPressed: refresh,
                  icon: const Icon(Icons.replay),
                  label: const Text("Replay Animation"),
                ),

                const SizedBox(height: 40),
                const Text("Try modifying text, toggles & sliders ↓"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable slider widget
  Widget _slider({
    required String title,
    required double value,
    required double max,
    required ValueChanged<double> onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("$title: ${value.toInt()}ms"),
        Slider(
          value: value,
          max: max,
          min: 0,
          divisions: 40,
          onChanged: onChange,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
