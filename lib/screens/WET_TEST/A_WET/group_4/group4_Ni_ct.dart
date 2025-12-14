import 'package:flutter/material.dart';
import '../group_5/group5detection_firstanalysis.dart';

const Color primaryBlue = Color(0xFF004C91);
const Color accentTeal = Color(0xFF00A6A6);

class Ni2ConfirmedPage extends StatefulWidget {
  const Ni2ConfirmedPage({super.key});

  @override
  State<Ni2ConfirmedPage> createState() => _Ni2ConfirmedPageState();
}

class _Ni2ConfirmedPageState extends State<Ni2ConfirmedPage> {
  String? selectedOption;

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
            'Salt C : Wet Test',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: _buildContent(),
      ),

      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "C.T For Ni²⁺ ",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _solutionCard(),
        const SizedBox(height: 12),
        _testCard(),
        const SizedBox(height: 16),
        _gradientTitle("Select the correct inference:"),
        const SizedBox(height: 10),
        _buildOption("Ni²⁺ confirmed"),
      ],
    );
  }

  Widget _buildNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text(
            'Previous',
            style: TextStyle(fontSize: 16),
          ),
        ),

        ElevatedButton.icon(
          onPressed: selectedOption != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GroupVPage()),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedOption != null ? primaryBlue : Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const StadiumBorder(),
          ),
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: const Text(
            'Next',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // ✅ SOLUTION (same style as Observation)
  Widget _solutionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GradientText("Solution"),
            SizedBox(height: 6),
            Text(
              "Dissolve the black ppt of group IV in aquaregia "
              "(conc. HCl + conc. HNO₃ in 3:1 proportion), "
              "dilute with water. Use this solution for C.T.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ TEST (black normal) + OBSERVATION (bold blue same as Solution)
  Widget _testCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GradientText("Test"),
            SizedBox(height: 6),
            Text(
              "Above solution + NaOH",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            Divider(height: 22),
            _GradientText("Observation"),
            SizedBox(height: 6),
            Text(
              "Light green ppt",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  // ✅ Option: teal + bold on click
  Widget _buildOption(String text) {
    final bool selected = selectedOption == text;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() => selectedOption = text),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? accentTeal.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? accentTeal : Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? accentTeal : Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ Reusable gradient text widget (NO structure changed)
class _GradientText extends StatelessWidget {
  final String text;
  const _GradientText(this.text);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const LinearGradient(colors: [accentTeal, primaryBlue])
              .createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
