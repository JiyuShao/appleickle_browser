class HorizonConfig {
  late final int maxClouds = 20;
  late final double bgCloudSpeed = 0.2;

  // 实际展示的大小
  late final double width = 600.0;
  late final double height = 12.0;
}

class CloudConfig {
  late final double height = 28.0;
  late final double width = 92.0;

  late final double maxCloudGap = 400.0;
  late final double minCloudGap = 100.0;

  late final double maxSkyLevel = 71.0;
  late final double minSkyLevel = 30.0;
}
