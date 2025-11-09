import 'package:flutter/material.dart';

class WetTestScreen extends StatefulWidget {
  const WetTestScreen({super.key});

  @override
  State<WetTestScreen> createState() => _WetTestScreenState();
}

class _WetTestScreenState extends State<WetTestScreen> {
  bool osPrepared = false;

  // List of qualitative analysis groups
  final List<Map<String, dynamic>> groups = [
    {
      "name": "Group 0 (NH4+)",
      "test": "Add NaOH and warm — smell of ammonia → NH₄⁺",
      "elements": ["NH₄⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
    {
      "name": "Group I (Ag+, Pb2+)",
      "test": "Add HCl — white precipitate indicates chlorides of Ag⁺ or Pb²⁺",
      "elements": ["Ag⁺", "Pb²⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
    {
      "name": "Group II (Cu2+, Cd2+)",
      "test": "Pass H₂S in acidic medium — colored sulfide precipitate.",
      "elements": ["Cu²⁺", "Cd²⁺", "Bi³⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
    {
      "name": "Group III (Fe3+, Al3+)",
      "test": "Add NH₄OH — brown/white precipitate indicates Fe³⁺ or Al³⁺.",
      "elements": ["Fe³⁺", "Al³⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
    {
      "name": "Group IV (Ca2+, Sr2+, Ba2+)",
      "test": "Add (NH₄)₂CO₃ — white precipitate indicates Group IV cations.",
      "elements": ["Ca²⁺", "Sr²⁺", "Ba²⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
    {
      "name": "Group V (Mg2+, Ni2+)",
      "test": "Add NaOH — green precipitate indicates Ni²⁺; white → Mg²⁺.",
      "elements": ["Mg²⁺", "Ni²⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
    {
      "name": "Group VI (K+, Na+)",
      "test": "Flame test — violet/orange flame indicates K⁺ or Na⁺.",
      "elements": ["K⁺", "Na⁺"],
      "present": null,
      "confirmed": <String, bool>{}
    },
  ];

  int currentStep = 0;
  List<String> confirmedElements = [];

  // Helper: rebuild global confirmed list
  void updateConfirmedList() {
    confirmedElements.clear();
    for (final g in groups) {
      g["confirmed"].forEach((element, value) {
        if (value == true) confirmedElements.add(element);
      });
    }
  }

  void markGroup(int index, bool present) async {
    setState(() {
      groups[index]["present"] = present;
    });

    if (present) {
      await Future.delayed(const Duration(milliseconds: 150));
      showConfirmDialog(index);
    }
  }

  void showConfirmDialog(int groupIndex) {
    final group = groups[groupIndex];
    Map<String, bool> localConfirm = Map.from(group["confirmed"]);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(builder: (ctx2, setDialog) {
        void toggle(String element, bool newVal) {
          if (!localConfirm[element]! && newVal) {
            if (confirmedElements.length >= 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Only 2 cations can be confirmed.")),
              );
              return;
            }
          }
          setDialog(() {
            localConfirm[element] = newVal;
          });
        }

        return AlertDialog(
          title: Text("${group["name"]} - Confirmatory Tests"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group["test"]),
                const SizedBox(height: 10),
                ...group["elements"].map<Widget>((e) {
                  final confirmed = localConfirm[e] ?? false;
                  return ListTile(
                    title: Text(e),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  confirmed ? Colors.green : Colors.blueGrey),
                          onPressed: () => toggle(e, true),
                          child: const Text("Confirm"),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => toggle(e, false),
                          child: const Text("Not"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx2),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply changes
                setState(() {
                  group["confirmed"] = localConfirm;
                  updateConfirmedList();
                });
                Navigator.pop(ctx2);
              },
              child: const Text("Save"),
            )
          ],
        );
      }),
    );
  }

  void finishTest() {
    updateConfirmedList();
    if (confirmedElements.length < 2) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Incomplete Test"),
          content: const Text("Confirm at least 2 cations before finishing."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Final Result"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Confirmed Cations:"),
            const SizedBox(height: 10),
            ...confirmedElements.map((e) => ListTile(
                  leading:
                      const Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(e),
                )),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = groups[currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wet Test — Salt A"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(
                    "Step ${currentStep + 1}/${groups.length}: ${group["name"]}"),
                trailing: ElevatedButton(
                  onPressed: osPrepared
                      ? null
                      : () => setState(() => osPrepared = true),
                  child: Text(osPrepared ? "O.S. Prepared" : "Prepare O.S."),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView(
                    children: [
                      Text(group["test"],
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text("Present"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: group["present"] == true
                                  ? Colors.green
                                  : null,
                            ),
                            onPressed: () => markGroup(currentStep, true),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.close),
                            label: const Text("Absent"),
                            onPressed: () => setState(() {
                              group["present"] = false;
                              group["confirmed"]
                                  .updateAll((key, value) => false);
                              updateConfirmedList();
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (group["present"] == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Cations in this group:",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            ...group["elements"].map<Widget>((e) {
                              final confirmed = group["confirmed"][e] ?? false;
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  confirmed
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: confirmed ? Colors.green : Colors.grey,
                                ),
                                title: Text(e),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => showConfirmDialog(currentStep),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: currentStep > 0
                      ? () => setState(() => currentStep--)
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Previous"),
                ),
                TextButton.icon(
                  onPressed: currentStep < groups.length - 1
                      ? () => setState(() => currentStep++)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next"),
                ),
                ElevatedButton(
                  onPressed: osPrepared ? finishTest : null,
                  child: const Text("Finish"),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(),
            Text("Confirmed Elements: ${confirmedElements.join(", ")}"),
          ],
        ),
      ),
    );
  }
}
