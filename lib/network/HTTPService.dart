import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kuber_starline/constants/api_constants.dart';

import 'models/bid_model.dart';

class HTTPService {
  Future<http.Response> registerUser({
    String email,
    String mobile,
    String name,
    String fcmtoken,
    String password,
    String username,
  }) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_REGISTER),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': ''
            },
            body: jsonEncode({
              "Name": name,
              "Email": email,
              "Mobile": mobile,
              'fcmtoken': fcmtoken,
              'UserName': username,
              'Password': password,
            }));

    print('Register response: ${response.body}');
    return response;
  }

  Future<http.Response> loginUser({
    String mobile,
    String password,
    String fcmToken,
  }) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_LOGIN),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': ''
            },
            body: jsonEncode({
              "Mobile": mobile,
              "password": password,
              'fcmtoken': fcmToken,
            }));

    print('Login response: ${response.body}');
    return response;
  }

  Future<http.Response> loginUserWithMPIN({
    String imei,
    String mpin,
    String fcmToken,
  }) async {
    print('IMEI: $imei');

    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_LOGIN_WITH_MPIN),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': ''
            },
            body: jsonEncode({
              "MPIN": mpin,
              "IMEI": imei,
              'fcmtoken': fcmToken,
            }))
        .timeout(Duration(minutes: 2));

    print('Login with MPIN response: ${response.body}');
    return response;
  }

  Future<http.Response> fetchAllGames(String authToken) async {
    http.Response response = await http.get(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_ALL_GAMES),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken
      },
    ).timeout(Duration(minutes: 1));

    print('All games response: ${response.body}');
    return response;
  }

  Future<http.Response> fetchStarlineGames(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_STARLINE_GAMES),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken
      },
    ).timeout(Duration(minutes: 1));

    print('Starline games response: ${response.body}');
    return response;
  }

  Future<http.Response> changePassword(
      String authToken, String password) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_PASSWORD),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken
            },
            body: jsonEncode({
              "password": password,
            }));

    print('Change Password Response: ${response.body}');
    return response;
  }

  Future<http.Response> changePasswordNew(
      String password, String mobile, String email) async {
    http.Response response = await http.post(
        Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_PASSWORD_NEW),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
          'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
          'A-Token': ''
        },
        body: jsonEncode(
            {"password": password, "Mobile": mobile, 'Emailid': email}));

    print('Change Password Response: ${response.body}');
    return response;
  }

  Future<http.Response> forgotUserId(String mobile, String emailId) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_FORGOT_USER_ID),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': ''
            },
            body: jsonEncode({'Mobile': mobile, 'Emailid': emailId}));

    print('Forgot User Id Response: ${response.body}');
    return response;
  }

  Future<http.Response> getWalletDetails(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_GET_WALLET_DETAILS),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken
      },
    );

    print('Wallet details: ${response.body}');
    return response;
  }

  Future<http.Response> submitBid(
      String authToken, List<BidModel> listOfBidModels) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_GET_SUBMIT_BID),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken
            },
            body: jsonEncode({'data': listOfBidModels}));

    print('Bid Submitted: ${response.body}');
    return response;
  }

  Future<http.Response> fetchNotice(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_GET_RULES),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken
      },
    );

    print('Rules Fetched: ${response.body}');
    return response;
  }

  Future<http.Response> fetchHowToPlay(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_HOW_TO_PLAY),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken
      },
    );

    print('How to play fetched: ${response.body}');
    return response;
  }

  Future<http.Response> generateMpin(
      String authToken, String MPIN, String IMEI) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_GENERATE_MPIN),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"MPIN": MPIN, "IMEI": IMEI}));

    print('Generate MPIN: ${response.body}');
    return response;
  }

  Future<http.Response> fetchGameRate(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_GAME_RATES),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken,
      },
    );

    print('Game Rate: ${response.body}');
    return response;
  }

  Future<http.Response> fetchStarlineRate(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_STARLINE_GAME_RATES),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken,
      },
    );

    print('Starline Game Rate: ${response.body}');
    return response;
  }

  Future<http.Response> fetchJackpotRate(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_JACKPOT_GAME_RATES),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken,
      },
    );

    print('Jackpot Game Rate: ${response.body}');
    return response;
  }

  Future<http.Response> fetchGameList(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_GAME_LIST),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken,
      },
    );

    print('Game List: ${response.body}');
    return response;
  }

  Future<http.Response> fetchPlayingHistory(
      String gameId, DateTime selectedDate, String authToken) async {
    print(json.encode({
      "G_Id": gameId,
      "G_Date": DateFormat('yyyy-MM-dd').format(selectedDate)
    }).toString());

    http.Response response = await http.post(
        Uri.encodeFull(APIConstants.ENDPOINT_FETCH_PLAYING_HISTORY),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
          'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
          'A-Token': authToken,
        },
        body: jsonEncode({
          "G_Id": gameId,
          "G_Date": DateFormat('yyyy-MM-dd').format(selectedDate)
        }));

    print('Playing History: ${response.body}');
    return response;
  }

  Future<http.Response> fetchWinningHistory(
      String gameId, DateTime selectedDate, String authToken) async {
    http.Response response = await http.post(
        Uri.encodeFull(APIConstants.ENDPOINT_FETCH_WINNING_HISTORY),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
          'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
          'A-Token': authToken,
        },
        body: jsonEncode({
          "G_Id": gameId,
          "G_Date": DateFormat('yyyy-MM-dd').format(selectedDate)
        }));

    print('Winning History: ${response.body}');
    return response;
  }

  Future<http.Response> getFundWithdrawnHistory(String authToken) async {
    http.Response response = await http
        .post(
          Uri.encodeFull(APIConstants.ENDPOINT_GET_WITHDRAW_REQUEST_HISTORY),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) {
          return http.Response('', 404);
        });

    print('Fund Withdraw History: ${response.body}');
    return response;
  }

  Future<http.Response> getAddFundsRequestHistory(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_GET_ADD_FUNDS_REQUEST_HISTORY),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'A-Token': authToken,
      },
    );

    print('Fund Deposit History: ${response.body}');
    return response;
  }

  Future<http.Response> getJackpotGames(String authToken) async {
    http.Response response = await http
        .post(
          Uri.encodeFull(APIConstants.ENDPOINT_GET_JACKPOT_GAMES),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 3))
        .catchError((error) => {print('Socket Exception')});

    print('Jackpot Games: ${response.body}');
    return response;
  }

  Future<http.Response> uploadProfilePicture(
      String authToken, String base64String) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_UPDATE_PROFILE_PICTURE),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"profilepic": base64String}))
        .timeout(Duration(minutes: 3))
        .catchError((error) => {print('Socket Exception')});

    print('Update profile image: ${response.body}');
    return response;
  }

  Future<http.Response> changePhonePeNumber(
      String authToken, String phonePeNumber) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_PHONE_PE_NUMBER_CHANGE),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"Phonepayno": phonePeNumber}))
        .timeout(Duration(minutes: 3))
        .catchError((error) => {print('Socket Exception')});

    print('Update phonepe number: ${response.body}');
    return response;
  }

  Future<http.Response> changeGpayNumber(
      String authToken, String gpayNumber) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_GPAY_NUMBER_CHANGE),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"Googlepayno": gpayNumber}))
        .timeout(Duration(minutes: 3))
        .catchError((error) => {print('Socket Exception')});

    print('Update GPAY number: ${response.body}');
    return response;
  }

  Future<http.Response> changeAddress(String authToken, String address) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_ADDRESS),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({
              "Addres": address,
            }))
        .timeout(Duration(minutes: 3))
        .catchError((error) => {print('Socket Exception')});

    print('Update Address number: ${response.body}');
    return response;
  }

  Future<http.Response> changeBankDetails(String authToken, String bankName,
      String accountNumber, String ifscCode, String accountHolder) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_BANK_ADDRESS),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({
              "Bankname": bankName,
              "Acno": accountNumber,
              "IFSC": ifscCode,
              "Acholder": accountHolder
            }))
        .timeout(Duration(minutes: 3))
        .catchError((error) => {print('Socket Exception')});

    print('Bank Details updated: ${response.body}');
    return response;
  }

  Future<http.Response> changePaytmNumber(
      String authToken, String paytmNumber) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_CHANGE_PAYTM),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"Paytmno": paytmNumber}))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Socket Exception')});

    print('Update Address: ${response.body}');
    return response;
  }

  Future<http.Response> changeMobileNumber(
      String authToken, String mobileNumber) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_CHANGE_MOBILE_NUMBER),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"mobileno": mobileNumber}))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Socket Exception')});

    print('Update mobile number: ${response.body}');
    return response;
  }

  Future<http.Response> requestFunds(
      String authToken, String transactionAmount) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_REQUEST_FUND),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"TransactionAmt": transactionAmount}))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Request Fund: ${response.body}');
    return response;
  }

  Future<http.Response> addFunds(
      String authToken, String transactionAmount) async {
    http.Response response = await http
        .post(Uri.encodeFull(APIConstants.ENDPOINT_ADD_FUND),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'A-Token': authToken,
            },
            body: jsonEncode({"TransactionAmt": transactionAmount}))
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Add Fund: ${response.body}');
    return response;
  }

  Future<http.Response> getBanner(String authToken) async {
    http.Response response = await http
        .post(
          Uri.encodeFull(APIConstants.ENDPOINT_GET_BANNER),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
            'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
            'A-Token': authToken,
          },
        )
        .timeout(Duration(minutes: 1))
        .catchError((error) => {print('Exception: ${error.toString()}')});

    print('Get Banner: ${response.body}');
    return response;
  }

  Future<http.Response> recoverPassword(String mobile, String otp) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_RECOVER_PASSWORD),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00 ',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
            },
            body: jsonEncode({
              "Mobile": mobile,
              "OTP": otp,
            }));

    print('Recover password response: ${response.body}');
    return response;
  }

  Future<http.Response> createRazorPayOrder(String amount) async {
    http.Response response =
        await http.post(Uri.encodeFull(APIConstants.ENDPOINT_GET_ORDER_ID),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
              'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
              'A-Token': null,
            },
            body: jsonEncode({
              "amount": amount,
            }));

    print('Razorpay order created: ${response.body}');
    return response;
  }

  Future<http.Response> fetchNotifications(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_GET_NOTIFICATIONS),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'A-Token': authToken,
      },
    );

    print('Notifications: ${response.body}');
    return response;
  }

  Future<http.Response> fetchDetails() async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_GET_DETAILS),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'A-Token': '',
      },
    );

    print('Details: ${response.body}');
    return response;
  }

  Future<http.Response> fetchTransactionHistory(String authToken) async {
    http.Response response = await http.post(
      Uri.encodeFull(APIConstants.ENDPOINT_FETCH_TRANSACTION_HISTORY),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic S3ViZXJTYXR0YTpLdWJlclNhdHRhQDEyMzQ1',
        'X-ApiKey': '8f92cb92-c007-448b-b488-1650492dfd00',
        'A-Token': authToken
      },
    ).timeout(Duration(minutes: 1));

    print('Transaction History response: ${response.body}');
    return response;
  }
}
