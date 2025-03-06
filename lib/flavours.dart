enum Flavor {
  dev,
  prod,
  demo,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Lara_g_admin Dev';
      case Flavor.prod:
        return 'Lara_g_admin';
      case Flavor.demo:
        return 'Lara_g_admin Demo';
      default:
        return 'title';
    }
  }
}
