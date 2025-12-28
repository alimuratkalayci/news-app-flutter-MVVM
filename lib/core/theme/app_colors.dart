import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation
  
  // Modern Minimalist Color Palette
  static const Color primary = Color(0xFF1A1A1A); // Almost black
  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color accent = Color(0xFF8B5CF6); // Purple
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA); // Light gray-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280); // Gray
  static const Color textTertiary = Color(0xFF9CA3AF); // Light gray
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Border & Divider
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Overlay
  static const Color overlay = Color(0x0D000000); // 5% black overlay
}
