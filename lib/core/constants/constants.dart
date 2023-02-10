import 'package:flutter/material.dart';
import 'size_config.dart';

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 10, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);

const kPrimaryColor = Color(0xFF53B61E);
const kPrimaryDarkColor = Color(0xFF4E944F);
const kPrimaryLightColor = Color(0xFFB1E693);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextOutlineColor = Color(0xFFC7C4C4);
const kTextColor = Color(0xFF757575);
const kTextBlackColor = Color(0xFF000000);
const kBlackColor = Color(0xFF000000);
const kTextOpacityColor = Color(0xB3E4E4E4);
const kTextDarkBlueColor = Color(0xFF2C3F6E);
const kWhiteColor = Color(0xFFFFFFFF);

//profile
const kActiveBtnColor = Color(0xFF700033);
const kInActiveBtnColor = Color(0xFF970045);
const kActiveBtnBorderColor = Color(0xFFED006C);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

//* Server Config */

/// Beta */
// const String kDomain = "http://43.240.67.79:3000/";
// const String kBaseUrl = 'http://43.240.67.79:3000/api/';

/// Live */
const String kDomain = "http://65.0.186.134:3000/";
const String kBaseUrl = 'http://65.0.186.134:3000/api/';

/// API's */
const String kGoogleMapAutocomplete =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json";
const String kGoogleAPIKey = "AIzaSyAZVdypRwWG3MBmQXD12X1KPgt9lZDEKX4";
const String kGoogleMapPlaceDetails =
    "https://maps.googleapis.com/maps/api/place/details/json?";
const String kGoogleMapDistanceMatrix =
    "https://maps.googleapis.com/maps/api/distancematrix/json?";
const String kGeocoding = "https://maps.googleapis.com/maps/api/geocode/json?";
const String validateCustomerMobile = 'ConUsers/validateDriverMobile';
const String kLogin = 'ConUsers/login';
const String kSendSMS = 'ConUsers/sendSMS';
const String kCreateCustomer = 'ConUsers/createCustomerForCustomerApp';
const String kUpdateCustomer = 'ConUsers/updateProfile';
const String kConUsers = 'ConUsers';

const String kStates = 'States';
const String kCities = 'Cities';
const String kGetCityId = 'Cities/findOne';
const String kCalculateFare = "FareMatrices/calculateFare";
const String kDriverDetails = "DriverDetails";
const String kCustomerDetails = "CustomerDetails";
const String kCreateNewBookingPromoCode = "Bookings/createNewBookingPromocode";
const String kCreateNewBooking = "Bookings/createNewBooking";
const String kLocalBoundries = "LocalBoundries";
const String kGetBookings = "Bookings";
const String kPaidDutyFunction = kGetBookings + "/paidDutyFunction";
const String kGetDriverInvites = "Bookings/getDriverInvites";
const String kGetDriverInvitesTomorrow = "Bookings/getDriverInvitesTomorrow";
const String kGetDriverDuty = "Bookings/getDriverDuties";
const String kGetDriverCurrentDuty = "Bookings/getDriverCurrentDuty";
const String kCancellationReasons = "CancellationReasons";
const String kCancelBooking = "Bookings/cancelBooking";
const String kGetRateCard = "RateCards";
const String kGetNews = "News";
const String kDriverJobDetails = "DriverJobDetails";
const String kApplyDriverJob = "DriverJobRequests/applyDriverJob";
const String kCreateMonthlyDriverRequest =
    "PermanentDriverRequests/createPermanentDriver";

const String InsertUserAttendance = 'InsertUserAttendance';
const String GetUserDetails = 'GetUserDetails';

/// Driver */

const String kCreateDriver = "ConUsers/createDriverForDriverAppNew";
const String kAcceptDuty = "Bookings/acceptDuty";
const String kStartDuty = "Bookings/startDuty";
const String kCancelDuty = "Bookings/driverCancelDutyNew1";
const String kOffDuty = "Bookings/offDutyForDriver";
const String getDriverLocalSummary = "Bookings/getDriverLocalSummary";
const String getDriverOutstationSummary = "Bookings/getDriverOutstationSummary";
const String kCreateAllocationHistory =
    "DriverAllocationReports/createAllocationHistory";
const String kUpdateInvoiceOnStartAndOffDuty = "updateInvoiceOnStartAndOffDuty";

/* Account */
const String kDriverAccountTransactions = "DriverAccountTransactions";
const String kDriverAccounts = "DriverAccounts";
const String Paytm_MID_LIVE = "IDCarD52035492281968";
const String Paytm_MID_TEST = "IDCarD73909887073705";
const String Merchant_Key = "vj0CPrA4kvr5lBM7";
const String kGetChecksum = "genchecksum_paytm_new";
const String kIndustryTypeIdLive = "Retail108";
const String kIndustryTypeIdTest = "Retail";
const String kWebsiteLive = "IDCarDriverswap";
const String kWebsiteTest = "IDCarDriverswap";
const String kPayTmInitPayment =
    "https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?";
const String kDriverRechargeTransactions = "DriverRechargeTransactions";
const String kUpdateTransaction =
    kDriverRechargeTransactions + "/updateTransaction";
const String kDriverRechargeOnline =
    kDriverRechargeTransactions + "/driverRechargeOnline";

const String kGetInvoice = "Invoices";

//App Version
const String kGetAppVersion = "getDriverAppLiveVersion";
const String kAppVersion = "9813";
const String kPlayStoreUrl = "market://details?id=com.mti.driver&hl=en";
const String kAppStoreUrl = "https://apps.apple.com/app/idcom.mti.driver&hl=en";
const String kCustomerAppStoreUrl =
    "https://apps.apple.com/in/app/indian-drivers/id1183698627";

    //0A:48:53:41:3B:A8:73:E9:D3:16:ED:5E:D2:1C:75:C8 MD5
    //83:38:0E:A1:DE:23:B9:7C:B9:09:F9:81:28:0B:F6:97:EF:B9:DF:09 SHA1
    //55:31:91:16:C9:8A:AF:23:B1:78:03:F8:C0:5C:C5:A6:FD:1C:9C:A0:73:7F:85:AC:BA:21:69:C7:D5:20:53:F3 SHA256

    // $ java -jar pepk.jar --keystore=foo.keystore --alias=foo --output=encrypted_private_key_path --encryptionkey=eb10fe8f7c7c9df715022017b00c6471f8ba8170b13049a11e6c09ffe3056a104a3bbe4ac5a955f4ba4fe93fc8cef27558a3eb9d2a529a2092761fb833b656cd48b9de6a
