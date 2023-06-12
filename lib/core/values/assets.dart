

const String _kAssets = "assets/";
const String _kImages = "${_kAssets}images/";

class Assets {
  const Assets._();
  static const String kConnectionError = "${_kImages}no_internet.svg";
  static const String kLoginBackground = "${_kImages}blue_lines.png";
  static const String kLogo = "${_kImages}whitemark_logo.png";
  static const String kEmptyBox = "${_kImages}empty_box.png";
  static const String kEmptyLaundry = "${_kImages}empty_laundry.jpg";
  static const String kClothesRope = "${_kImages}clothes_rope.jpg";
  static const String kLaundryPole = "${_kImages}laundry_pole.png";
  static const String knoDataBigLaptop = "${_kImages}no_data_biglp.jpg";
  static const String knoDataLady = "${_kImages}no_data_lady.jpg";
  static const String kStorePackage = "${_kImages}store_package.jpg";
  static const String kStorePackage1 = "${_kImages}woman_smile_pk.jpg";
  static const String kStorePackage2 = "${_kImages}woman_store_pg.jpeg";
  static const String kStorePackage3 = "${_kImages}woman_store_pg_2.png";
  static const String kRoomService = "${_kImages}room_service.jpg";
  static const String kDeskOne = "${_kImages}desk_1.jpg";
  static const String kDeskTwo = "${_kImages}desk_2.jpg";



  static const List<String> newPackageIllustrations = [kStorePackage,kStorePackage1,kStorePackage2,kStorePackage3];
  static const List<String> newLaundryIllustrations = [kClothesRope,kLaundryPole];
  static const List<String> noDataIllustrations = [knoDataBigLaptop,knoDataLady];

}
