import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/recent_tab.dart';
import 'tabs/tools_tab.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdfaireader/widgets/db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  String? _selectedFileName;
  String? _selectedFileMeta;
  String? _selectedFilePath;
  int? _initialToolIndex;
  List<Map<String, String>> _recentFiles = [];

  @override
  void initState() {
    super.initState();
    _loadRecentFiles();
  }

  Future<void> _loadRecentFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? filesJson = prefs.getString('recent_files_list');
      if (filesJson != null) {
        final List<dynamic> decoded = jsonDecode(filesJson);
        setState(() {
          _recentFiles = decoded.map((item) => Map<String, String>.from(item)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading recent files: $e');
    }
  }

  Future<void> _saveRecentFile(String name, String meta, String path) async {
    try {
      _recentFiles.removeWhere((file) => file['path'] == path);
      _recentFiles.insert(0, {
        'name': name,
        'meta': meta,
        'path': path,
        'time': 'common.just_now'.tr(),
      });

      if (_recentFiles.length > 10) {
        _recentFiles = _recentFiles.sublist(0, 10);
      }

      setState(() {});

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('recent_files_list', jsonEncode(_recentFiles));
    } catch (e) {
      debugPrint('Error saving recent file: $e');
    }
  }

  Future<void> _deleteRecentFile(String path) async {
    try {
      setState(() {
        _recentFiles.removeWhere((file) => file['path'] == path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('recent_files_list', jsonEncode(_recentFiles));
    } catch (e) {
      debugPrint('Error deleting recent file: $e');
    }
  }

  void _navigateToTools(int toolIndex) {
    setState(() {
      _selectedIndex = 2;
      _initialToolIndex = toolIndex;
    });
  }

  void _selectFile(String name, String meta, {String? path}) {
    setState(() {
      _selectedFileName = name;
      _selectedFileMeta = meta;
      _selectedFilePath = path;
    });
    if (path != null) {
      _saveRecentFile(name, meta, path);
    }
  }

  Future<void> _pickPdfFile(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final path = file.path!;
        final name = file.name;
        final sizeInBytes = file.size;

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          DbService.logFileUpload(
            firebaseUid: currentUser.uid,
            fileName: name,
            fileSize: sizeInBytes,
          );
        }

        // Calculate human readable size
        String sizeStr;
        if (sizeInBytes >= 1024 * 1024) {
          sizeStr = '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
        } else {
          sizeStr = '${(sizeInBytes / 1024).toStringAsFixed(0)} KB';
        }

        // Estimate pages
        int pages = 1;
        try {
          final pdfFile = File(path);
          final bytes = await pdfFile.readAsBytes();
          final content = String.fromCharCodes(bytes);
          pages = RegExp(r'/Type\s*/Page\b').allMatches(content).length;
          if (pages == 0) {
            final countMatch = RegExp(r'/Count\s+(\d+)').firstMatch(content);
            if (countMatch != null) {
              pages = int.tryParse(countMatch.group(1) ?? '1') ?? 1;
            }
          }
          if (pages == 0) pages = 1;
        } catch (e) {
          debugPrint('Error estimating pages: $e');
        }

        final meta = '$sizeStr · $pages sayfa';
        _selectFile(name, meta, path: path);

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('home.upload_success'.tr(args: [name])),
            backgroundColor: const Color(0xFF34C759),
          ),
        );
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('common.error'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context, Size size) {
    switch (_selectedIndex) {
      case 0:
        return DashboardTab(
          size: size,
          selectedFileName: _selectedFileName,
          selectedFileMeta: _selectedFileMeta,
          onUploadTap: () => _pickPdfFile(context),
          onFileSelected: (name, meta, path) => _selectFile(name, meta, path: path),
          onDeleteFile: _deleteRecentFile,
          recentFiles: _recentFiles,
          onSeeAllClicked: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
          onToolSelected: _navigateToTools,
        );
      case 1:
        return RecentTab(
          searchController: _searchController,
          recentFiles: _recentFiles,
          onFileSelected: (name, meta, path) {
            _selectFile(name, meta, path: path);
          },
          onDeleteFile: _deleteRecentFile,
        );
      case 2:
        return ToolsTab(
          selectedFileName: _selectedFileName,
          selectedFileMeta: _selectedFileMeta,
          selectedFilePath: _selectedFilePath,
          onUploadTap: () => _pickPdfFile(context),
          onFileSelected: _selectFile,
          initialToolIndex: _initialToolIndex,
        );
      default:
        return DashboardTab(
          size: size,
          selectedFileName: _selectedFileName,
          selectedFileMeta: _selectedFileMeta,
          onUploadTap: () => _pickPdfFile(context),
          onFileSelected: (name, meta, path) => _selectFile(name, meta, path: path),
          onDeleteFile: _deleteRecentFile,
          recentFiles: _recentFiles,
          onSeeAllClicked: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
          onToolSelected: _navigateToTools,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on locale change
    final size = MediaQuery.of(context).size;

    // Set system status bar style to match the theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF050E22),
      body: Stack(
        children: [
          // Background Gradient Layer
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.3),
                  radius: 0.7,
                  colors: [
                    Color(0x1A83E0FB), // Match splash screen glow exactly
                    Color(0x00000000),
                  ],
                ),
              ),
            ),
          ),

          // Main Layout Content (Frame 1)
          SafeArea(
            child: _buildBody(context, size),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 72 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: const Color(0xFF050E22),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(
              context,
              iconPath: 'assets/images/home_icon.svg',
              label: 'home.nav_home'.tr(),
              index: 0,
            ),
            _buildBottomNavItem(
              context,
              iconPath: 'assets/images/recent_icon.svg',
              label: 'home.nav_recent'.tr(),
              index: 1,
            ),
            _buildBottomNavItem(
              context,
              iconPath: 'assets/images/tools_icon.svg',
              label: 'home.nav_tools'.tr(),
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context, {
    required String iconPath,
    required String label,
    required int index,
  }) {
    final isActive = _selectedIndex == index;
    final color = isActive ? Colors.white : Colors.white.withValues(alpha: 0.5);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.getFont(
              'Inter',
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 18.0 / 12.0,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
