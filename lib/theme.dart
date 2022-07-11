import 'package:flex_color_scheme/flex_color_scheme.dart';

var darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blueWhale,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.95,
    appBarElevation: 0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: false,
    darkIsTrueBlack: false,
    // useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use playground font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: true,
      interactionEffects: true,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 0.95,
      navigationBarOpacity: 0.95,
      navigationBarMutedUnselectedLabel: true,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
    ));
