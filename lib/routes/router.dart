import '/resources/pages/password_verification_page.dart';
import 'package:flutter_app/resources/pages/book_detail_page.dart';

import '/resources/pages/login_page.dart';
import '/resources/pages/not_found_page.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/profile_page.dart';
import '/resources/pages/register_page.dart';
import '/resources/pages/cart_page.dart';
import '/resources/pages/order_history_page.dart';
import '/resources/pages/forgot_password_page.dart';
import '/resources/pages/purchase_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
|
| * [Tip] Add authentication 🔑
| Run the below in the terminal to add authentication to your project.
| "dart run scaffold_ui:main auth"
|
| Learn more https://nylo.dev/docs/6.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.add(LoginPage.path).initialRoute();
      // Add your routes here ...

      // router.add(NewPage.path, transition: PageTransitionType.fade);

      // Example using grouped routes
      // router.group(() => {
      //   "route_guards": [AuthRouteGuard()],
      //   "prefix": "/dashboard"
      // }, (router) {
      //
      // });
      router.add(BookDetailPage.path);
      router.add(NotFoundPage.path).unknownRoute();
      router.add(HomePage.path).authenticatedRoute();
      router.add(ProfilePage.path);
      router.add(RegisterPage.path);
      router.add(CartPage.path);
      router.add(OrderHistoryPage.path);
      router.add(ForgotPasswordPage.path);
      router.add(PurchasePage.path);
  router.add(PasswordVerificationPage.path);
});

