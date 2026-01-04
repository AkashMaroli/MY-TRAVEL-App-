
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travelapp/viewmodel/splash_screen_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => SplashViewModel()),
    // ChangeNotifierProvider(create: (_) => LoginViewModel()),
    // ChangeNotifierProvider(create: (_) => HomeViewModel()),
    // ChangeNotifierProvider(create: (_) => ProfileViewModel()),
  ];
}
