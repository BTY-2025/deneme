import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/recent_file_row.dart';

class RecentTab extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> recentFiles;
  final Function(String name, String meta, String path) onFileSelected;
  final Function(String path) onDeleteFile;

  const RecentTab({
    super.key,
    required this.searchController,
    required this.recentFiles,
    required this.onFileSelected,
    required this.onDeleteFile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Frame 2147227774 (Header: Title + Subtitle)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'dashboard.recent_files'.tr(),
                style: GoogleFonts.getFont(
                  'Inter',
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 28.0 / 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${recentFiles.length} ${'dashboard.previously_created'.tr()}',
                style: GoogleFonts.getFont(
                  'Inter',
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 18.0 / 14.0,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24), // Gap before search bar

          // Frame 48096394 (Search Bar Container)
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Search icon
                SvgPicture.asset(
                  'assets/images/search.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: GoogleFonts.getFont(
                      'Inter',
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    decoration: InputDecoration(
                      hintText: 'dashboard.search_recent_files'.tr(),
                      hintStyle: GoogleFonts.getFont(
                        'Inter',
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Gap before files list

          // Frame 95 (List of Files)
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: searchController,
              builder: (context, val, child) {
                final query = val.text.toLowerCase().trim();
                final filteredFiles = recentFiles.where((file) {
                  final name = file['name']?.toLowerCase() ?? '';
                  return name.contains(query);
                }).toList();

                if (filteredFiles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          query.isEmpty ? Icons.folder_open_outlined : Icons.search_off_outlined,
                          color: Colors.white.withValues(alpha: 0.4),
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          query.isEmpty ? 'dashboard.no_recent_files'.tr() : 'dashboard.no_search_results'.tr(),
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredFiles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final file = filteredFiles[index];
                    final name = file['name'] ?? '';
                    final meta = file['meta'] ?? '';
                    final path = file['path'] ?? '';
                    final time = file['time'] ?? '';

                    return RecentFileRow(
                      title: name,
                      subtitle: '$meta · $time',
                      onTap: () {
                        onFileSelected(name, meta, path);
                      },
                      onDelete: () {
                        onDeleteFile(path);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
