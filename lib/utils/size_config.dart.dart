import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;

    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print('[WIDTH] : $_screenWidth  || [HEIGHT] : $_screenHeight');
  }
}

class Width {
  static double multiplier = SizeConfig.widthMultiplier;

  static double w2 = 0.49 * multiplier;
  static double w4 = 0.97 * multiplier;
  static double w6 = 1.46 * multiplier;
  static double w8 = 1.94 * multiplier;
  static double w10 = 2.43 * multiplier;
  static double w12 = 2.92 * multiplier;
  static double w14 = 3.40 * multiplier;
  static double w16 = 3.89 * multiplier;
  static double w18 = 4.37 * multiplier;
  static double w20 = 4.86 * multiplier;
  static double w22 = 5.35 * multiplier;
  static double w24 = 5.83 * multiplier;
  static double w26 = 6.32 * multiplier;
  static double w28 = 6.81 * multiplier;
  static double w30 = 7.29 * multiplier;
  static double w32 = 7.78 * multiplier;
  static double w34 = 8.26 * multiplier;
  static double w36 = 8.75 * multiplier;
  static double w38 = 9.24 * multiplier;
  static double w40 = 9.72 * multiplier;
  static double w42 = 10.21 * multiplier;
  static double w44 = 10.69 * multiplier;
  static double w46 = 11.18 * multiplier;
  static double w48 = 11.67 * multiplier;
  static double w50 = 12.15 * multiplier;
  static double w52 = 12.64 * multiplier;
  static double w54 = 13.12 * multiplier;
  static double w56 = 13.61 * multiplier;
  static double w58 = 14.10 * multiplier;
  static double w60 = 14.58 * multiplier;
  static double w62 = 15.07 * multiplier;
  static double w64 = 15.56 * multiplier;
  static double w66 = 16.04 * multiplier;
  static double w68 = 16.53 * multiplier;
  static double w70 = 17.01 * multiplier;
  static double w72 = 17.50 * multiplier;
  static double w74 = 17.99 * multiplier;
  static double w76 = 18.47 * multiplier;
  static double w78 = 18.96 * multiplier;
  static double w80 = 19.44 * multiplier;
  static double w90 = 21.88 * multiplier;
  static double w100 = 24.31 * multiplier;
  static double w110 = 26.74 * multiplier;
  static double w120 = 29.17 * multiplier;
  static double w130 = 31.60 * multiplier;
  static double w140 = 34.03 * multiplier;
  static double w150 = 36.46 * multiplier;
  static double w160 = 38.89 * multiplier;
  static double w170 = 41.32 * multiplier;
  static double w180 = 43.75 * multiplier;
  static double w190 = 46.18 * multiplier;
  static double w200 = 48.61 * multiplier;
}

class Height {
  static double multiplier = SizeConfig.heightMultiplier;

  static double h2 = 0.24 * multiplier;
  static double h4 = 0.49 * multiplier;
  static double h6 = 0.73 * multiplier;
  static double h8 = 0.97 * multiplier;
  static double h10 = 1.22 * multiplier;
  static double h12 = 1.46 * multiplier;
  static double h14 = 1.71 * multiplier;
  static double h16 = 1.95 * multiplier;
  static double h18 = 2.19 * multiplier;
  static double h20 = 2.44 * multiplier;
  static double h22 = 2.68 * multiplier;
  static double h24 = 2.92 * multiplier;
  static double h26 = 3.17 * multiplier;
  static double h28 = 3.41 * multiplier;
  static double h30 = 3.66 * multiplier;
  static double h32 = 3.90 * multiplier;
  static double h34 = 4.14 * multiplier;
  static double h36 = 4.39 * multiplier;
  static double h38 = 4.63 * multiplier;
  static double h40 = 4.87 * multiplier;
  static double h42 = 5.12 * multiplier;
  static double h44 = 5.36 * multiplier;
  static double h46 = 5.61 * multiplier;
  static double h48 = 5.85 * multiplier;
  static double h50 = 6.09 * multiplier;
  static double h52 = 6.34 * multiplier;
  static double h54 = 6.58 * multiplier;
  static double h56 = 6.82 * multiplier;
  static double h58 = 7.07 * multiplier;
  static double h60 = 7.31 * multiplier;
  static double h62 = 7.56 * multiplier;
  static double h64 = 7.80 * multiplier;
  static double h66 = 8.04 * multiplier;
  static double h68 = 8.29 * multiplier;
  static double h70 = 8.53 * multiplier;
  static double h72 = 8.77 * multiplier;
  static double h74 = 9.02 * multiplier;
  static double h76 = 9.26 * multiplier;
  static double h78 = 9.51 * multiplier;
  static double h80 = 9.75 * multiplier;
  static double h90 = 10.97 * multiplier;
  static double h100 = 12.19 * multiplier;
  static double h110 = 13.41 * multiplier;
  static double h120 = 14.62 * multiplier;
  static double h130 = 15.84 * multiplier;
  static double h140 = 17.06 * multiplier;
  static double h150 = 18.28 * multiplier;
  static double h160 = 19.50 * multiplier;
  static double h170 = 20.71 * multiplier;
  static double h180 = 21.94 * multiplier;
  static double h190 = 23.15 * multiplier;
  static double h200 = 24.37 * multiplier;
}

class Font {
  static double multiplier = SizeConfig.textMultiplier;

  static double f10 = 1.22 * multiplier;
  static double f12 = 1.46 * multiplier;
  static double f14 = 1.71 * multiplier;
  static double f16 = 1.95 * multiplier;
  static double f18 = 2.19 * multiplier;
  static double f20 = 2.44 * multiplier;
  static double f22 = 2.68 * multiplier;
  static double f24 = 2.92 * multiplier;
  static double f26 = 3.17 * multiplier;
  static double f28 = 3.41 * multiplier;
  static double f30 = 3.65 * multiplier;
}
