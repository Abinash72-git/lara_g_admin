import 'package:lara_g_admin/flavours.dart';

class AppConfig {
  static const AppConfig instance = AppConfig();
  const AppConfig();
  String get baseUrl {
    switch (F.appFlavor) {
      case null:
        return "https://tabsquareinfotech.com/App/Clients/lara_g/public/api/";
      case Flavor.dev:
        return "https://tabsquareinfotech.com/App/Clients/lara_g/public/api/";
      case Flavor.prod:
        return "https://tabsquareinfotech.com/App/Clients/lara_g/public/api/";
      case Flavor.demo:
        return "https://tabsquareinfotech.com/App/Clients/lara_g/public/api/";
    }
  }
}
