import 'package:appleickle_browser/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/app_theme_model.dart';
import 'models/browser_model.dart';
import 'models/webview_model.dart';
import 'utils/routes/routes_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        // 提供主题全局变量
        Provider<AppThemeModel>(
          create: (_) => AppThemeModel(),
        ),
        ChangeNotifierProvider<WebViewModel>(
          create: (context) {
            loggerNoStack.d('创建 WebViewModel');
            return WebViewModel();
          },
        ),
        ChangeNotifierProxyProvider<WebViewModel, BrowserModel>(
          update: (context, webViewModel, browserModel) {
            // loggerNoStack.d(
            //     '更新 BrowserModel 的 webViewModel: {tabIndex: ${webViewModel.tabIndex}, url: ${webViewModel.url}}');
            browserModel!.setCurrentWebViewModel(webViewModel);
            return browserModel;
          },
          create: (BuildContext context) {
            loggerNoStack.d('创建 BrowserModel');
            return BrowserModel(null);
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Appleickle Browser',
            debugShowCheckedModeBanner: true,
            theme:
                Provider.of<AppThemeModel>(context, listen: true).materialTheme,
            // theme: ThemeData.dark(),
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
