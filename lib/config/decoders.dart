import '/app/networking/rating_api_service.dart';
import '/app/models/payment.dart';
import '/app/networking/payment_api_service.dart';
import '/app/models/order_delivery.dart';
import '/app/models/order_payment.dart';
import '/app/models/order_item.dart';
import '/app/models/order.dart';
import '/app/networking/orders_api_service.dart';
import '/app/controllers/password_verification_controller.dart';
import '/app/controllers/forgot_password_controller.dart';
import '/app/models/password_search.dart';
import '/app/models/verify_code.dart';
import '/app/networking/password_api_service.dart';
import '/app/models/cart.dart';
import '/app/models/item.dart';
import '/app/networking/cart_api_service.dart';
import '/app/controllers/books_controller.dart';
import '/app/networking/comment_api_service.dart';
import '/app/models/comment.dart';
import '/app/models/book.dart';
import '/app/networking/books_api_service.dart';
import '/app/models/profile.dart';
import '/app/networking/profile_api_service.dart';
import '/app/networking/register_api_service.dart';
import '/app/models/register.dart';
import '/app/models/login.dart';
import '/app/networking/login_api_service.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/user.dart';
import '/app/networking/api_service.dart';

/* Model Decoders
|--------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/6.x/decoders#model-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> modelDecoders = {
  Map<String, dynamic>: (data) => Map<String, dynamic>.from(data),

  List<User>: (data) =>
      List.from(data).map((json) => User.fromJson(json)).toList(),
  //
  User: (data) => User.fromJson(data),

  // User: (data) => User.fromJson(data),

  List<Login>: (data) => List.from(data).map((json) => Login.fromJson(json)).toList(),

  Login: (data) => Login.fromJson(data),

  List<Register>: (data) => List.from(data).map((json) => Register.fromJson(json)).toList(),

  Register: (data) => Register.fromJson(data),

  List<Profile>: (data) => List.from(data).map((json) => Profile.fromJson(json)).toList(),

  Profile: (data) => Profile.fromJson(data),

  List<Book>: (data) => List.from(data).map((json) => Book.fromJson(json)).toList(),

  Book: (data) => Book.fromJson(data),

  List<Comment>: (data) => List.from(data).map((json) => Comment.fromJson(json)).toList(),

  Comment: (data) => Comment.fromJson(data),

  List<Item>: (data) => List.from(data).map((json) => Item.fromJson(json)).toList(),

  Item: (data) => Item.fromJson(data),

  List<Cart>: (data) => List.from(data).map((json) => Cart.fromJson(json)).toList(),

  Cart: (data) => Cart.fromJson(data),

  List<VerifyCode>: (data) => List.from(data).map((json) => VerifyCode.fromJson(json)).toList(),

  VerifyCode: (data) => VerifyCode.fromJson(data),

  List<PasswordSearch>: (data) => List.from(data).map((json) => PasswordSearch.fromJson(json)).toList(),

  PasswordSearch: (data) => PasswordSearch.fromJson(data),

  List<Order>: (data) => List.from(data).map((json) => Order.fromJson(json)).toList(),

  Order: (data) => Order.fromJson(data),

  List<OrderItem>: (data) => List.from(data).map((json) => OrderItem.fromJson(json)).toList(),

  OrderItem: (data) => OrderItem.fromJson(data),

  List<OrderPayment>: (data) => List.from(data).map((json) => OrderPayment.fromJson(json)).toList(),

  OrderPayment: (data) => OrderPayment.fromJson(data),

  List<OrderDelivery>: (data) => List.from(data).map((json) => OrderDelivery.fromJson(json)).toList(),

  OrderDelivery: (data) => OrderDelivery.fromJson(data),

  List<Payment>: (data) => List.from(data).map((json) => Payment.fromJson(json)).toList(),

  Payment: (data) => Payment.fromJson(data),
};

/* API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/6.x/decoders#api-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  // ...

  LoginApiService: LoginApiService(),

  RegisterApiService: RegisterApiService(),

  ProfileApiService: ProfileApiService(),

  BooksApiService: BooksApiService(),

  CommentApiService: CommentApiService(),

  CartApiService: CartApiService(),

  PasswordApiService: PasswordApiService(),

  OrdersApiService: OrdersApiService(),

  PaymentApiService: PaymentApiService(),

  RatingApiService: RatingApiService(),
};

/* Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
|
| Learn more https://nylo.dev/docs/6.x/controllers
|-------------------------------------------------------------------------- */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),

  // ...

  BooksController: () => BooksController(),

  ForgotPasswordController: () => ForgotPasswordController(),

  PasswordVerificationController: () => PasswordVerificationController(),
};
