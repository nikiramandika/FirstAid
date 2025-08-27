import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_helper.dart';
import 'category_detail_screen.dart';
import 'search_screen.dart';
import '../services/remote_service.dart';
import '../config/remote_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<String> categories = [];
  bool isLoading = true;

  // Mapping dari Supabase categories (jika tersedia)
  final Map<String, IconData> _categoryIcons = {};
  final Map<String, Color> _categoryColors = {};

  @override
  void initState() {
    super.initState();
    _initialize();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _initialize() async {
    await _syncFromSupabase();
    // Coba ambil kategori dari Supabase; jika gagal/0 pakai lokal
    final loadedRemote = await _loadRemoteCategories();
    if (!loadedRemote) {
      await _loadCategories();
    }
  }

  Future<void> _syncFromSupabase() async {
    try {
      // Skip sync if Supabase is not configured yet
      if (supabaseRestUrl.contains('YOUR_PROJECT') ||
          supabaseAnonKey == 'YOUR_ANON_PUBLIC_KEY') {
        return;
      }
      final remote = RemoteService();
      final list = await remote.fetchAll();
      if (list.isNotEmpty) {
        await _databaseHelper.replaceAll(list);
      } else {
        // Keep existing local data if remote returns empty (e.g., due to RLS)
        // debug: print message to help diagnose
        // ignore: avoid_print
        print('Supabase returned 0 rows; skipped replacing local DB');
      }
    } catch (e) {
      // Ignore sync errors for now; app still works with local data
      // ignore: avoid_print
      print('Sync error: $e');
    }
  }

  Future<bool> _loadRemoteCategories() async {
    try {
      // Jika Supabase belum dikonfigurasi, lewati
      if (supabaseRestUrl.contains('YOUR_PROJECT') || supabaseAnonKey == 'YOUR_ANON_PUBLIC_KEY') {
        return false;
      }
      final remote = RemoteService();
      final list = await remote.fetchCategories();
      if (list.isEmpty) {
        return false;
      }

      final List<String> names = [];
      final Map<String, IconData> icons = {};
      final Map<String, Color> colors = {};

      for (final Map<String, dynamic> row in list) {
        final String name = (row['name'] ?? '').toString();
        if (name.isEmpty) continue;
        names.add(name);
        final String? iconName = row['iconName']?.toString();
        final String? colorStr = row['color']?.toString();
        icons[name] = _iconFromName(iconName);
        colors[name] = _colorFromString(colorStr) ?? _getDefaultCategoryColor(name);
      }

      if (names.isEmpty) return false;

      setState(() {
        categories = names;
        _categoryIcons
          ..clear()
          ..addAll(icons);
        _categoryColors
          ..clear()
          ..addAll(colors);
        isLoading = false;
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Load remote categories failed: $e');
      return false;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await _databaseHelper.getAllCategories();
      setState(() {
        categories = cats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Konversi string iconName -> IconData dengan fallback
  IconData _iconFromName(String? iconName) {
    final String key = (iconName ?? '').trim().toLowerCase();
    switch (key) {
      case 'accessibility':
        return Icons.accessibility;
      case 'bloodtype':
        return Icons.bloodtype;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'psychology':
        return Icons.psychology;
      case 'warning':
        return Icons.warning;
      case 'flash_on':
        return Icons.flash_on;
      case 'medical_services':
        return Icons.medical_services;
      case 'healing':
        return Icons.healing;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'vaccines':
        return Icons.vaccines;
      case 'sick':
        return Icons.sick;
      default:
        return Icons.medical_services;
    }
  }

  // Parse color string (#RRGGBB, RRGGBB, #AARRGGBB, AARRGGBB) -> Color
  Color? _colorFromString(String? value) {
    if (value == null) return null;
    var v = value.trim();
    if (v.isEmpty) return null;
    // Hapus prefix seperti # atau 0x
    v = v.replaceAll('#', '').replaceAll('0x', '').replaceAll('0X', '');
    if (v.length == 6) {
      v = 'FF$v';
    }
    if (v.length != 8) return null;
    try {
      final intColor = int.parse(v, radix: 16);
      return Color(intColor << 0);
    } catch (_) {
      return null;
    }
  }

  Color _getCategoryColor(String category) {
    // Gunakan warna dari Supabase jika ada
    final Color? mapped = _categoryColors[category];
    if (mapped != null) return mapped;
    return _getDefaultCategoryColor(category);
  }

  Color _getDefaultCategoryColor(String category) {
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

  IconData _getCategoryIcon(String category) {
    // Gunakan icon dari Supabase jika ada
    final IconData? mapped = _categoryIcons[category];
    if (mapped != null) return mapped;
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

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Pendarahan':
        return 'Masalah kesehatan terkait pendarahan dan luka';
      case 'Tulang dan Otot':
        return 'Masalah kesehatan terkait tulang, otot, dan sendi';
      case 'Luka Bakar':
        return 'Masalah kesehatan terkait luka bakar';
      case 'Cedera Kepala':
        return 'Masalah kesehatan terkait cedera kepala dan otak';
      case 'Keracunan':
        return 'Masalah kesehatan terkait keracunan dan overdosis';
      case 'Kejang':
        return 'Masalah kesehatan terkait kejang dan epilepsi';
      default:
        return 'Masalah kesehatan umum';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'FirstAid',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header Section (Fixed, tidak ikut scroll)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 105,
              maxHeight: 105,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari informasi kesehatan...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (value) {
                          // No search logic here, as per edit hint
                        },
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(initialQuery: value.trim()),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cari berdasarkan gejala, kondisi, atau penanganan',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Hero Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/FirstAid.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                                  Theme.of(context).colorScheme.primary,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        'Kami akan membantu anda dalam memahami teknik pertolongan pertama dalam berbagai kondisi.',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Categories Section Header (Fixed, tidak ikut scroll)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 90,
              maxHeight: 90,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE53E3E), // Red color for variety
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Kategori',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A202C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih kategori kesehatan untuk melihat informasi lengkap',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Categories Grid (Bisa di-scroll)
          isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categories[index];
                        return _buildCategoryCard(category);
                      },
                      childCount: categories.length,
                    ),
                  ),
                ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Top colored section
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: _getCategoryColor(category),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(category),
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A202C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        _getCategoryDescription(category),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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

// Custom SliverPersistentHeaderDelegate
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
