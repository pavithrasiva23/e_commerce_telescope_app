abstract final class TelescopeUtils {
  static const String _equatorial = 'Equatorial';
  static const String _altazimuth = 'Altazimuth';
  static const String _refractor = 'Refractor';
  static const String _reflector = 'Reflector';
  static const String _catadioptric = 'Catadioptric';
  static const String _autofocus = 'Auto Focus';
  static const String _manualFocus = 'Manual Focus';
  static const String _autoAndManualFocus = 'Auto & Manual Focus';
  static const mountList = [_equatorial, _altazimuth];
  static const typeList = [_refractor, _reflector, _catadioptric];
  static const focusList = [_autofocus, _manualFocus, _autoAndManualFocus];
}

//To add/delete - images (reference)
const String telescopeImageDirectory = 'Telescopes/';

//Brand's fields:
const String brandFieldId = 'id';
const String brandFieldName = 'name';

//constant image:
const dummyImage = 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcT0s3qgIHhOj3P0L7gKDk_ckqkbDwaALhMvuhr_OSQYxPmRNmjWV33jofre_fJ68X6DJqdlo3A0AWqtpGQjva0Xo-OuAsncjERuCWvKLVCcMbkNSLLFg5k3d231gA99A504rT5r7OCWqw&usqp=CAc';

//currencySymbol
const String currencySymbol = '\$';

const String descriptionValue = '''
PERFECT ENTRY-LEVEL TELESCOPE: The Celestron PowerSeeker 127EQ is an easy-to-use and powerful telescope. This 127mm Newtonian Reflector offers enough light gathering ability to see planets, the Moon's craters, distant stars, the Orion Nebula, and more.
MANUAL GERMAN EQUATORIAL MOUNT: With its slow-motion altitude rod, the German Equatorial mount allows you to navigate the sky with ease. Find celestial objects quickly and follow them smoothly & accurately as they appear to drift across the night sky.
COMPACT AND PORTABLE: The ideal telescope for adults and kids to use together, the PowerSeeker is compact, lightweight, and portable. Take it to your favorite campsite, a dark sky observing site, or simply the backyard.
MULTIPLE ACCESSORIES: The Celestron PowerSeeker 127EQ Telescope comes with 2 quality eyepieces (20mm and 4mm) plus a 3x Barlow lens to triple the power of each. You'll also receive a FREE download of one of the top-rated astronomy software programs.
UNBEATABLE WARRANTY & SUPPORT: Buy with confidence from Celestron, a leading telescope brand in California since 1960. Your purchase includes a 2-Year US Warranty and unlimited support from our team of US-based experts.
''';
// class BrandModel{
//   String? id;
//   String name;
//
//   BrandModel({this.id, required this.name});
//
//   Map<String, dynamic> toJson() {
//     return <String, dynamic> {
//       brandFieldId: id,
//       brandFieldName: name
//     };
//   }
//
//   factory BrandModel.fromJson(Map<String, dynamic> obj) =>
//       BrandModel(
//           id: obj[brandFieldId],
//           name: obj[brandFieldName]);
// }