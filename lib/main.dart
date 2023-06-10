import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider_start/core/localization/localization.dart';
import 'package:provider_start/core/managers/core_manager.dart';
import 'package:provider_start/locator.dart';
import 'package:provider_start/logger.dart';
import 'package:provider_start/provider_setup.dart';
import 'package:provider_start/ui/router.dart';
import 'package:provider_start/ui/shared/themes.dart' as themes;
import 'package:provider_start/local_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogger();
  await setupLocator();
  runApp(MyApp());
  // runZoned(
  //   () => runApp(MyApp()),
  //   onError: (e) {
  //     // Log to crashlytics
  //   },
  // );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appRouter = locator<AppRouter>();

    return MultiProvider(
      providers: providers,
      child: CoreManager(
        child: PlatformProvider(
          settings: PlatformSettingsData(
              platformStyle: PlatformStyleData(web: PlatformStyle.Cupertino)),
          builder: (context) => PlatformApp.router(
            routerDelegate: appRouter.delegate(),
            routeInformationParser: appRouter.defaultRouteParser(),
            debugShowCheckedModeBanner: false,
            material: (_, __) => MaterialAppRouterData(
              theme: themes.primaryMaterialTheme,
              darkTheme: themes.darkMaterialTheme,
            ),
            cupertino: (_, __) => CupertinoAppRouterData(
              theme: themes.primaryCupertinoTheme,
            ),
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
            localeResolutionCallback: loadSupportedLocals,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
          ),
        ),
      ),
    );
  }
}
