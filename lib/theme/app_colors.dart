//to make the UI share the same colors , fonts , and styling 
//all the colors will be included here as a big class called App colors 
//same prinicple for app fonts and style
// ============================================================================
// app_colors.dart
// ----------------------------------------------------------------------------
// Single source of truth for every color used in the app.
// To re-theme the app, only edit this file.
//
// The private constructor prevents anyone from creating an instance:
// we only use the static constants (AppColors.background, ...).
// ============================================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---- Backgrounds ---------------------------------------------------------
  static const Color background = Color(0xFF16060A); // page background
  static const Color surface = Color(0xFF220A10); // cards, search bar, nav bar
  static const Color surfaceBorder = Color(0xFF4A1822); // thin card outlines
  static const Color iconTile = Color(0xFF3A1019); // square icon container
  static const Color divider = Color(0xFF3A141C); // lines between list rows

  // ---- Brand / accent ------------------------------------------------------
  static const Color primary = Color(0xFFC41E3A); // main red (FAB, avatar)
  static const Color primaryLight = Color(0xFFE0455B); // icons on dark tiles
  static const Color primaryGlow = Color(0x66C41E3A); // soft glow (40% alpha)
  static const Color accentText = Color(0xFFF07585); // "See all", section icons

  // ---- Lost / Found section accents ----------------------------------------
  static const Color lostAccent = Color(0xFFC41E3A); // strong red left strip
  static const Color foundAccent = Color(0xFFE8707F); // lighter coral left strip

  // ---- Highlighted ("live") card gradient ----------------------------------
  static const Color liveGradientStart = Color(0xFFC41E3A);
  static const Color liveGradientEnd = Color(0xFF6E0E1E);

  // ---- Text ----------------------------------------------------------------
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD9B8BD); // subtitles, hints
  static const Color textMuted = Color(0xFF9C7A80); // inactive nav, placeholders

  // ---- Buttons -------------------------------------------------------------
  static const Color buttonLight = Color(0xFFFBE9EC); // "Open" button fill
  static const Color buttonLightText = Color(0xFF4A0A14); // "Open" text

  // ---- Badges / pills ------------------------------------------------------
  static const Color badgeOnGradient = Color(0x40000000); // "Live now" pill
  static const Color badgeOnSurface = Color(0xFF3A1019); // "Enterprise" pill
  static const Color countBadge = Color(0xFF4A1A24); // item counter circle
  static const Color countBadgeText = Color(0xFFF2B8BF); // item counter number
  static const Color livePillBackground = Color(0xFF4A1018); // "Live" pill
  static const Color liveDot = Color(0xFFFF6B7D); // dot inside the live pill

  // ---- Item icon tiles (gradient squares in the lost/found lists) ----------
  static const Color itemTileStart = Color(0xFF4A1620);
  static const Color itemTileEnd = Color(0xFF2E0E15);
  static const Color itemIcon = Color(0xFFE8606F);
}