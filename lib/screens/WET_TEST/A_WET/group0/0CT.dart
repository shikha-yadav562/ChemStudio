import 'package:flutter/material.dart';
// Note: Assuming 'group0analysis.dart' provides DatabaseHelper and WetTestItem
import 'group0analysis.dart'; 
// *** REQUIRED IMPORT for the next screen ***
import '../group1/group1detection.dart'; 

// --- Theme Constants (Must match analysis.dart) ---
const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

// NOTE: If WetTestCGroupOneDetectionScreen is not imported correctly, 
// you may need to add a placeholder or ensure the import path above is correct.
// Since you indicated it exists, the import path should resolve it.

// --- Confirmation Test Screen ---
class WetTestCGroupZeroCTScreen extends StatefulWidget {
  const WetTestCGroupZeroCTScreen({super.key});

  @override
  State<WetTestCGroupZeroCTScreen> createState() => _WetTestCGroupZeroCTScreenState();
}

class _WetTestCGroupZeroCTScreenState extends State<WetTestCGroupZeroCTScreen>
    with SingleTickerProviderStateMixin {
  
  late final AnimationController _animController;
  late final Animation<double> _fadeSlide;
  
  // New state variable to track manual selection
  bool _isSelected = false; 

  // Data for the single Confirmation Test
  late final WetTestItem _test = WetTestItem(
      id: 2,
      title: 'C.T FOR NH₄⁺', 
      procedure: 'O.S + Nessler’s reagent in excess', 
      observation:
          'Brown ppt/colouration of basic mercury (II) amidoiodine', 
      options: ['NH₄⁺ Confirmed'],
      correct: 'NH₄⁺ Confirmed',
    );

  final String _answer = 'NH₄⁺ Confirmed';
  // Use the DatabaseHelper defined in analysis.dart
  // Assuming DatabaseHelper.instance and WetTestItem are defined in group0analysis.dart
  final _dbHelper = DatabaseHelper.instance; 
  final String _tableName = 'SaltC_WetTest'; 

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeSlide =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    
    // Note: If you need to check if it was previously selected, 
    // you should add a _loadSavedAnswers() method here.
    
    _animController.forward();
  }

  // Method to handle selection and saving
  void _selectOption() {
    setState(() {
      _isSelected = true;
    });
    _dbHelper.saveAnswer(_tableName, _test.id, _answer);
  }

  // --- NAVIGATION LOGIC ---
  
  // PREVIOUS: Returns to the immediate caller (Group 0 Analysis)
  void _prev() {
    Navigator.pop(context); 
  }

  // NEXT: Navigates forward to Group 1 Detection
  void _next() {
    Navigator.push(
        context,
        MaterialPageRoute(
            // WetTestCGroupOneDetectionScreen is imported from group1detection.dart
            builder: (_) => const WetTestCGroupOneDetectionScreen(), 
        ),
    );
  }

  // --- END NAVIGATION LOGIC ---

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
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [accentTeal, primaryBlue])
                  .createShader(bounds),
          child: const Text(
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
          position:
              Tween<Offset>(begin: const Offset(0.1, 0.03), end: Offset.zero)
                  .animate(_fadeSlide),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_test.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: primaryBlue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTestCard(_test), // Card with Test and Observation
                      const SizedBox(height: 24),
                      _buildInferenceHeader(),
                      const SizedBox(height: 10),
                      // Options (Only one, acts as a confirmation label)
                      ..._test.options.map((opt) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          // Wrap in InkWell and call _selectOption on tap
                          child: InkWell(
                            onTap: _selectOption,
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              // Update decoration based on _isSelected state
                              decoration: BoxDecoration(
                                color: _isSelected 
                                    ? accentTeal.withOpacity(0.1) 
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _isSelected ? accentTeal : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: _isSelected ? primaryBlue : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Navigation Buttons (Prev/Next)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _prev,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    ElevatedButton.icon(
                      // Disable 'Next' button until option is selected
                      onPressed: _isSelected ? _next : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
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

  Widget _buildInferenceHeader() {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: const Text(
        'Result:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
            const SizedBox(height: 4),
            Text(test.procedure, style: const TextStyle(fontSize: 14)),
            const Divider(height: 24),
            _gradientHeader('Observation'),
            const SizedBox(height: 8),
            Text(
              test.observation,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ), 
          ],
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