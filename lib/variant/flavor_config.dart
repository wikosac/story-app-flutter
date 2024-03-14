enum FlavorType {
  free,
  pro,
}

class FlavorValues {
  final String appType;

  const FlavorValues({
    this.appType = "Free",
  });
}

class FlavorConfig {
  final FlavorType flavor;
  final FlavorValues values;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavor = FlavorType.free,
    this.values = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}