import 'package:flutter/material.dart';
import '../models/mealdetail_modal.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailsPage extends StatefulWidget {
  const MealDetailsPage({super.key});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  late int mealId;
  Mealdetail? detailed;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mealId = ModalRoute.of(context)!.settings.arguments as int;
    loadMealDetails();
  }

  void loadMealDetails() async {
    final api = ApiService();
    final data = await api.getMealDetailById(mealId.toString());
    setState(() {
      detailed = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : detailed == null
          ? const Center(child: Text("Error"))
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                detailed!.img,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              detailed!.name,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Instructions",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(detailed!.instructions,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  const Text("Ingredients",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...detailed!.ingredients
                      .map((ing) => Text("• $ing",
                      style: const TextStyle(fontSize: 16)))
                      .toList(),
                  const SizedBox(height: 30),
                  if (detailed!.link.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final url = Uri.parse(detailed!.link);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cannot open YouTube link')),
                            );
                          }
                        },
                        icon: const Icon(Icons.video_library),
                        label: const Text("Watch on YouTube"),
                      ),
                    ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
