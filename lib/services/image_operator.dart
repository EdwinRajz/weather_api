class ImageOperator {
  List<String> weatherImages = <String>[
    'lib/res/clearday.png',
    'lib/res/cloud.png',
    'lib/res/fog.png',
    'lib/res/mask.png',
    'lib/res/night.png',
    'lib/res/rain.png',
    'lib/res/snow.png',
    'lib/res/sunny.png',
    'lib/res/thunder.png',
    'lib/res/wind.png'
  ];

  int imageRange;

   String imageAssigner(int imageRange) {
    if (imageRange <= 232) {
      return 'lib/res/thunder.png';
    } else if (imageRange <= 321 && imageRange >= 300) {
      return 'lib/res/mask.png';
    } else if (imageRange <= 531 && imageRange >= 500) {
      return 'lib/res/rain.png';
    } else if (imageRange <= 622 && imageRange >= 600) {
      return 'lib/res/snow.png';
    } else if (imageRange == 741) {
      return 'lib/res/fog.png';
    } else if (imageRange == 800) {
      return 'lib/res/clearday.png';
    } else if (imageRange >= 801 && imageRange <= 804) {
      return 'lib/res/cloud.png';
    } else if (imageRange == 781) {
      return 'lib/res/wind.png';
    } else {
      return 'lib/res/night.png';
    }
  }
}
