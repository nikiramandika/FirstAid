import 'package:flutter/material.dart';
import '../widgets/bleeding_category_card.dart';
import '../models/bleeding_category.dart';
import 'severe_bleeding_screen.dart';
import 'minor_bleeding_screen.dart';

class BleedingScreen extends StatelessWidget {
  const BleedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bleedingCategories = [
      const BleedingCategory(
        title: 'Pendarahan Parah',
        description: 'Pendarahan yang memerlukan perhatian medis segera',
        icon: Icons.bloodtype,
        color: Color(0xFFE53E3E),
        route: SevereBleedingScreen(),
      ),
      const BleedingCategory(
        title: 'Pendarahan Kecil',
        description: 'Pendarahan ringan yang dapat ditangani sendiri',
        icon: Icons.healing,
        color: Color(0xFFF56565),
        route: MinorBleedingScreen(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE53E3E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Back Button and Title
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Pendarahan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Main Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Section Title
                    const Text(
                      'Pendarahan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Description
                    const Text(
                      'Masalah kesehatan terkait pendarahan dan luka',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Categories Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Categories List
                    Expanded(
                      child: ListView.builder(
                        itemCount: bleedingCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: BleedingCategoryCard(
                              category: bleedingCategories[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 