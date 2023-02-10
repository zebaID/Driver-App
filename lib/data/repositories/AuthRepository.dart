import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/logic/booking/bloc/booking_bloc.dart';
import 'package:id_driver/logic/booking/model/assigned_booking_response_model.dart';
import 'package:id_driver/logic/booking/model/booking_response_model.dart';
import 'package:id_driver/logic/booking/model/current_duty_response_model.dart';
import 'package:id_driver/logic/booking/model/invoice_response_model.dart';
import 'package:id_driver/logic/jobs/models/jobs_response_model.dart';
import 'package:id_driver/logic/login/model/customer_details_model.dart';
import 'dart:convert' as convert;

import 'package:id_driver/logic/login/model/login_model.dart';
import 'package:id_driver/logic/registration/model/update_request_model.dart';
import 'package:id_driver/logic/registration/validators/mobile_number.dart';
import 'package:id_driver/main.dart';
import 'package:intl/intl.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<String?> validateMobile(mobile) async {
    print('validating mobile ' + mobile);

    // Map<String, dynamic> formMap = {
    //   "Password": password,
    //   "UserEmail": username,
    // };
    var response = await http.get(
      Uri.parse(kBaseUrl + validateCustomerMobile + "?mobileNumber=" + mobile),
    );
    print(response.statusCode);

    // Await the http get response, then decode the json-formatted response.
    if (response.statusCode == 200) {
      // print(response.body);
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      // var jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      final item = jsonResponse[0];
      print("validate Reponse ${response.body}");
      // UserModel.fromJson(jsonResponse);
      return item['validate_driver_mobile'];
      // if (jsonResponse['status'] != 'Fail') {
      //   print('User Logged In: $jsonResponse.');
      //   return response.body;
      // } else {
      //   return null;
      // }
    } else {
      print('User Logged In: ${response.statusCode}.');
      return null;
    }
  }

  Future<String?> login(mobile, otp) async {
    print('attempting login ' + mobile);

    Map<String, String> payload = {
      "username": "$mobile",
      "password": "$mobile",
    };

    final loginModel = LoginModel(mobile.toString(), mobile.toString());
    // loginModel.pass = mobile.toString();
    // loginModel.userN = mobile.toString();

    print("payload ${loginModel.toJson()}");
    final response = await http.post(
      Uri.parse(kBaseUrl + kLogin),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    print("${response.body}");

    // Await the http get response, then decode the json-formatted response.
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      Map<String, Object> updateUser = {'otp': otp};

      final updateResponse = await http.put(
        Uri.parse(kBaseUrl +
            kConUsers +
            "/${res['userId']}?access_token=${res['id']}"),
        body: updateUser,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
      );

      // print(response.body);
      // final List<dynamic> jsonResponse = jsonDecode(response.body);
      // var jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      // final item = jsonResponse[0];
      // print(item['validate_customer_mobile']);
      // UserModel.fromJson(jsonResponse);
      // return item['validate_customer_mobile'];
      // if (jsonResponse['status'] != 'Fail') {
      //   print('User Logged In: $jsonResponse.');
      //   return response.body;
      // } else {
      //   return null;
      // }
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } else {
      print('User Logged In: ${response.statusCode}.');
      return null;
    }
  }

  Future<String?> sendSMS(mobile) async {
    print('Send SMS ' + mobile);
    Random random = Random();
    // int randomNumber = random.nextInt(9999999999);

    var rnd = Random();
    var next = rnd.nextDouble() * 1000;
    while (next < 1000) {
      next *= 10;
    }
    print(next.toInt());

    // int noOfOtpDigit = 4;
    // while (randomNumber.toString().length != noOfOtpDigit) {
    //   randomNumber = Random().nextInt(9999999999);
    // }
    Map<String, dynamic> payload = {
      "mobileNumber": '$mobile',
      "msg": "Your verification code is ${next.toInt()}",
    };
    // final loginModel = LoginModel(mobile.toString(), mobile.toString());
    // loginModel.pass = mobile.toString();
    // loginModel.userN = mobile.toString();

    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );
    print(response.body);

    // Await the http get response, then decode the json-formatted response.
    if (response.statusCode == 200) {
      // print(response.body);
      // final List<dynamic> jsonResponse = jsonDecode(response.body);
      // var jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      // final item = jsonResponse[0];
      // print(item['validate_customer_mobile']);
      // UserModel.fromJson(jsonResponse);
      // return item['validate_customer_mobile'];
      // if (jsonResponse['status'] != 'Fail') {
      //   print('User Logged In: $jsonResponse.');
      //   return response.body;
      // } else {
      //   return null;
      // }
      return next.toInt().toString();
    } else {
      print('Send OTP: ${response.statusCode}.');
      return null;
    }
  }

  Future<String?> register(
      mobileNumber,
      firstName,
      lastName,
      addressLine1,
      addressLine2,
      email,
      operationCity,
      addressLine1Latitude,
      addressLine1Longitude) async {
    Map<String, String> payload = {
      "mobileNumber": mobileNumber,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "username": mobileNumber,
      "password": mobileNumber,
      "otp": "1234",
      "landmark": addressLine1,
      "addressLat": addressLine1Latitude.toString(),
      "addressLong": addressLine1Longitude.toString(),
      "address": addressLine2,
      "userDevice": "A",
      "operationCity": operationCity
    };
    print("Registration Payload $payload");
    // return null;
    var response = await http.post(
      Uri.parse(kBaseUrl + kCreateCustomer),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );
    // .timeout(Duration(seconds: 60000));

    print(response.statusCode);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getStates() async {
    var response = await http.get(
      Uri.parse(kBaseUrl + kStates),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getCities(stateId) async {
    final payload = {
      "where": {"stateId": "$stateId"}
    };

    // ascii.encode(payload.toString());

    var asci = Uri.encodeComponent(payload.toString());
    print("ASCI $asci");
    var response = await http.get(
        Uri.parse(kBaseUrl +
            kCities +
            "?filter=" +
            "%7B%22where%22%3A%7B%22stateId%22%3A%22$stateId%22%7D%7D"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getCityId() async {
    final accessToken = await DataProvider().getToken();
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);

    print(
        "getCityId ?filter=%7B%22where%22%3A%7B%22cityName%22%3A%22${parsed[0]['conUsers']['operationCity']}%22%7D%7D&access_token=$accessToken");
    var response = await http.get(
      Uri.parse(kBaseUrl +
          kGetCityId +
          "?filter=%7B%22where%22%3A%7B%22cityName%22%3A%22${parsed[0]['conUsers']['operationCity']}%22%7D%7D&access_token=$accessToken"),
    );

    print('getCityId Response ${response.body}');
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await _prefs;
      prefs.setString("cityId", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  // Future<void> _storeCityId(String cityId) async {}

  Future<String?> getCustomerDetails(userid) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = prefs.getString("UserSession");
    final parsed = jsonDecode(userSession!);
    var response = await http.get(
      Uri.parse(kBaseUrl +
          kDriverDetails +
          "?filter=%7B%22where%22%3A%7B%22conuserId%22%3A%22${parsed['userId']}%22%7D%2C%22include%22%3A%5B%7B%22relation%22%3A%22conUsers%22%7D%2C%7B%22relation%22%3A%22driverAccount%22%7D%5D%7D&access_token=${parsed['id']}"),
    );

    print("customerDetails ${response.body}");

    if (response.statusCode == 200) {
      return prefs
          .setString("customerDetails", response.body)
          .then((value) => response.body)
          .catchError((err) {
        print(err);
      });
    } else {
      return null;
    }
  }

  Future<CustomerDetailsModel?> getCustomerDetailsByUserId(userid) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = prefs.getString("UserSession");
    final parsed = jsonDecode(userSession!);
    Map<String, String> relation = {'relation': 'conUsers'};
    Map<String, String> include = {'include': 'conUsers'};
    var response = await http.get(
      Uri.parse(kBaseUrl +
          kCustomerDetails +
          "/findOne?filter=%7B%22where%22%3A%7B%22id%22%3A%22$userid%22%7D%2C%22include%22%3A%5B%7B%22relation%22%3A%22conUsers%22%7D%5D%7D&access_token=${parsed['id']}"),
    );

    print("customerDetails ${response.body}");

    if (response.statusCode == 200) {
      return CustomerDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<String?> getDriverAccountDetails() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = prefs.getString("UserSession");
    final parsed = jsonDecode(userSession!);
    String? userDetails = await DataProvider().getSessionData();
    print("parsedUserDetails $userDetails");
    final parsedUserDetails = jsonDecode(userDetails!);
    String accountId =
        parsedUserDetails[0]['driverAccount'][0]['id'].toString();
    "?filter=%7B%22where%22%3A%7B%22conuserId%22%3A%22${parsed['userId']}%7D%2C%22limit%22%3A10%7D&access_token=${parsed['id']}";
    var response = await http.get(
      Uri.parse(kBaseUrl +
          kDriverAccountTransactions +
          "?filter=%7B%22where%22%3A%7B%22accountId%22%3A%22$accountId%22%7D%2C%22order%22%3A%20%22id%20DESC%22%2C%20%22limit%22%3A%2010%7D&access_token=${parsed['id']}"),
    );

    print("getDriverAccountDetails ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getAccountBalance() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = prefs.getString("UserSession");
    final parsed = jsonDecode(userSession!);
    String? userDetails = await DataProvider().getSessionData();
    print("parsedUserDetails $userDetails");
    final parsedUserDetails = jsonDecode(userDetails!);
    String accountId =
        parsedUserDetails[0]['driverAccount'][0]['id'].toString();
    "?filter=%7B%22where%22%3A%7B%22conuserId%22%3A%22${parsed['userId']}%7D%2C%22limit%22%3A10%7D&access_token=${parsed['id']}";
    var response = await http.get(
      Uri.parse(kBaseUrl +
          kDriverAccounts +
          "?filter=%7B%22where%22%3A%7B%22id%22%3A%22$accountId%22%7D%2C%22order%22%3A%20%22id%20DESC%22%2C%20%22limit%22%3A%2010%7D&access_token=${parsed['id']}"),
    );

    print("kDriverAccounts ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> initiatePayment(String amount) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    // String? userSession = prefs.getString("UserSession");
    // final parsed = jsonDecode(userSession!);
    String? userDetails = await DataProvider().getSessionData();
    print("parsedUserDetails $userDetails");
    final parsedUserDetails = jsonDecode(userDetails!);
    String orderId = "OrderID_${DateTime.now().millisecondsSinceEpoch}";
    String accounId = parsedUserDetails[0]['driverAccount'][0]['id'].toString();
    String transactionID;

    Map<String, Object> createTransaction = {
      "driverId": parsedUserDetails[0]['id'].toString(),
      "accountId": accounId,
      "status": "Initiated",
      "amount": amount,
      "createdBy": parsedUserDetails[0]['id'].toString()
    };

    var createResponse = await http.post(
        Uri.parse(kBaseUrl + kDriverRechargeTransactions),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(createTransaction));

    if (createResponse.statusCode == 200) {
      final decodeCreate = jsonDecode(createResponse.body);
      transactionID = decodeCreate['id'].toString();
      orderId =
          decodeCreate['id'] + 'R' + parsedUserDetails[0]['id'].toString();

      Map<String, Object> updateTransaction = {
        "id": transactionID,
        "orderId": orderId,
      };

      var updateTransactionResponse = await http.put(
          Uri.parse(
              kBaseUrl + kDriverRechargeTransactions + "/" + transactionID),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(updateTransaction));

      print("updateTransactionResponse  ${updateTransactionResponse.body}");

      if (updateTransactionResponse.statusCode == 200) {
        Map<String, Object> body = {
          "requestType": "Payment",
          "mid": Paytm_MID_LIVE,
          "websiteName": kWebsiteLive,
          "orderId": orderId,
          "callbackUrl":
              "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",
        };

        Map<String, String> txnAmount = {
          "value": amount,
          "currency": "INR",
        };
        Map<String, String> userInfo = {
          "custId": parsedUserDetails[0]['id'].toString(),
          "mobile": parsedUserDetails[0]['conUsers']['mobileNumber']
        };

        body.addAll({"txnAmount": txnAmount});
        body.addAll({"userInfo": userInfo});

        print("initPayPayload ${jsonEncode(body)}");

        var response = await http.post(Uri.parse(kDomain + kGetChecksum),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body));

        print("initiatePaymentResp ${response.body}");
        final decodeInitResp = jsonDecode(response.body);

        if (decodeInitResp['body']['resultInfo']['resultCode'] == "0000") {
          String? paymentResult;
          var response = AllInOneSdk.startTransaction(
              Paytm_MID_LIVE,
              orderId,
              amount,
              decodeInitResp['body']['txnToken'],
              "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",
              false,
              true);
          response.then((value) async {
            print("SDK Resp ${value.toString()}");

            var updateSuccessResponse = await http.get(
              Uri.parse(kBaseUrl +
                  kDriverRechargeOnline +
                  "?transactionId=" +
                  transactionID),
            );

            print("successResp ${updateSuccessResponse.body}");

            if (updateSuccessResponse.statusCode == 200) {
              paymentResult = updateSuccessResponse.body;

              Map<String, Object> successTransactionPayload = {
                "id": transactionID,
                "transactionResponse": value.toString()
              };

              final payload = jsonEncode(successTransactionPayload);
              print("failedTransactionPay $payload");

              var transResponse = await http.put(
                  Uri.parse(kBaseUrl +
                      kDriverRechargeTransactions +
                      "/" +
                      transactionID),
                  headers: {"Content-Type": "application/json"},
                  body: payload);

              print("failedResp ${transResponse.body}");

              if (transResponse.statusCode == 200) {
                paymentResult = transResponse.body;
              } else {
                paymentResult = null;
              }
            } else {
              paymentResult = null;
            }
          }).catchError((onError) async {
            paymentResult = onError.details.toString();

            // if (onError is PlatformException) {
            //   print(
            //       "PlatformException ${onError.message} ${onError.details.toString()}");
            // } else {
            //   print(onError.toString());
            // }

            Map<String, Object> failedTransaction = {
              "id": transactionID,
              "status": "Fail",
              "updatedDate": DateTime.now().toString(),
              "updatedBy": parsedUserDetails[0]['id'].toString()
            };

            print("failedTransactionPay ${jsonEncode(failedTransaction)}");

            var failedTransResponse = await http.put(
                Uri.parse(kBaseUrl +
                    kDriverRechargeTransactions +
                    "/" +
                    transactionID),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode(failedTransaction));

            print("failedResp ${failedTransResponse.body}");

            if (failedTransResponse.statusCode == 200) {
              paymentResult = failedTransResponse.body;
            } else {
              paymentResult = null;
            }
          });

          return paymentResult;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String?> getPlaces(String searchQuery) async {
    // var asci = Uri.encodeComponent(payload.toString());
    // print("ASCI $asci");
    var response = await http.get(
        Uri.parse(kGoogleMapAutocomplete +
            "?input=$searchQuery&key=$kGoogleAPIKey&components=country%3ACA%7Ccountry%3AIND"),
        headers: {});

    print(" Places Response ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getDistance(
      double srcLat, double srcLongi, double destLat, double destLongi) async {
    // var asci = Uri.encodeComponent(payload.toString());
    // print("ASCI $asci");
    Map<String, String> payload = {
      'origins': '["$srcLat,$srcLongi"]',
      'destinations': '["$destLat,$destLongi"]',
    };
    var response = await http.get(
      Uri.parse(
        kGoogleMapDistanceMatrix +
            "origins=$srcLat%2C$srcLongi&destinations=$destLat%2C$destLongi&key=$kGoogleAPIKey",
      ),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    print(" Distance Matrix Response ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getAddressFromCoordinates(String lat, String lng) async {
    // var asci = Uri.encodeComponent(payload.toString());
    // print("ASCI $asci");
    print(kGeocoding + "latlng=$lat,$lng&key=$kGoogleAPIKey");
    var response = await http.get(
        Uri.parse(kGeocoding + "latlng=$lat,$lng&key=$kGoogleAPIKey"),
        headers: {});

    print(" getAddressFromCoordinates Response ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getPlaceDetails(String placeId) async {
    // var asci = Uri.encodeComponent(payload.toString());
    // print("ASCI $asci");
    var response = await http.get(
        Uri.parse(
            kGoogleMapPlaceDetails + "place_id=$placeId&key=$kGoogleAPIKey"),
        headers: {});

    print("getPlaceDetails ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> calculateFare(
      String carType,
      String isRoundTrip,
      String isOutstation,
      String actualReportingDate,
      String actualReportingTime,
      String actualReleivingDate,
      String actualReleivingTime,
      String pickupLat,
      String pickupLng,
      String dropLat,
      String dropLng,
      String operationCityId) async {
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    final cityId = await DataProvider().getCityId();
    Map<String, String> payload = {
      'carType': carType.substring(0, 1),
      'isRoundTrip': isRoundTrip,
      'isOutstation': isOutstation,
      'actualReportingDate': actualReportingDate,
      'actualReportingTime': actualReportingTime,
      'actualReleivingDate': actualReleivingDate,
      'actualReleivingTime': actualReleivingTime,
      'in_distanceBetweenPickupAndDrop': actualReleivingTime,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'operationCityId': cityId!,
    };

/** Oustation One-Way*/
    if (isOutstation == 'true' && isRoundTrip == 'false') {
      var calDist = await getDistance(
          double.parse(pickupLat),
          double.parse(pickupLng),
          double.parse(dropLat),
          double.parse(dropLng));

      if (calDist != null) {
        final jDecode = jsonDecode(calDist);
        final distance = jDecode['rows'][0]['elements'][0];
        // final parsedDist = jsonDecode(calDist);
        var calDi =
            distance['distance']['text'].replaceAll(RegExp(r'[A-Za-z,]'), '');
        // calDi.replaceAll(RegExp(r'[A-Za-z,]'), '');

        final expectedTravelTime = distance['duration']['value'];
        final calUrlWithDistance = kCalculateFare +
            "?carType=$carType&isRoundTrip=$isRoundTrip&isOutstation=$isOutstation&actualReportingDate=$actualReportingDate&actualReportingTime=$actualReportingTime&actualReleivingDate=$actualReleivingDate&actualReleivingTime=$actualReleivingTime&pickupLat=$pickupLat&pickupLng=$pickupLng&dropLat=$dropLat&dropLng=$dropLng&operationCityId=$cityId&distanceBetweenPickupAndDrop=$calDi&actualTravelTime=$expectedTravelTime";

        print('after Cal Distance' + kBaseUrl + calUrlWithDistance);

        var response = await http.get(
          Uri.parse(kBaseUrl + calUrlWithDistance),
          // headers: {"Content-Type": "application/x-www-form-urlencoded"},
        );

        print("calculateFareWithDistance ${response.statusCode}");
        if (response.statusCode == 200) {
          return response.body;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      final calUrl = kCalculateFare +
          "?carType=$carType&isRoundTrip=$isRoundTrip&isOutstation=$isOutstation&actualReportingDate=$actualReportingDate&actualReportingTime=$actualReportingTime&actualReleivingDate=$actualReleivingDate&actualReleivingTime=$actualReleivingTime&pickupLat=$pickupLat&pickupLng=$pickupLng&dropLat=$dropLat&dropLng=$dropLng&operationCityId=$cityId&distanceBetweenPickupAndDrop=0";

      print(kBaseUrl + calUrl);

      var response = await http.get(
        Uri.parse(kBaseUrl + calUrl),
        // headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      print("calculateFare ${response.body}");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    }
  }

  Future<String?> createNewBoking(
      String carType,
      String isRoundTrip,
      String isOutstation,
      String reportingDate,
      String reportingTime,
      String releivingDate,
      String releivingTime,
      String releavingDuration,
      // String? landmark,
      String pickupAddress,
      String pickupLat,
      String pickupLng,
      String dropAddress,
      String dropLat,
      String dropLng,
      String cityName,
      String cityLat,
      String cityLng,
      String totalAmount,
      String promoCode) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = prefs.getString("customerDetails");
    final parsed = jsonDecode(userSession!);

    final userCityName = await DataProvider().getCityName();

    print("after sessionData");

    if (promoCode.isNotEmpty) {
      Map<String, String> payload = {
        'carType': carType.substring(0, 1),
        'isRoundTrip': isRoundTrip,
        'isOutstation': isOutstation,
        'reportingDate': reportingDate,
        'reportingTime': reportingTime.substring(0, 5),
        'releivingDate': releivingDate.isNotEmpty ? releivingDate : "",
        'releivingTime':
            releivingTime.isNotEmpty ? releivingTime.substring(0, 5) : "",
        'releavingDuration':
            releavingDuration.isNotEmpty ? releavingDuration : "",
        'landmark': pickupAddress,
        'pickupAddress': pickupAddress,
        'pickupLat': pickupLat,
        'pickupLng': pickupLng,
        'dropAddress': dropAddress.isNotEmpty ? dropAddress : "",
        'dropLat': dropLat.isNotEmpty ? dropLat : "",
        'dropLng': dropLng.isNotEmpty ? dropLng : "",
        'cityName': cityName.isNotEmpty ? cityName : "",
        'cityLat': cityLat.isNotEmpty ? cityLat : "",
        'cityLng': cityLng.isNotEmpty ? cityLng : "",
        'totalAmount': totalAmount,
        'customerId': parsed[0]['id'],
        'userId': parsed[0]['conuser_id'],
        'paymentMethod': 'c',
        'operationCity': userCityName!,
        'promoCode': promoCode
      };
      print("createNewBokingPromoCode $payload");

      var response = await http.post(
          Uri.parse(kBaseUrl + kCreateNewBookingPromoCode),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: payload);

      print("createNewBokingPromoCode ${response.body}");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } else {
      if (isOutstation == 'true' && isRoundTrip == 'false') {
        var calDist = await getDistance(
            double.parse(pickupLat),
            double.parse(pickupLng),
            double.parse(dropLat),
            double.parse(dropLng));

        if (calDist != null) {
          final jDecode = jsonDecode(calDist);
          final distance = jDecode['rows'][0]['elements'][0];
          // final parsedDist = jsonDecode(calDist);
          var calDi =
              distance['distance']['text'].replaceAll(RegExp(r'[A-Za-z,]'), '');
          // calDi.replaceAll(RegExp(r'[A-Za-z,]'), '');

          final expectedTravelTime = distance['duration']['value'];
          Map<String, String> payload = {
            'carType': carType.substring(0, 1),
            'isRoundTrip': isRoundTrip,
            'isOutstation': isOutstation,
            'reportingDate': reportingDate,
            'reportingTime': reportingTime.substring(0, 5),
            'releivingDate': releivingDate.isNotEmpty ? releivingDate : "",
            'releivingTime':
                releivingTime.isNotEmpty ? releivingTime.substring(0, 5) : "",
            'releavingDuration':
                releavingDuration.isNotEmpty ? releavingDuration : "",
            'landmark': pickupAddress,
            'pickupAddress': pickupAddress,
            'pickupLat': pickupLat,
            'pickupLng': pickupLng,
            'dropAddress': dropAddress.isNotEmpty ? dropAddress : "",
            'dropLat': dropLat.isNotEmpty ? dropLat : "",
            'dropLng': dropLng.isNotEmpty ? dropLng : "",
            'cityName': cityName.isNotEmpty ? cityName : "",
            'cityLat': cityLat.isNotEmpty ? cityLat : "",
            'cityLng': cityLng.isNotEmpty ? cityLng : "",
            'totalAmount': totalAmount,
            'customerId': parsed[0]['id'],
            'userId': parsed[0]['conuser_id'],
            'paymentMethod': 'c',
            'operationCity': userCityName!,
            'dutyBasis': '0',
            'extraCharges': '0',
            'distanceBetweenPickupAndDrop': calDi
          };
          print("createNewBoking $payload");
          var response = await http.post(
              Uri.parse(kBaseUrl + kCreateNewBooking),
              headers: {"Content-Type": "application/x-www-form-urlencoded"},
              body: payload);

          print("createNewBoking ${response.body}");
          if (response.statusCode == 200) {
            return response.body;
          } else {
            return null;
          }
        }
      } else {
        Map<String, String> payload = {
          'carType': carType.substring(0, 1),
          'isRoundTrip': isRoundTrip,
          'isOutstation': isOutstation,
          'reportingDate': reportingDate,
          'reportingTime': reportingTime.substring(0, 5),
          'releivingDate': releivingDate.isNotEmpty ? releivingDate : "",
          'releivingTime':
              releivingTime.isNotEmpty ? releivingTime.substring(0, 5) : "",
          'releavingDuration':
              releavingDuration.isNotEmpty ? releavingDuration : "",
          'landmark': pickupAddress,
          'pickupAddress': pickupAddress,
          'pickupLat': pickupLat,
          'pickupLng': pickupLng,
          'dropAddress': dropAddress.isNotEmpty ? dropAddress : "",
          'dropLat': dropLat.isNotEmpty ? dropLat : "",
          'dropLng': dropLng.isNotEmpty ? dropLng : "",
          'cityName': cityName.isNotEmpty ? cityName : "",
          'cityLat': cityLat.isNotEmpty ? cityLat : "",
          'cityLng': cityLng.isNotEmpty ? cityLng : "",
          'totalAmount': totalAmount,
          'customerId': parsed[0]['id'],
          'userId': parsed[0]['conuser_id'],
          'paymentMethod': 'c',
          'operationCity': userCityName!,
          'dutyBasis': '0',
          'extraCharges': '0',
          'distanceBetweenPickupAndDrop': '0'
        };
        print("createNewBoking $payload");
        var response = await http.post(Uri.parse(kBaseUrl + kCreateNewBooking),
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: payload);

        print("createNewBoking ${response.body}");
        if (response.statusCode == 200) {
          return response.body;
        } else {
          return null;
        }
      }
    }
  }

  Future<String?> getBookingsToday() async {
    final customerDetails = await DataProvider().getSessionData();
    final session = await DataProvider().getToken();

    final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);

    print("after session data $jsonCustomer $session");
    var response = await http.get(Uri.parse(kBaseUrl +
        kGetDriverInvites +
        "?driverId=${jsonCustomer[0]['id']}&access_token=$session"));

    print("Booking Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getBookingsTomorrow() async {
    final customerDetails = await DataProvider().getSessionData();
    final session = await DataProvider().getToken();

    final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);

    print("after session data ${jsonCustomer[0]['id']} $session");
    var response = await http.get(Uri.parse(kBaseUrl +
        kGetDriverInvitesTomorrow +
        "?driverId=${jsonCustomer[0]['id']}&access_token=$session"));

    print("Booking Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getBookingsAssigned() async {
    final customerDetails = await DataProvider().getSessionData();
    final session = await DataProvider().getToken();

    final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);

    print("after session data ${jsonCustomer} $session");
    var response = await http.get(Uri.parse(kBaseUrl +
        kGetDriverDuty +
        "?driverId=${jsonCustomer[0]['id']}&access_token=$session"));

    print("Assigned Booking Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getCurrentDuty() async {
    final customerDetails = await DataProvider().getSessionData();
    final session = await DataProvider().getToken();

    final jsonCustomer = jsonDecode(customerDetails!);

    print("after session data ${jsonCustomer} $session");
    var response = await http.get(Uri.parse(kBaseUrl +
        kGetDriverCurrentDuty +
        "?driverId=${jsonCustomer[0]['id']}&access_token=$session"));

    print("getCurrentDuty Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getLocalCoordinates() async {
    final customerDetails = await DataProvider().getSessionData();
    final session = await DataProvider().getToken();
    final cityId = await DataProvider().getCityId();

    final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);

    print(
        " getLocalCoordinates after session data ${jsonCustomer[0]['id']} $session");
    var response = await http.get(Uri.parse(kBaseUrl +
        kLocalBoundries +
        "?filter=%7B%22where%22%3A%7B%22city_id%22%3A$cityId%7D%7D&access_token=$session"));

    print("getLocalCoordinates Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getBookingDetails(int bookingId) async {
    final customerDetails = await DataProvider().getSessionData();
    final session = await DataProvider().getToken();

    final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);

    print("after session data ${jsonCustomer[0]['id']} $session");
    var response = await http.get(Uri.parse(kBaseUrl +
        kGetBookings +
        "/findOne?filter=%7B%20%22where%22%3A%20%7B%20%22id%22%3A%20%22$bookingId%22%20%7D%2C%20%22include%22%3A%20%5B%20%7B%20%22relation%22%3A%20%22invoices%22%2C%20%22scope%22%3A%20%7B%20%22include%22%3A%20%7B%20%22relation%22%3A%20%22invoiceDetails%22%2C%20%22scope%22%3A%20%7B%20%22include%22%3A%20%7B%20%22relation%22%3A%20%22invoiceSubHeads%22%20%7D%20%7D%20%7D%2C%20%22order%22%3A%20%22id%20DESC%22%2C%20%22limit%22%3A%201%20%7D%20%7D%2C%20%7B%20%22relation%22%3A%20%22localBookings%22%20%7D%2C%20%7B%20%22relation%22%3A%20%22outstationBookings%22%20%7D%20%5D%20%7D&access_token=$session"));

    print("Booking Details Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getCancellationReasons() async {
    // final customerDetails = await DataProvider().getSessionData();
    final accessToken = await DataProvider().getToken();
    // final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);
    // print("after session data ${jsonCustomer[0]['id']} $session");
    var response = await http.get(Uri.parse(
        kBaseUrl + kCancellationReasons + "?access_token=$accessToken"));

    print("getCancellationReasons Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> cancelBooking(
      bookingId, cancellationId, cancellationReason) async {
    // final customerDetails = await DataProvider().getSessionData();
    final accessToken = await DataProvider().getToken();
    // final jsonCustomer = jsonDecode(customerDetails!);
    // final jsonSession = jsonDecode(session!);
    // print("after session data ${jsonCustomer[0]['id']} $session");

    Map<String, String> payload = {
      'bookingId': bookingId,
      'cancellationId': cancellationId,
      'cancellationReason': cancellationReason
    };

    var response = await http.post(Uri.parse(kBaseUrl + kCancelBooking),
        body: payload,
        headers: {'Cantent-Type': 'application/x-www-form-urlencoded'});

    print("cancelBooking Response ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getRateCard() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();
    var cityId = null;
    try {
      cityId = await DataProvider().getCityId();
    } catch (e) {
      if (cityId == null) {
        await AuthRepository().getCityId();
        cityId = await DataProvider().getCityId();
      }
    }

    var response = await http.get(
      Uri.parse(kBaseUrl +
          kGetRateCard +
          "?filter=%7B%22where%22%3A%7B%22or%22%3A%5B%7B%22and%22%3A%5B%7B%22operation_city_id%22%3A%22$cityId%22%7D%2C%7B%22type%22%3A%22Customer%22%7D%5D%7D%5D%7D%2C%22limit%22%3A1%7D&access_token=$accessToken"),
    );

    final jresp = jsonDecode(response.body);
    print("getRateCard ${response.body}");

    if (response.statusCode == 200) {
      // prefs.setString("getRateCard", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getDriverRateCard() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();
    var cityId = null;
    try {
      cityId = await DataProvider().getCityId();
    } catch (e) {
      if (cityId == null) {
        await AuthRepository().getCityId();
        cityId = await DataProvider().getCityId();
      }
    }

    var response = await http.get(
      Uri.parse(kBaseUrl +
          kGetRateCard +
          "?filter=%7B%22where%22%3A%7B%22or%22%3A%5B%7B%22and%22%3A%5B%7B%22operation_city_id%22%3A%22$cityId%22%7D%2C%7B%22type%22%3A%22Driver%22%7D%5D%7D%5D%7D%2C%22limit%22%3A1%7D&access_token=$accessToken"),
    );

    final jresp = jsonDecode(response.body);
    print("getRateCard ${response.body}");

    if (response.statusCode == 200) {
      // prefs.setString("getRateCard", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> createMonthlyDriverRequest(
    String carType,
    String dutyHours,
    String salaryBudget,
    String naturOfDuty,
    String weeklyOff,
    String operationCity,
  ) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = prefs.getString("customerDetails");
    final parsed = jsonDecode(userSession!);

    print("after sessionData $weeklyOff");
    Map<String, String> payload = {
      'customerId': parsed[0]['id'],
      'createdBy': parsed[0]['id'],
      'remark': naturOfDuty,
      'carType': carType == '0'
          ? 'M'
          : carType == '1'
              ? 'A'
              : 'L',
      'dutyHours': dutyHours,
      'salaryBudget': salaryBudget,
      'naturOfDuty': naturOfDuty,
      'weeklyOff': '{$weeklyOff}',
      'operationCity': operationCity,
    };
    print("createMonthlyDriverRequest $payload");
    var response = await http.post(
        Uri.parse(kBaseUrl + kCreateMonthlyDriverRequest),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: payload);

    print("createMonthlyDriverRequest ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> updateProfile(
      mobileNumber,
      firstName,
      lastName,
      addressLine1,
      addressLine2,
      email,
      addressLine1Latitude,
      addressLine1Longitude,
      middleName,
      emergencyNumber,
      freeAddress) async {
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    // final updateReq = UpdateRequestModel(
    //     addressLine1,
    //     double.parse(addressLine1Latitude),
    //     addressLine2,
    //     double.parse(addressLine1Longitude),
    //     email,
    //     firstName,
    //     int.parse(parsed[0]['id']),
    //     lastName,
    //     int.parse(parsed[0]['id']),
    //     DateTime.now().toString());

    var cityName = await DataProvider().getCityName();

    if (cityName == null) {
      await AuthRepository().getCityId();
      cityName = await DataProvider().getCityId();
    }
    Map<String, String> payload = {
      // 'userId': parsed[0]['id'].toString(),
      // 'firstName': firstName,
      // 'middleName': middleName,
      // 'lastName': lastName,
      // 'email': email,
      // 'address': addressLine1,
      // 'addressLine2': addressLine2,
      // 'updatedBy': parsed[0]['id'].toString(),
      // 'updatedDate': DateTime.now().toString(),
      // 'address_lat': addressLine1Latitude,
      // 'address_long': addressLine1Longitude,
      // 'operationCity': cityName!,
      'emergencyNumber': emergencyNumber,
      'freeAddress': freeAddress
    };

    // return null;
    final accessToken = await DataProvider().getToken();
    print(
        "Profile Update Payload ${payload} ${kDriverDetails + "/${parsed[0]['id']}&access_token=$accessToken"}");
    var response = await http.put(
      Uri.parse(kBaseUrl + kDriverDetails + "/${parsed[0]['id']}"),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );
    // .timeout(Duration(seconds: 60000));

    print('update Response ${response}');

    if (response.statusCode == 200) {
      return "Profile Updated Successfully";
    } else {
      return null;
    }
  }

  /// Driver */
  Future<String?> registerDriver(
      mobileNumber,
      firstName,
      lastName,
      email,
      operationCity,
      addressLine1Latitude,
      addressLine1Longitude,
      middleName,
      isLuxury,
      freeAddress,
      googleAddress,
      birthdate,
      licenseIssueDate,
      vehicle,
      otp) async {
    Map<String, String> payload = {
      "mobileNumber": mobileNumber,
      "email": email,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "username": mobileNumber,
      "password": mobileNumber,
      "isLuxury": isLuxury,
      "freeAddress": freeAddress,
      "otp": otp.toString(),
      "addressLat": addressLine1Latitude.toString(),
      "addressLong": addressLine1Longitude.toString(),
      "googleAddress": googleAddress,
      "BDate": birthdate,
      "licenseIssueDate": licenseIssueDate,
      "vehicle": vehicle,
      "operationCity": operationCity
    };
    print("Registration Payload $payload");

    var response = await http.post(
      Uri.parse(kBaseUrl + kCreateDriver),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> acceptDuty(
      bookingId, BookingResponseModel bookingResponseModel) async {
    String? userSession = await DataProvider().getSessionData();
    final driverDetails = jsonDecode(userSession!);

    Map<String, String> payload = {
      "driverId": driverDetails[0]['id'].toString(),
      "bookingId": bookingId,
      "oldDriverId": "0",
    };

    var response = await http.post(
      Uri.parse(kBaseUrl + kAcceptDuty),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("accept Resp ${response.body}");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      try {
        if (json[0]['accept_duty'] == "Accepted") {
          smsToDriverAtAccept(bookingResponseModel);
          smsToCustomerAtAccept(bookingResponseModel);
        }
      } catch (e) {
        print("Accept SMS Problem $e");
      }
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> createAllocationHistory(bookingId, allocationStatus) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);

    Map<String, String> payload = {
      "driverId": driverDetails[0]['id'].toString(),
      "bookingId": bookingId,
      "allocationStatus": allocationStatus,
      "userId": userId.toString()
    };

    var response = await http.post(
      Uri.parse(kBaseUrl + kCreateAllocationHistory),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("accept Resp ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> startDuty(AssignedBookingResponseModel booking) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);

    Map<String, String> payload = {
      "conuserId": driverDetails[0]['conuserId'].toString(),
      "driverId": driverDetails[0]['id'].toString(),
      "bookingId": booking.id!,
      "customerId": booking.customerId!,
      "pickupAddress": booking.pickAddress!,
      "pickupLat": booking.fromLat.toString(),
      "pickupLong": booking.fromLong.toString()
    };

    var response = await http.post(
      Uri.parse(kBaseUrl + kStartDuty),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("start duty Resp ${response.body}");

    if (response.statusCode == 200) {
      // sendSmsToCustomerAtStart(
      //     booking.firstName! + " " + booking.lastName!,
      //     booking.reportingDate,
      //     booking.reportingTime,
      //     booking.id,
      //     booking.mobileNumber);

      // sendSmsToDriverAtStart(
      //     booking.reportingDate, booking.reportingTime, booking.id);

      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> cancelDuty(AssignedBookingResponseModel booking) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);

    Map<String, String> payload = {
      "userId": driverDetails[0]['conuserId'].toString(),
      "driverId": driverDetails[0]['id'].toString(),
      "bookingId": booking.id!,
      // "customerId": booking.customerId!,
      // "pickupAddress": booking.pickAddress!,
      // "pickupLat": booking.fromLat.toString(),
      // "pickupLong": booking.fromLong.toString()
    };

    var response = await http.post(
      Uri.parse(kBaseUrl + kCancelDuty),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("cancelDuty Resp ${response.body}");

    if (response.statusCode == 200) {
      smsToCustomerAtCancelDuty(booking);
      smsToDriverAtCancelDuty(booking);

      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> updateInvoiceOnStartDuty(
      AssignedBookingResponseModel booking, String requestFrom) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);
    Map<String, String> payload = {};

    if (booking.isOutstation! && !booking.isRoundTrip!) {
      var calDist = await getDistance(booking.fromLat!, booking.fromLong!,
          booking.dropLat!, booking.dropLong!);

      if (calDist != null) {
        final jDecode = jsonDecode(calDist);
        final distance = jDecode['rows'][0]['elements'][0];
        // final parsedDist = jsonDecode(calDist);
        var calDi =
            distance['distance']['text'].replaceAll(RegExp(r'[A-Za-z,]'), '');
        payload = {
          "bookingId": booking.id!,
          "requestFrom": requestFrom,
          "distanceBetweenPickupAndDrop": calDi,
        };
      }
    } else {
      payload = {
        "bookingId": booking.id!,
        "requestFrom": requestFrom,
        "distanceBetweenPickupAndDrop": "0",
      };
    }

    var response = await http.post(
      Uri.parse(kDomain + kUpdateInvoiceOnStartAndOffDuty),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("start duty Resp ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> updateInvoiceOnOffDuty(
      CurrentDutyResponseModel booking, String requestFrom) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);
    Map<String, String> payload = {};

    Position position = await DataProvider().determinePosition();
    print(position);

    if (booking.isOutstation! && !booking.isRoundTrip!) {
      var calDist = await getDistance(booking.pickLat!, booking.pickLong!,
          position.latitude, position.longitude);

      if (calDist != null) {
        final jDecode = jsonDecode(calDist);
        final distance = jDecode['rows'][0]['elements'][0];
        // final parsedDist = jsonDecode(calDist);
        var calDi =
            distance['distance']['text'].replaceAll(RegExp(r'[A-Za-z,]'), '');
        payload = {
          "bookingId": booking.bookingId!,
          "requestFrom": requestFrom,
          "distanceBetweenPickupAndDrop": calDi,
        };
      }
    } else {
      payload = {
        "bookingId": booking.bookingId!,
        "requestFrom": requestFrom,
        "distanceBetweenPickupAndDrop": "0",
      };
    }

    var response = await http.post(
      Uri.parse(kDomain + kUpdateInvoiceOnStartAndOffDuty),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("start duty Resp ${response.body}");

    if (response.statusCode == 200) {
      Future.delayed(const Duration(seconds: 3));
      sendSMSToCustomerAfterOffDuty(booking);
      sendSMSToCustomerAfterOffDuty1(booking);
      // sendSMSToCustomerAfterOffDuty2(booking);
      sendSMSToDriverAfterOffDuty(booking);
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> offDuty(CurrentDutyResponseModel booking) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);

    Position position = await DataProvider().determinePosition();
    print(position);

    final address = await getAddressFromCoordinates(
        position.latitude.toString(), position.longitude.toString());
    print(address);
    final jsonResponse = jsonDecode(address!);

    jsonResponse['results'][0]['address_components'].forEach((e) {});

    Map<String, String> payload = {
      "bookingId": booking.bookingId!,
      "dropLocation": booking.dropAddress!,
      "dropLat": position.latitude.toString(),
      "dropLong": position.longitude.toString(),
      "updatedBy": driverDetails[0]['conuserId'].toString()
    };

    var response = await http.post(
      Uri.parse(kBaseUrl + kOffDuty),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("off duty Resp ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> paidDutyFunction(CurrentDutyResponseModel booking) async {
    String? userSession = await DataProvider().getSessionData();
    String? userId = await DataProvider().getUserId();
    final driverDetails = jsonDecode(userSession!);

    Map<String, String> payload = {
      "bookingId": booking.bookingId!,
      "paymentMethod": 'D',
      "userId": driverDetails[0]['conuserId'].toString()
    };

    var response = await http.post(
      Uri.parse(kBaseUrl + kPaidDutyFunction),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("kPaidDutyFunction Resp ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getLocalDriverSummary() async {
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    var response = await http.get(
        Uri.parse(kBaseUrl +
            getDriverLocalSummary +
            "?driverId=${parsed[0]['id'].toString()}&access_token=$accessToken"),
        headers: {'Cantent-Type': 'application/json'});

    final jresp = jsonDecode(response.body);
    print("getLocalDriverSummary ${response.body}");

    if (response.statusCode == 200) {
      // prefs.setString("getRateCard", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getOutstationDriverSummary() async {
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    var response = await http.get(
        Uri.parse(kBaseUrl +
            getDriverOutstationSummary +
            "?driverId=${parsed[0]['id'].toString()}&access_token=$accessToken"),
        headers: {'Cantent-Type': 'application/json'});

    final jresp = jsonDecode(response.body);
    print("getDriverOutstationSummary ${response.body}");

    if (response.statusCode == 200) {
      // prefs.setString("getRateCard", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getNews() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    var cityId = null;
    try {
      cityId = await DataProvider().getCityId();
    } catch (e) {
      if (cityId == null) {
        await AuthRepository().getCityId();
        cityId = await DataProvider().getCityId();
      }
    }

    print("CityId ${cityId}");

    var response = await http.get(
      Uri.parse(kBaseUrl +
          kGetNews +
          "?filter=%7B%22where%22%3A%7B%22operation_city_id%22%3A%22$cityId%22%7D%7D&access_token=$accessToken"),
    );

    final jresp = jsonDecode(response.body);
    print("getNews ${response.body}");

    if (response.statusCode == 200) {
      // prefs.setString("getRateCard", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  Future<List<InvoiceResponseModel>?> getInvoice(
      CurrentDutyResponseModel currentDutyResponseModel) async {
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    Map<String, Object> scopeWhere = {
      "bookingId": currentDutyResponseModel.bookingId!
    };

    Map<String, Object> mainObj = {
      "where": scopeWhere,
    };
    var response = await http.get(
      Uri.parse(kBaseUrl +
          kGetInvoice +
          "?filter=${jsonEncode(mainObj)}&access_token=$accessToken"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map<InvoiceResponseModel>(
              (invoice) => InvoiceResponseModel.fromJson(invoice))
          .toList();
    } else {
      return null;
    }
  }

  Future<String?> getJobs() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    await AuthRepository().getCityId();

    //{                     "where": {                         "status": "Open",                         "location":  "Pune"                     },                     "include": {                         "relation": "driverJobRequest",                         "scope": {                             "where": {                                 "driverId": 35860                             }                         }                     },                     "order": "createdDate DESC"                 }

    final cityId = await DataProvider().getCityId();

    Map<String, Object> where = {
      "status": "Open",
      "location": parsed[0]['conUsers']['operationCity']
    };
    Map<String, Object> driverId = {"driverId": parsed[0]['id']};
    Map<String, Object> scopeWhere = {"where": driverId};
    Map<String, Object> include = {
      "relation": "driverJobRequest",
      "scope": scopeWhere
    };

    Map<String, Object> mainObj = {
      "where": where,
      "include": include,
      "order": "createdDate DESC"
    };

    print("Main Obj ${jsonEncode(mainObj)}");

    var response = await http.get(
      Uri.parse(kBaseUrl +
          kDriverJobDetails +
          "?filter=${jsonEncode(mainObj)}&access_token=$accessToken"),
    );

    final jresp = jsonDecode(response.body);
    print("getJobs ${response.body}");

    if (response.statusCode == 200) {
      // prefs.setString("getRateCard", response.body);
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> applyJobs(JobsResponseModel jobsResponseModel) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userSession = await DataProvider().getSessionData();
    final parsed = jsonDecode(userSession!);
    print('parsed user $parsed');
    final accessToken = await DataProvider().getToken();

    Map<String, String> mainObj = {
      "jobId": jobsResponseModel.id!.toString(),
      "driverId": parsed[0]['id'].toString(),
      "userId": parsed[0]['conUsers']['id'].toString()
    };

    print("applyJobs Main Obj ${jsonEncode(mainObj)}");

    var response = await http.post(
      Uri.parse(kBaseUrl + kApplyDriverJob),
      body: mainObj,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    final jresp = jsonDecode(response.body);
    print("applyJobs ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> getAppVersion() async {
    try {
      var response = await http.post(Uri.parse(kDomain + kGetAppVersion));
      print("AppVersion resp ${response.body}");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> sendSmsToCustomerAtStart(
      String customerName, date, time, assignId, mobileNumber) async {
    var time1 = DateFormat("hh:mm:ss a").parse(time);
    date = DateFormat("dd/MM/yyyy").format(date);
    var msg = "";
    var templateId = "";

    if (time1.isAfter(DateFormat("hh:mm:ss a").parse('10:00:00 PM')) ||
        time1.isBefore(DateFormat("hh:mm:ss a").parse('06:00:00 AM'))) {
      templateId = msg = "";
      msg = 'Hi ' +
          customerName +
          ',%0aThe journey has started for Booking Id:' +
          assignId +
          ' @ ' +
          time +
          ' Dated on ' +
          date +
          '. Stay on the app to track this ride. Rs 100 travel allowance applicable if reporting or relieving between 10pm to 5:45am. Have a safe Journey';
    } else {
      var msg = 'Hi ' +
          customerName +
          ',%0aThe journey has started for Booking Id:' +
          assignId +
          ' @ ' +
          time +
          ' Dated on ' +
          date +
          '. Stay on the app to track this ride. Have a safe Journey';
    }

    Map<String, dynamic> payload = {
      "mobileNumber": '$mobileNumber',
      "msg": msg,
    };

    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );
    print("sendSmsToCustomerAtStart" + response.body);

    return response.body;
  }

  Future<String?> sendSmsToDriverAtStart(date, time, assignId) async {
    date = DateFormat("dd/MM/yyyy").format(date);
    time = DateFormat("hh:mm:ss a").format(time);

    String? driverName = await DataProvider().getUserName();
    String? driverMobile = await DataProvider().getUserName();

    var msg = 'Hi ' +
        driverName! +
        ',%0aThe journey has started for Booking Id: ' +
        assignId +
        ' @ ' +
        time +
        ' Dated on ' +
        date +
        '. Have a safe Journey';

    Map<String, dynamic> payload = {
      "mobileNumber": '$driverMobile',
      "msg": msg,
    };

    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("sendSmsToDriverAtStart" + response.body);

    return response.body;
  }

  Future<void> sendSMSToCustomerAfterOffDuty(
      CurrentDutyResponseModel currentDutyResponseModel) async {
    try {
      var endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      var relTime = DateFormat('hh:mm a').format(DateTime.now());
      // var startDate = currentDutyResponseModel.reportingDate!.substring(0, 10);
      var startDate = DateFormat("dd-MM-yyyy hh:mm aa").format(DateTime.parse(
              "${currentDutyResponseModel.reportingDate!.substring(0, 10)}T${currentDutyResponseModel.reportingTime!}.000Z")
          .add(const Duration(days: 1)));
      // var rptTime = DateFormat("hh:mm a").format(DateTime.parse(
      //     currentDutyResponseModel.reportingTime!.substring(0, 5)));
      var time1 = DateFormat('hh:mm:ss a').format(DateTime.now());

      List<InvoiceResponseModel>? invoice =
          await getInvoice(currentDutyResponseModel);

      var billedAmmount = 0.00;
      if (invoice != null) {
        billedAmmount = (invoice[0].grossAmount)!;
      }

      var customerName = currentDutyResponseModel.firstName!;

      // var templateId = "1707164576713062539";
      var templateId = "1707164576744230540";

      // var msg = '\'Dear ' +
      //     customerName +
      //     ', Your Duty(ID: ' +
      //     currentDutyResponseModel.bookingId! +
      //     ') Started on: ' +
      //     startDate +
      //     ' @ ' +
      //     rptTime +
      //     ' Ended on: ' +
      //     endDate +
      //     ' @ ' +
      //     relTime +
      //     ' Total billed amount: Rs.' +
      //     billedAmmount.toString() +
      //     '/-. Rs 100 travel allowance applicable if reporting or relieving between 10pm to 5:45am. For details download app (https://goo.gl/XFPFwh). For inquiries call 020-67641000. click for rate card details (shorturl.at/aoLUV) Thank you, Indian Drivers.';
      var msg = 'Dear ' +
          customerName +
          ', Your Duty(ID: ' +
          currentDutyResponseModel.bookingId! +
          ') Started on: ' +
          startDate.substring(0, 10) +
          ' @ ' +
          startDate.substring(11, 19) +
          ' Ended on: ' +
          endDate +
          ' @ ' +
          relTime +
          ' Total billed amount Rs.' +
          billedAmmount.toString() +
          ' plus Rs.100 travel allowance if reporting or relieving between 10pm to 5:45am. For details download app (https://goo.gl/XFPFwh). Thank you, Indian Drivers 020-67641000.&templateid=$templateId';
      // var msg =
      //     "Dear $customerName, Your Duty(ID: ${currentDutyResponseModel.bookingId!}) Started on: ${startDate.substring(0, 10)} @ ${startDate.substring(11, 19)} Ended on: $endDate @ $relTime Total billed amount: Rs.${billedAmmount.toString()}/-. Rs 100 travel allowance applicable if reporting or relieving between 10pm to 5:45am. For details download app (https://goo.gl/XFPFwh). For inquiries call 020-67641000. click for rate card details (shorturl.at/aoLUV) Thank you, Indian Drivers.&templateid=$templateId";

      // Map<String, dynamic> payload = {
      //   "mobileNumber": currentDutyResponseModel.mobileNumber,
      //   "msg": msg,
      // };

      // print(payload);
      // var response = await http.post(
      //   Uri.parse(kBaseUrl + kSendSMS),
      //   body: payload,
      //   headers: {
      //     "Content-Type": "application/x-www-form-urlencoded",
      //   },
      //   encoding: Encoding.getByName('utf-8'),
      // );

      // print("sendSMSToCustomerAfterOffDuty" + response.body);

      // return response.body;

      if (billedAmmount != 0.00) {
        await sendSMSGeneral(msg, templateId, currentDutyResponseModel);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendSMSToCustomerAfterOffDuty1(
      CurrentDutyResponseModel currentDutyResponseModel) async {
    String time1;
    String endDate;
    String relTime;
    String startDate;
    String rptTime;

    try {
      endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      relTime = DateFormat('hh:mm a').format(DateTime.now());
      // var startDate = currentDutyResponseModel.reportingDate!.substring(0, 10);
      var startDate = DateFormat("dd-MM-yyyy hh:mm aa").format(DateTime.parse(
              "${currentDutyResponseModel.reportingDate!.substring(0, 10)}T${currentDutyResponseModel.reportingTime!}.000Z")
          .add(const Duration(days: 1)));
      // var rptTime = DateFormat("hh:mm a").format(DateTime.parse(
      //     currentDutyResponseModel.reportingTime!.substring(0, 5)));

      time1 = DateFormat('hh:mm:ss a').format(DateTime.now());

      List<InvoiceResponseModel>? invoice =
          await getInvoice(currentDutyResponseModel);

      var billedAmmount = 0.00;
      if (invoice != null) {
        billedAmmount = (invoice[0].grossAmount)!;
      }

      var customerName = currentDutyResponseModel.firstName!;

      var templateId = "1707164576707565495";

      // var msg = '\'Dear ' +
      //     customerName +
      //     ', Your Duty(ID: ' +
      //     currentDutyResponseModel.bookingId! +
      //     ') Started on: ' +
      //     startDate +
      //     ' @ ' +
      //     rptTime +
      //     ' Ended on: ' +
      //     endDate +
      //     ' @ ' +
      //     relTime +
      //     ' Total billed amount: Rs.' +
      //     billedAmmount.toString() +
      //     '/-. Rs 100 travel allowance applicable if reporting or relieving between 10pm to 5:45am. For details download app (https://goo.gl/XFPFwh). For inquiries call 020-67641000. click for rate card details (shorturl.at/aoLUV) Thank you, Indian Drivers.';

      var msg =
          "Dear $customerName, Your Duty(ID: ${currentDutyResponseModel.bookingId!}) Started on: ${startDate.substring(0, 10)} @ ${startDate.substring(11, 19)} Ended on: $endDate @ $relTime For details download app (https://goo.gl/XFPFwh). For inquiries call 020-67641000. click for rate card details (shorturl.at/aoLUV) Thank you, Indian Drivers.&templateid=$templateId";
      if (billedAmmount != 0.00) {
        await sendSMSGeneral(msg, templateId, currentDutyResponseModel);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendSMSToCustomerAfterOffDuty2(
      CurrentDutyResponseModel currentDutyResponseModel) async {
    var endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var relTime = DateFormat('hh:mm a').format(DateTime.now());
    var startDate = currentDutyResponseModel.reportingDate!.substring(0, 10);
    var rptTime = DateFormat("HH:mm:ss")
        .format(DateTime.parse(currentDutyResponseModel.reportingTime!));
    var time1 = DateFormat('hh:mm:ss a').format(DateTime.now());

    List<InvoiceResponseModel>? invoice =
        await getInvoice(currentDutyResponseModel);

    var billedAmmount = 0.00;
    if (invoice != null || invoice!.isNotEmpty) {
      billedAmmount = (invoice[0].grossAmount)!;
    }
    var customerName = currentDutyResponseModel.firstName!;

    var templateId = "1707164576694227173";

    var msg =
        "Dear $customerName, Your Duty(ID: ${currentDutyResponseModel.bookingId!}) ended on $endDate @ $relTime. started was on ${startDate.substring(0, 10)} @ ${startDate.substring(11, 19)} Your total billed amount is Rs.${billedAmmount.toString()}/-. For details download app (https://goo.gl/Z5tDgU). For inquiries call 020-67641000 Thank you Indian Drivers.&templateid=$templateId";

    if (billedAmmount != 0.00) {
      sendSMSGeneral(msg, templateId, currentDutyResponseModel);
    }
  }

  Future<String?> sendSMSToDriverAfterOffDuty(
      CurrentDutyResponseModel currentDutyResponseModel) async {
    String endDate = "";
    String relTime = "";
    String startDate = "";
    String rptTime = "";
    String time1 = "";

    try {
      endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      relTime = DateFormat('hh:mm a').format(DateTime.now());
      var startDate = DateFormat("dd-MM-yyyy hh:mm aa").format(DateTime.parse(
              "${currentDutyResponseModel.reportingDate!.substring(0, 10)}T${currentDutyResponseModel.reportingTime!}.000Z")
          .add(const Duration(days: 1)));
      // var rptTime = DateFormat("hh:mm a").format(DateTime.parse(
      //     currentDutyResponseModel.reportingTime!.substring(0, 5)));
      time1 = DateFormat('hh:mm:ss a').format(DateTime.now());

      List<InvoiceResponseModel>? invoice =
          await getInvoice(currentDutyResponseModel);

      var billedAmmount = 0.00;
      if (invoice != null) {
        billedAmmount = (invoice[0].grossAmount)!;
      }

      var customerName = currentDutyResponseModel.firstName!;

      var driverName = await DataProvider().getUserName();
      var driverMobile = await DataProvider().getUserMobile();
      // var msg = 'Dear ' +
      //     driverName! +
      //     ',%0aYour Duty(ID: ' +
      //     currentDutyResponseModel.bookingId! +
      //     ') ended on ' +
      //     endDate +
      //     ' @ ' +
      //     relTime +
      //     '. started was on ' +
      //     startDate +
      //     ' @ ' +
      //     rptTime +
      //     ' Your total billed amount is Rs.' +
      //     billedAmmount.toString() +
      //     '/-. For details download app (https://goo.gl/Z5tDgU). For inquiries call 020-67641000 Thank you Indian Drivers .';

      var templateId = "1707164576694227173";

      var msg =
          "Dear $driverName, Your Duty(ID: ${currentDutyResponseModel.bookingId!}) ended on $endDate @ $relTime. started was on ${startDate.substring(0, 10)} @ ${startDate.substring(11, 19)} Your total billed amount is Rs.${billedAmmount.toString()}/-. For details download app (https://goo.gl/Z5tDgU). For inquiries call 020-67641000 Thank you Indian Drivers.&templateid=$templateId";

      Map<String, dynamic> payload = {
        "mobileNumber": driverMobile,
        "msg": msg,
      };

      print(payload);
      var response = await http.post(
        Uri.parse(kBaseUrl + kSendSMS),
        body: payload,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
      );

      print("sendSMSToDriverAfterOffDuty" + response.body);

      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> smsToCustomerAtCancelDuty(
      AssignedBookingResponseModel assignedBookingResponseModel) async {
    var msg = 'Hi Name' +
        assignedBookingResponseModel.firstName! +
        ',%0aWe are replacing the driver assigned to you for the Booking Id:' +
        assignedBookingResponseModel.id! +
        '. New Driver details will be messaged shortly. For queries, please reach us on 020-67641000 or info@indian-drivers.com.';

    Map<String, dynamic> payload = {
      "mobileNumber": assignedBookingResponseModel.mobileNumber,
      "msg": msg,
    };
    print("smsToCustomerAtCancelDuty Payload");
    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("smsToCustomerAtCancelDuty" + response.body);

    return response.body;
  }

  Future<String?> smsToDriverAtCancelDuty(
      AssignedBookingResponseModel assignedBookingResponseModel) async {
    var driverName = await DataProvider().getUserName();
    var driverMobile = await DataProvider().getUserMobile();

    String rpDate = DateFormat("dd-MM-yyyy").format(
        DateTime.parse(assignedBookingResponseModel.reportingDate!)
            .add(const Duration(days: 1)));

    var msg =
        "Hi $driverName,%0a Duty details assigned to you, booking Id: ${assignedBookingResponseModel.id}, reporting date $rpDate time ${assignedBookingResponseModel.reportingTime} has been cancelled. Please contact customer desk for details.";

    Map<String, dynamic> payload = {
      "mobileNumber": driverMobile,
      "msg": msg,
    };

    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("smsToDriverAtCancelDuty" + response.body);
    return response.body;
  }

  Future<String?> smsToCustomerAtAccept(
      BookingResponseModel bookingResponseModel) async {
    var rptTime = bookingResponseModel.reportingTime;
    var rptDate = DateFormat("dd-MM-yyyy").format(
        DateTime.parse(bookingResponseModel.relievingDate!)
            .add(const Duration(days: 1)));
    // var rptDate = $filter('date')(new Date(dateValue), 'dd-MM-yyyy');
    var cnumber = "020-67641000";
    String? driverName = await DataProvider().getUserName();
    String? driverMobile = await DataProvider().getUserMobile();

    var templateId = "1707164576699758907";

    var msg = 'Hi ' +
        bookingResponseModel.firstName! +
        ', Driver Name: ' +
        driverName! +
        ' (Contact Number: ' +
        driverMobile! +
        ') has been allocated to you for the booking dated ' +
        rptDate +
        ', booking Id: ' +
        bookingResponseModel.id! +
        '. For queries, please reach us on ' +
        cnumber +
        ' or info@indian-drivers.com.';

    msg =
        "Hi ${bookingResponseModel.firstName!}, Driver Name: $driverName (Contact Number: $driverMobile) has been allocated to you for the booking dated $rptDate, booking Id: ${bookingResponseModel.id!}. For queries, please reach us on 020-67641000 or info@indian-drivers.com.&templateid=$templateId";

    CustomerDetailsModel? customerDetailsModel =
        await getCustomerDetailsByUserId(bookingResponseModel.customerId!);

    Map<String, dynamic> payload = {
      "mobileNumber": customerDetailsModel!.conUsers!.mobileNumber!,
      "msg": msg,
    };

    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );
    print("smsToCustomerAtAccept" + response.body);

    return response.body;
  }

  Future<String?> smsToDriverAtAccept(BookingResponseModel booking) async {
    String? driverName = await DataProvider().getUserName();
    String? driverMobile = await DataProvider().getUserMobile();

    CustomerDetailsModel? customerDetailsModel =
        await getCustomerDetailsByUserId(booking.customerId!);

    String dutyType = "",
        carType = "",
        landmark = "",
        journeyType = "",
        dropadd = "";
    var rptTime = booking.reportingTime;
    if (booking.isOutstation == true) {
      dutyType = 'Outstation';
    } else {
      dutyType = 'Local';
    }
    if (booking.carType == 'M') {
      carType = 'Manual';
    } else if (booking.carType == 'A') {
      carType = 'Automatic';
    } else {
      carType = 'Luxury';
    }
    if (booking.landmark == 'null') {
      landmark = '';
    } else {
      landmark = booking.landmark! + ', ';
    }
    if (booking.isRoundTrip == true) {
      journeyType = 'Round Trip';
      dropadd = '';
    } else {
      journeyType = 'OneWay Trip';
      dropadd = ' Drop Address: ' + booking.dropAddress!;
    }
    if (booking.isOutstation == false) {
      var relHour = ' Releiving Hours: ' + (booking.relievingTime!);
    } else {
      var dateValue =
          DateTime.parse(booking.relievingDate!).add(const Duration(days: 1));
      var relTime = booking.relievingTime;
      var relDate = DateFormat("dd-MM-yyyy").format(
          DateTime.parse(booking.relievingDate!).add(const Duration(days: 1)));
      var relHour = ' Releiving Date And Time : ' + relDate + ' ' + relTime!;
    }
    var picadd = booking.landmark! + booking.pickAddress!;
    var dateValue1 = DateFormat("dd-MM-yyyy").format(
        DateTime.parse(booking.reportingDate!).add(const Duration(days: 1)));

    var msg = 'Hi ' +
        driverName! +
        ',%0aYour Booking ID: ' +
        booking.id! +
        ' Duty Type: ' +
        dutyType +
        ' ' +
        journeyType +
        ' Car: ' +
        carType +
        ' Reporting Date And Time: ' +
        dateValue1 +
        ' ' +
        booking.reportingTime! +
        '. Pick up Address: ' +
        picadd +
        dropadd +
        '. Customer: ' +
        customerDetailsModel!.conUsers!.firstName! +
        ', ' +
        customerDetailsModel.conUsers!.mobileNumber!;

    Map<String, dynamic> payload = {
      "mobileNumber": driverMobile,
      "msg": msg,
    };

    print(payload);
    var response = await http.post(
      Uri.parse(kBaseUrl + kSendSMS),
      body: payload,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    print("smsToDriverAtAccept" + response.body);

    return response.body;
  }

  Future<String?> sendSMSGeneral(msg, templateId,
      CurrentDutyResponseModel currentDutyResponseModel) async {
    // final customerNumber = await DataProvider().getUserMobile();

    Map<String, dynamic> payload = {
      "mobileNumber": currentDutyResponseModel.mobileNumber,
      "msg": msg,
    };

    print('sendSMSToCustomerAfterBooking');
    print(payload);
    try {
      var response = await http.post(
        Uri.parse(kBaseUrl + kSendSMS),
        body: payload,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
      );

      print("sendSMSToCustomerAfterBooking" + response.body);

      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
