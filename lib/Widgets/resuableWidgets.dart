import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


//itemSearch bars used for searching found and lost items 
class ItemSearchBar extends StatelessWidget {
  
   final String hintText;
  const ItemSearchBar({super.key, required this.hintText});

 
  // Builds the rounded border; only the color changes between states.
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context ) {
    return TextField(
      style: const TextStyle(color: AppColors.textPrimary),
      cursorColor: AppColors.primaryLight,
      onChanged: (query) {
        // TODO(backend): search lost/found items using [query]
        // (consider a debounce to avoid calling the API on every keystroke).
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: _border(AppColors.surfaceBorder),
        focusedBorder: _border(AppColors.primaryLight),
      ),
    );
  }
}
