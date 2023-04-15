import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/guest_dashboard/widgets/app_forms/room_service_form.dart';
import 'package:hotel_pms/app/modules/login_screen/views/auth_screen.dart';
import 'package:hotel_pms/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/guest_dashboard/bindings/laundry_form_bindings.dart';
import '../modules/guest_dashboard/bindings/package_form_bindings.dart';
import '../modules/guest_dashboard/bindings/payment_binding.dart';
import '../modules/guest_dashboard/bindings/room_details_bindings.dart';
import '../modules/guest_dashboard/bindings/room_service_form_binding.dart';
import '../modules/guest_dashboard/views/guest_dashboard_view.dart';
import '../modules/guest_dashboard/widgets/app_forms/collect_payment_form.dart';
import '../modules/guest_dashboard/widgets/app_forms/laundry_form.dart';
import '../modules/guest_dashboard/widgets/app_forms/package_storage_form.dart';
import '../modules/homepage_screen/bindings/homepage_binding.dart';
import '../modules/homepage_screen/views/homepage_view.dart';
import '../modules/login_screen/bindings/auth_bindings.dart';
import '../modules/splash_screen/view/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomePageView(),
      binding: HomepageBinding()

    ),
    GetPage(
      name: _Paths.ROOM_DETAILS,
      page: () => const GuestDashboardView(),
        binding: GuestDetailsBinding()
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => LandingPage(),
      binding: AuthBinding()

    ),
    GetPage(
        name: _Paths.LAUNDRY_FORM,
        page: () =>  LaundryForm(),
        binding: LaundryFormBinding()
    ),
    GetPage(
      name: _Paths.PACKAGE_FORM,
      page: () =>  StorePackageForm(),
      binding: PackageFormBinding(),
    ),
    GetPage(
      name: _Paths.ROOM_SERVICE_FORM,
      page: () =>  RoomServiceForm(),
      binding: RoomServiceBinding(),
    ),
    GetPage(
        name: _Paths.PAYMENT_FORM,
        page: () =>  CollectPaymentForm(),
        binding: PaymentBinding(),
    ),

    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
    ),

  ];
}
