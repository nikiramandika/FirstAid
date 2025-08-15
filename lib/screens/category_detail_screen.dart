import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/first_aid_data.dart';
import '../services/database_helper.dart';
import 'detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String category;

  const CategoryDetailScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<FirstAidData> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryItems();
  }

  Future<void> _loadCategoryItems() async {
    try {
      final data = await _databaseHelper.getDataByCategory(widget.category);
      setState(() {
        items = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pendarahan':
        return const Color(0xFFE53E3E); // Red
      case 'Tulang dan Otot':
        return const Color(0xFF38B2AC); // Teal
      case 'Luka Bakar':
        return const Color(0xFF3182CE); // Blue
      case 'Cedera Kepala':
        return const Color(0xFF6B46C1); // Purple
      case 'Keracunan':
        return const Color(0xFFDD6B20); // Orange
      case 'Kejang':
        return const Color(0xFF319795); // Teal
      default:
        return const Color(0xFF3182CE);
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade400;
      case 2:
        return Colors.orange.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Darurat';
      case 2:
        return 'Sedang';
      default:
        return 'Ringan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: _getCategoryColor(widget.category),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(widget.category),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${items.length} Panduan Tersedia',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih item untuk melihat panduan lengkap',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildItemCard(item);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildItemCard(FirstAidData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(item: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(item.priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getPriorityText(item.priority),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _getPriorityColor(item.priority),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tap untuk detail lengkap',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
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
} 