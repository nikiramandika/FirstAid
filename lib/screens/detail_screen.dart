import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/first_aid_data.dart';

class DetailScreen extends StatelessWidget {
  final FirstAidData item;

  const DetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          item.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForCategory(item.category),
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.category,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(item.priority).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getPriorityText(item.priority),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getPriorityColor(item.priority),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryIllustration(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    'Deskripsi',
                    item.description,
                    Icons.info_outline,
                    Colors.blue.shade400,
                  ),
                  const SizedBox(height: 24),
                  if (item.symptoms.isNotEmpty)
                    _buildInfoSection(
                      'Gejala',
                      item.symptoms,
                      Icons.medical_services,
                      Colors.orange.shade400,
                    ),
                  if (item.symptoms.isNotEmpty) const SizedBox(height: 24),
                  _buildInfoSection(
                    'Penanganan',
                    item.treatment,
                    Icons.healing,
                    Colors.green.shade400,
                  ),
                  const SizedBox(height: 16),
                  _buildVideoTutorialCard(
                    context: context,
                    title: 'Video Tutorial Penanganan',
                    subtitle: 'Tata cara penanganan yang direkomendasikan',
                    // Ganti URL ini dengan link video yang relevan (YouTube/Vimeo/etc)
                    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                    accentColor: Colors.green.shade400,
                  ),
                  const SizedBox(height: 24),
                  if (item.warnings.isNotEmpty)
                    _buildInfoSection(
                      'Peringatan',
                      item.warnings,
                      Icons.warning,
                      Colors.red.shade400,
                    ),
                  const SizedBox(height: 24),
                  _buildEmergencyContact(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.emergency,
                  color: Colors.red.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Kontak Darurat',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'PHC 119',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Layanan Ambulans & Darurat',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.red.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle emergency call
                  },
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: Text(
                    'Hubungi Sekarang',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIllustration(BuildContext context) {
    const String illustrationAsset = 'assets/images/category_illustration_placeholder.png';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.asset(
            illustrationAsset,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tambahkan ilustrasi kategori (HD)',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getCategoryColor(item.category).withValues(alpha: 0.05),
                    _getCategoryColor(item.category).withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTutorialCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String videoUrl,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.ondemand_video,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  // Placeholder thumbnail area (bisa diganti dengan NetworkImage thumbnail YouTube)
                  Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: accentColor,
                        size: 64,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await _openVideoUrl(videoUrl);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  videoUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  await _openVideoUrl(videoUrl);
                },
                icon: Icon(Icons.open_in_new, color: accentColor, size: 18),
                label: Text(
                  'Buka',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openVideoUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Pendarahan':
        return Icons.bloodtype;
      case 'Tulang dan Otot':
        return Icons.accessibility;
      case 'Luka Bakar':
        return Icons.local_fire_department;
      case 'Cedera Kepala':
        return Icons.psychology;
      case 'Keracunan':
        return Icons.warning;
      case 'Kejang':
        return Icons.flash_on;
      default:
        return Icons.medical_services;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pendarahan':
        return const Color(0xFFE53E3E);
      case 'Tulang dan Otot':
        return const Color(0xFF38B2AC);
      case 'Luka Bakar':
        return const Color(0xFF3182CE);
      case 'Cedera Kepala':
        return const Color(0xFF6B46C1);
      case 'Keracunan':
        return const Color(0xFFDD6B20);
      case 'Kejang':
        return const Color(0xFF319795);
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
} 