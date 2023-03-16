import 'package:get/get.dart';

import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/app/modules/room_data_screen/widgets/app_forms/collect_payment_form.dart';
import 'package:hotel_pms/app/modules/room_data_screen/widgets/app_forms/laundry_form.dart';
import 'package:hotel_pms/app/modules/room_data_screen/widgets/app_forms/package_storage_form.dart';
import '../modules/homepage_screen/bindings/homepage_binding.dart';
import '../modules/homepage_screen/views/homepage_view.dart';
import '../modules/login_screen/bindings/auth_bindings.dart';
import '../modules/room_data_screen/bindings/laundry_form_bindings.dart';
import '../modules/room_data_screen/bindings/package_form_bindings.dart';
import '../modules/room_data_screen/bindings/payment_binding.dart';
import '../modules/room_data_screen/bindings/room_details_bindings.dart';
import '../modules/room_data_screen/bindings/room_service_form_binding.dart';
import '../modules/room_data_screen/views/room_details_view.dart';
import '../modules/room_data_screen/widgets/app_forms/room_service_form.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomePageView(),
      binding: HomepageBinding()

    ),
    GetPage(
      name: _Paths.ROOM_DETAILS,
      page: () => const RoomDetailsView(),
        binding: GuestDetailsBinding()
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LandingPage(),
      binding: AuthBinding()

    ),
    GetPage(
        name: _Paths.LAUNDRY_FORM,
        page: () => const LaundryForm(),
        binding: LaundryFormBinding()
    ),
    GetPage(
      name: _Paths.PACKAGE_FORM,
      page: () => const StorePackageForm(),
      binding: PackageFormBinding(),
    ),
    GetPage(
      name: _Paths.ROOM_SERVICE_FORM,
      page: () =>  RoomServiceForm(),
      binding: RoomServiceBinding(),
    ),
    GetPage(
        name: _Paths.PAYMENT_FORM,
        page: () => CollectPaymentForm(),
        binding: PaymentBinding(),
    ),

  ];
}
