import 'package:flutter/material.dart';
import 'package:id_driver/ui/screens/book_driver/book_driver.dart';
import 'package:id_driver/ui/screens/book_driver/confirm_booking.dart';
import 'package:id_driver/ui/screens/contact_us/contact_us.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:id_driver/ui/screens/local_map/local_map.dart';
import 'package:id_driver/ui/screens/my_bookings/my_bookings.dart';
import 'package:id_driver/ui/screens/rate_card/rate_card.dart';
import 'package:id_driver/ui/screens/signup/signup.dart';
import 'package:id_driver/ui/screens/terms/terms.dart';
import 'package:id_driver/ui/screens/trip_invites/booking_details.dart';
import 'package:id_driver/ui/screens/verify_otp/verify_otp.dart';
import 'package:id_driver/ui/splash_screen/splash_screen.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';
import 'package:id_driver/ui/screens/trip_invites/trip_invites.dart';
import 'package:id_driver/ui/screens/job_portal/job_portal.dart';
import 'package:id_driver/ui/screens/wallet/wallet.dart';
import 'package:id_driver/ui/screens/online_test/online_test.dart';
import 'package:id_driver/ui/screens/news/news.dart';
import 'package:id_driver/ui/screens/profile/profile.dart';
import '../../core/exceptions/route_exception.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String login = '/signin_screen';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify_otp';
  static const String splash = '/splash_screen';
  static const String ratecard = '/rate_card';
  static const String mybooking = '/my_booking';
  static const String terms = '/terms';
  static const String bookDriver = '/book_driver';
  static const String bookingDetails = '/booking_details';
  static const String confirmBooking = '/confirm_booking';
  static const String tripInvites = '/trip_invites';
  static const String jobPortal = '/job_portal';
  static const String wallet = '/wallet';
  static const String onlineTest = '/online_test';
  static const String news = '/news';
  static const String profile = '/profile';
  static const String localMap = '/localMap';
  static const String contactUs = '/contact_us';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const Dashboard(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const SignIn(),
        );
      case verifyOtp:
        return MaterialPageRoute(
            builder: (_) => VerifyOtp(), settings: settings);

      case signup:
        return MaterialPageRoute(
            builder: (_) => const SignUp(), settings: settings);
      case splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case ratecard:
        return MaterialPageRoute(
          builder: (_) => const RateCard(),
        );
      case terms:
        return MaterialPageRoute(
          builder: (_) => const Terms(),
        );
      case mybooking:
        return MaterialPageRoute(
          builder: (_) => const MyBookings(),
        );
      case bookDriver:
        return MaterialPageRoute(
          builder: (_) => const BookDriver(),
        );
      case confirmBooking:
        return MaterialPageRoute(
          builder: (_) => const ConfirmBooking(),
        );
      case tripInvites:
        return MaterialPageRoute(
          builder: (_) => const TripInvites(),
        );
      case jobPortal:
        return MaterialPageRoute(
          builder: (_) => JobPortal(),
        );
      case wallet:
        return MaterialPageRoute(
          builder: (_) => const Wallet(),
        );
      case onlineTest:
        return MaterialPageRoute(
          builder: (_) => const OnlineTest(),
        );
      case news:
        return MaterialPageRoute(
          builder: (_) => const News(),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const Profile(),
        );
      case localMap:
        return MaterialPageRoute(
          builder: (_) => const LocalMap(),
        );
      case contactUs:
        return MaterialPageRoute(
          builder: (_) => const ContactUs(),
        );
      case bookingDetails:
        return MaterialPageRoute(
            builder: (_) => const BookingDetails(), settings: settings);
      default:
        throw const RouteException('Route not found!');
    }
  }
}
