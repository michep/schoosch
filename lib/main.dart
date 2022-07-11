import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/firebase_options.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/class_selection_page.dart';
import 'package:schoosch/pages/disconnected_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:schoosch/widgets/utils.dart';

import 'model/person_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  var fstore = FStore();
  var bcont = BlueprintController();
  Get.put<FAuth>(fauth);
  Get.put<FStore>(fstore);
  Get.put(CurrentWeek(Week.current()));
  Get.put<BlueprintController>(bcont);
  if (fauth.currentUser != null) {
    await fstore.init(fauth.currentUser!.email!);
    // await bcont.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Utils.progressIndicator(),
            );
          }
          if (snapshot.data! == ConnectivityResult.none) {
            Get.off(() => const DisconnectedPage());
          }
          return GetMaterialApp(
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            // locale: const Locale('ru'),
            scrollBehavior: AppScrollBehavior(),
            onGenerateTitle: (context) => S.of(context).appTiile,
            debugShowCheckedModeBanner: false,
            theme: FlexThemeData.dark(
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
              ),
            ),
            home: _homePageSelector(),
          );
        });
  }

  Widget _homePageSelector() {
    if (PersonModel.currentUser == null) return const LoginPage();
    if (PersonModel.currentUser!.currentType == PersonType.admin) return const AdminPage();
    if (PersonModel.currentUser!.currentType == PersonType.observer) return ObserverClassSelectionPage(PersonModel.currentUser!.asObserver!);

    return const HomePage();
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
