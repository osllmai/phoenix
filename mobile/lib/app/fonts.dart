import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Map<String, String> kFontOptions = {
  'DM Sans': 'DMSans',
  'Inter': 'Inter',
  'Lora': 'Lora',
  'Merriweather': 'Merriweather',
  'Playfair Display': 'PlayfairDisplay',
  'OpenDyslexic': 'OpenDyslexic',
};

const Set<String> kBundledFonts = {
  'DMSans',
  'Inter',
  'Lora',
  'Merriweather',
  'PlayfairDisplay',
  'OpenDyslexic',
};

const List<String> kPopularGoogleFonts = [
  'Roboto',
  'Poppins',
  'Montserrat',
  'Nunito',
  'Open Sans',
  'Source Sans 3',
  'Raleway',
  'Work Sans',
  'Rubik',
  'Karla',
  'Inter Tight',
  'Manrope',
  'Space Grotesk',
  'IBM Plex Sans',
  'Figtree',
  'Outfit',
  'Sora',
  'Lexend',
  'Mulish',
  'Noto Sans',
  'PT Sans',
  'Quicksand',
  'Cabin',
  'Josefin Sans',
];

bool isBundledFont(String family) => kBundledFonts.contains(family);

TextTheme applyFontFamily(TextTheme base, String family) {
  if (isBundledFont(family)) {
    return base.apply(fontFamily: family);
  }
  try {
    return GoogleFonts.getTextTheme(family, base);
  } catch (_) {
    return base.apply(fontFamily: 'DMSans');
  }
}
