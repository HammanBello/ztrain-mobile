import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/app_product_manager.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/routing/app_router.dart';
import 'package:shop_app/screens/sign_in/auth.dart';
import 'package:shop_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(ZTrain());
}

class ZTrain extends StatefulWidget {
  const ZTrain({Key key}) : super(key: key);

  @override
  _ZTrainState createState() => _ZTrainState();
}

class _ZTrainState extends State<ZTrain> {
  final _appStateManager = AppStateManager();
  final _appProductManager = AppProductManager();
  AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
        appStateManager: _appStateManager,
        appProductManager: _appProductManager);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Auth>(
            create: (_) => Auth(),
            lazy: false,
          ),
          Provider(
            create: (test) => ProductDAO(),
            lazy: true,
          ),
          ChangeNotifierProvider.value(value: _appStateManager),
          ChangeNotifierProvider.value(value: _appProductManager)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZTrain',
          theme: theme(),
          home: Router(
            routerDelegate: _appRouter,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        ));
  }
}
