import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qadaa/generated/l10n.dart';
import 'package:qadaa/src/core/extensions/extension_platform.dart';
import 'package:qadaa/src/core/managers/storage_repo.dart';
import 'package:qadaa/src/core/shared/loading.dart';
import 'package:qadaa/src/core/utils/print.dart';
import 'package:qadaa/src/features/dashboard/presentation/screens/app_dashboard.dart';
import 'package:qadaa/src/features/ui/presentation/components/desktop_window_wrapper.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isFirstOpen = false;
  @override
  void initState() {
    super.initState();
    checkIfFirstOpen();
    setState(() {
      isLoading = false;
    });
  }

  void checkIfFirstOpen() {
    try {
      isFirstOpen = storageRepo.isFirstOpen();
    } catch (e) {
      qadaaPrint(e);
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : GetMaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (BuildContext context) => S.of(context).qadaa,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.pink,
              fontFamily: "Cairo",
            ),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: storageRepo.locale,
            supportedLocales: S.delegate.supportedLocales,
            builder: (context, child) {
              if (PlatformExtension.isDesktop) {
                return DesktopWindowWrapper(
                  child: child,
                );
              }
              return child ?? const SizedBox();
            },
            home: () {
              return const AppDashboard();
              // return isFirstOpen
              //     ? const OnBoardingPage()
              //     : const AppDashboard();
            }(),
          );
  }
}
