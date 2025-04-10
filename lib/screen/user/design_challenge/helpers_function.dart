
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ------------------ Helper Functions ------------------


// Returns the contrast ratio between two colors
double getContrastRatio(Color a, Color b) {
  double lumA = a.computeLuminance();
  double lumB = b.computeLuminance();
  double brightest = math.max(lumA, lumB);
  double darkest = math.min(lumA, lumB);
  return (brightest + 0.05) / (darkest + 0.05);
}

// Returns whether two colors are "close" in hue (within threshold degrees)
bool isColorClose(Color a, Color b, double threshold) {
  HSVColor hsvA = HSVColor.fromColor(a);
  HSVColor hsvB = HSVColor.fromColor(b);
  double diff = (hsvA.hue - hsvB.hue).abs();
  if (diff > 180) diff = 360 - diff;
  return diff < threshold;
}

// Color picker dialog helper
Future<Color?> showColorPickerDialog(
    BuildContext context, Color initialColor) async {
  Color tempColor = initialColor;
  return await showDialog<Color>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          "Pick a color",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              tempColor = color;
            },
            showLabel: true,
            pickerAreaBorderRadius: BorderRadius.circular(8),
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            displayThumbColor: true,
            enableAlpha: false,
            portraitOnly: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(context).pop(tempColor);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}
