import 'package:flutter/material.dart';
import 'group0analysis.dart'; 
import '../group1/group1detection.dart'; 
import '../a_intro.dart'; // Standard import for Salt A Intro

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class WetTestAGroupZeroCTScreen extends StatefulWidget {
  const WetTestAGroupZeroCTScreen({super.key});

  @override
  State<WetTestAGroupZeroCTScreen> createState() => _WetTestAGroupZeroCTScreenState();
}

class _WetTestAGroupZeroCTScreenState extends State<WetTestAGroupZeroCTScreen>
    with SingleTickerProviderStateMixin {
  
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;
  bool _isSelected = false; 

  late final WetTestItem _test = WetTestItem(
      id: 2,
      title: 'C.T FOR NH₄⁺', 
      procedure: 'O.S + Nessler’s reagent in excess', 
      observation: 'Brown ppt/colouration of basic mercury (II) amidoiodine', 
      options: ['NH₄⁺ Confirmed'],
      correct: 'NH₄⁺ Confirmed',
    );

  final String _answer = 'NH₄⁺ Confirmed';
  final _dbHelper = DatabaseHelper.instance; 
  final String _tableName = 'SaltC_WetTest'; 

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeSlide = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  void _selectOption() {
    setState(() {
      _isSelected = true;
    });
    _dbHelper.saveAnswer(_tableName, _test.id, _answer);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        // FIXED: Back arrow navigating to Intro A
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WetTestIntroAScreen()),
              (route) => false,
            );
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: Text(
            'Salt A : Wet Test',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeSlide,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.1, 0.03), end: Offset.zero)
              .animate(_fadeSlide),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _test.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTestCard(_test),
                      const SizedBox(height: 24),
                      _gradientHeader('Result:'),
                      const SizedBox(height: 10),
                      ..._test.options.map((opt) => _buildOption(opt)),
                    ],
                  ),
                ),
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: TextButton.styleFrom(foregroundColor: primaryBlue),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isSelected ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const WetTestAGroupOneDetectionScreen()),
                        );
                      } : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSelected ? primaryBlue : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(WetTestItem test) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientHeader('Test'),
            const SizedBox(height: 6),
            Text(test.procedure, style: const TextStyle(fontSize: 15, color: Colors.black)),
            const Divider(height: 24),
            _gradientHeader('Observation'),
            const SizedBox(height: 6),
            Text(
              test.observation,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ), 
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String opt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: _selectOption,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isSelected ? accentTeal.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isSelected ? accentTeal : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Text(
            opt,
            style: TextStyle(
              fontSize: 15,
              fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal,
              color: _isSelected ? accentTeal : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradientHeader(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}