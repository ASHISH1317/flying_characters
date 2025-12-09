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

  // Duration
  Duration duration = const Duration(milliseconds: 700);

  // Delay
  Duration delay = const Duration(milliseconds: 50);

  // offset
  double offset = 32;

  // Random
  bool random = true;

  // Loop
  bool loop = false;

  // Seed
  int seed = 7;

  // Type mode state
  FlyingCharactersMode typeMode = FlyingCharactersMode.word;

  // Animation type
  FlyingAnimationType animationType = FlyingAnimationType.fly;

  // Input controller
  final inputCtrl = TextEditingController(
    text:
        "Flying Characters ✨ – A Flutter package for beautiful flying text animations",
  );

  // Refresh
  void refresh() => setState(() => seed++);

  @override
  Widget build(BuildContext context) {
    const Color lightBlue = Color(0xFFD9EAFD);
    const Color offWhite = Color(0xFFF8FAFC);
    const Color blueGrey = Color(0xFFBCCCDC);
    const Color darkGrey = Color(0xFF9AA6B2);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: offWhite,
      ),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////////////////////
                ///  Text input box
                ////////////////////////////////////////////////////////////////////////////
                Container(
                  decoration: BoxDecoration(
                    color: offWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: darkGrey.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: inputCtrl,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Enter text to animate",
                      labelStyle: TextStyle(color: darkGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: blueGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: lightBlue, width: 2),
                      ),
                      filled: true,
                    ),
                    onChanged: (v) => setState(() => text = v),
                  ),
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////////////////////
                ///  Preview Area
                ////////////////////////////////////////////////////////////////////////////
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [lightBlue, blueGrey.withValues(alpha: .2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: darkGrey.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: FlyingCharacters(
                    key: ValueKey("$seed-$animationType"),
                    text: text,
                    duration: duration,
                    perItemDelay: delay,
                    maxStartOffset: offset,
                    randomDirections: random,
                    loop: loop,
                    mode: typeMode,

                    // << NEW
                    animationType: animationType,

                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ////////////////////////////////////////////////////////////////////////////
                /// Sliders
                ////////////////////////////////////////////////////////////////////////////
                _slider(
                  "Duration",
                  duration.inMilliseconds.toDouble(),
                  2000,
                  (v) => setState(
                    () => duration = Duration(milliseconds: v.toInt()),
                  ),
                  darkGrey,
                ),
                _slider(
                  "Delay per Character",
                  delay.inMilliseconds.toDouble(),
                  150,
                  (v) =>
                      setState(() => delay = Duration(milliseconds: v.toInt())),
                  darkGrey,
                ),
                _slider(
                  "Start Offset (spread)",
                  offset,
                  80,
                  (v) => setState(() => offset = v),
                  darkGrey,
                ),

                const SizedBox(height: 10),

                ////////////////////////////////////////////////////////////////////////////
                /// Checkboxes
                ////////////////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    Checkbox(
                      value: random,
                      activeColor: darkGrey,
                      onChanged: (v) => setState(() => random = v!),
                    ),
                    const Text("Random directions"),
                    const Spacer(),
                    Checkbox(
                      value: loop,
                      activeColor: darkGrey,
                      onChanged: (v) => setState(() => loop = v!),
                    ),
                    const Text("Loop"),
                  ],
                ),

                const SizedBox(height: 10),

                ////////////////////////////////////////////////////////////////////////////
                /// Word / Character mode
                ////////////////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    Checkbox(
                      value: typeMode == FlyingCharactersMode.character,
                      activeColor: darkGrey,
                      onChanged: (v) => setState(
                        () => typeMode = FlyingCharactersMode.character,
                      ),
                    ),
                    const Text("Character"),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: typeMode == FlyingCharactersMode.word,
                      activeColor: darkGrey,
                      onChanged: (v) =>
                          setState(() => typeMode = FlyingCharactersMode.word),
                    ),
                    const Text("Word"),
                  ],
                ),

                const SizedBox(height: 20),

                ////////////////////////////////////////////////////////////////////////////
                /// Animation Type Selector
                ////////////////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    const Text(
                      "Animation Type:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<FlyingAnimationType>(
                      value: animationType,
                      onChanged: (v) => setState(() => animationType = v!),
                      items: FlyingAnimationType.values.map((a) {
                        return DropdownMenuItem(value: a, child: Text(a.name));
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: refresh,
                  icon: const Icon(Icons.replay, color: Colors.black),
                  label: const Text(
                    "Replay Animation",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    backgroundColor: lightBlue,
                    foregroundColor: darkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                ),

                const SizedBox(height: 40),
                Text(
                  "Try modifying text, toggles & sliders ↓",
                  style: TextStyle(color: darkGrey.withValues(alpha: .8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _slider(
    String title,
    double value,
    double max,
    ValueChanged<double> onChange,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          max: max,
          min: 0,
          divisions: 40,
          activeColor: color,
          onChanged: onChange,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
