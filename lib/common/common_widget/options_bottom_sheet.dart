import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  OptionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class CustomOptionsBottomSheet extends StatelessWidget {
  final List<OptionItem> options;
  final String? title;

  const CustomOptionsBottomSheet({
    super.key, 
    required this.options,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fun drag handle
          Center(
            child: Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          
          // Title (optional) with fun style
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                title!,
                style: GoogleFonts.comicNeue(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.blue[800],
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
          ],
          
          // Options list with more playful design
          ...options.map((option) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  option.onTap();
                },
                splashColor: option.color.withOpacity(0.2),
                highlightColor: option.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: option.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: option.color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          option.icon, 
                          color: option.color, 
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option.label,
                          style: GoogleFonts.comicNeue(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.blue[900],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          // Fun cancel button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.blue[900],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}