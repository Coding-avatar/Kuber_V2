import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/src/response.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:kuber_starline/network/HTTPService.dart';
import 'package:kuber_starline/ui/DashboardScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";
  String username = "";
  String mobNumber = "";
  String authToken = "";
  String phonePeNumber = "";
  String gpayNumber = "";
  String addressLine = "";
  String cityLine = "";
  String pincodeLine = "";
  String bankName = "";
  String ifscCode = "";
  String account_number = "";
  String holder_name = "";
  String paytmNumber = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: AssetImage(
                        'images/casino_bg.jpg',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                      onTap: () {
                        onBackPressed();
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Container(
                          height: 80,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.mail_outline_rounded,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'User ID:   $username',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_android_rounded,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Mobile Number:  $mobNumber',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.asset(
                                      'images/ic_address.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    backgroundColor: Colors.lightBlueAccent,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add Address Detail',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              showAddressDialog();
                            },
                          )),
                      Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.asset(
                                      'images/ic_bank.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add Bank Detail',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              showBankDetailsDialog();
                            },
                          )),
                      Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.asset(
                                      'images/ic_paytm.png',
                                      height: 28,
                                      width: 28,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add Paytm Detail',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              showPaytmDialog();
                            },
                          )),
                      Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.asset(
                                      'images/ic_gpay.png',
                                      height: 28,
                                      width: 28,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add Google Pay Detail',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              showGPayDialog();
                            },
                          )),
                      Card(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.asset(
                                      'images/ic_phonepe.png',
                                      height: 28,
                                      width: 28,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Add PhonePe Detail',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              showPhonePeNumber();
                            },
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        alignment: Alignment.center,
                        child: Text(
                          'Note: User will be responsible for all data submitted.',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()));
    return true;
  }

  void fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      email = sharedPreferences.getString(Constants.SHARED_PREF_EMAIL);
      username = sharedPreferences.getString(Constants.SHARED_PREF_USER_NAME);
      mobNumber =
          sharedPreferences.getString(Constants.SHARED_PREF_MOBILE_NUMBER);
      authToken = sharedPreferences.getString(Constants.SHARED_PREF_AUTH_TOKEN);
      phonePeNumber =
          sharedPreferences.getString(Constants.SHARED_PREF_PHONE_PE_NUMBER);
      gpayNumber =
          sharedPreferences.getString(Constants.SHARED_PREF_GPAY_NUMBER);

      addressLine =
          sharedPreferences.getString(Constants.SHARED_PREF_ADDRESS_LINE);
      cityLine = sharedPreferences.getString(Constants.SHARED_PREF_CITY_LINE);
      pincodeLine =
          sharedPreferences.getString(Constants.SHARED_PREF_PINCODE_LINE);

      bankName = sharedPreferences.getString(Constants.SHARED_PREF_BANK_NAME);
      ifscCode = sharedPreferences.getString(Constants.SHARED_PREF_IFSC_CODE);
      account_number =
          sharedPreferences.getString(Constants.SHARED_PREF_ACCOUNT_NUMBER);
      holder_name =
          sharedPreferences.getString(Constants.SHARED_PREF_HOLDER_NAME);

      paytmNumber =
          sharedPreferences.getString(Constants.SHARED_PREF_PAYTM_NUMBER);
    });
  }

  void showAddressDialog() {
    TextEditingController addressController = new TextEditingController();
    TextEditingController cityController = new TextEditingController();
    TextEditingController pincodeController = new TextEditingController();

    if (addressLine != null && addressLine.isNotEmpty)
      addressController.text = addressLine;
    if (cityLine != null && cityLine.isNotEmpty) cityController.text = cityLine;
    if (pincodeLine != null && pincodeLine.isNotEmpty)
      pincodeController.text = pincodeLine;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return CustomAlertDialog(
            content: SingleChildScrollView(
              child: Container(
                height: 350,
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'images/ic_address.png',
                        height: 40,
                        width: 40,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: addressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Address",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "City",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Pincode",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          addressLine = addressController.text.trim();
                          cityLine = cityController.text.trim();
                          pincodeLine = pincodeController.text.trim();

                          if (addressLine.isNotEmpty &&
                              cityLine.isNotEmpty &&
                              pincodeLine.isNotEmpty) {
                            String address =
                                "$addressLine,$cityLine,$pincodeLine";

                            HTTPService()
                                .changeAddress(authToken, address)
                                .then((response) => {
                                      updateAddressDetails(
                                          response,
                                          address,
                                          addressController,
                                          cityController,
                                          pincodeController)
                                    });
                          } else {
                            if (addressLine.isEmpty)
                              showErrorDialog('Address cannot be empty');
                            else if (cityLine.isEmpty)
                              showErrorDialog('City cannot be empty');
                            else if (pincodeLine.isEmpty)
                              showErrorDialog('Pin code cannot be empty');
                          }

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Add Address',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showBankDetailsDialog() {
    TextEditingController bankNameController = new TextEditingController();
    TextEditingController ifscController = new TextEditingController();
    TextEditingController accountNumberController = new TextEditingController();
    TextEditingController holderNameController = new TextEditingController();

    if (bankName != null && bankName.isNotEmpty)
      bankNameController.text = bankName;
    if (ifscCode != null && ifscCode.isNotEmpty) ifscController.text = ifscCode;
    if (account_number != null && account_number.isNotEmpty)
      accountNumberController.text = account_number;
    if (holder_name != null && holder_name.isNotEmpty)
      holderNameController.text = holder_name;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return CustomAlertDialog(
            content: SingleChildScrollView(
              child: Container(
                height: 400,
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'images/ic_bank.png',
                        height: 40,
                        width: 40,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: bankNameController,
                      keyboardType: TextInputType.name,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Bank Name",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: ifscController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [LengthLimitingTextInputFormatter(11)],
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "IFSC Code",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: accountNumberController,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Account Number",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: holderNameController,
                      keyboardType: TextInputType.name,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Holder Name",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          bankName = bankNameController.text.trim();
                          account_number = accountNumberController.text.trim();
                          ifscCode = ifscController.text.trim();
                          holder_name = holderNameController.text.trim();

                          if (bankName.isNotEmpty &&
                              account_number.isNotEmpty &&
                              ifscCode.isNotEmpty &&
                              ifscCode.length == 11 &&
                              holder_name.isNotEmpty) {
                            HTTPService()
                                .changeBankDetails(authToken, bankName,
                                    account_number, ifscCode, holder_name)
                                .then((response) {
                              updateBankDetails(response);
                            });
                          } else {
                            if (bankName.isEmpty)
                              showErrorDialog('Bank name cannot be empty');
                            else if (account_number.isEmpty)
                              showErrorDialog('Account number cannot be empty');
                            else if (ifscCode.isEmpty || ifscCode.length != 11)
                              showErrorDialog(
                                  'IFSC code should be atleast 11 characters');
                            else if (holder_name.isEmpty)
                              showErrorDialog('Holder name cannot be empty');
                          }

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Add Bank Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showPaytmDialog() {
    TextEditingController paytmController = new TextEditingController();

    if (paytmNumber != null && paytmNumber.isNotEmpty)
      paytmController.text = paytmNumber;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return CustomAlertDialog(
            content: SingleChildScrollView(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'images/ic_paytm.png',
                        height: 40,
                        width: 40,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: paytmController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Paytm Number",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          paytmNumber = paytmController.text;

                          if (paytmNumber != null &&
                              paytmNumber.isNotEmpty &&
                              paytmNumber.length == 10) {
                            HTTPService()
                                .changePaytmNumber(authToken, paytmNumber)
                                .then((response) => {
                                      updatePayTmDetails(response, paytmNumber,
                                          paytmController)
                                    });
                          } else {
                            if (paytmNumber == null || paytmNumber.isEmpty)
                              showErrorDialog('Paytm number cannot be blank');
                            else if (paytmNumber.length != 10)
                              showErrorDialog(
                                  'Paytm number should be 10 characters');
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Add Paytm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showGPayDialog() {
    TextEditingController gpayController = new TextEditingController();

    if (gpayNumber != null && gpayNumber.isNotEmpty)
      gpayController.text = gpayNumber;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return CustomAlertDialog(
            content: SingleChildScrollView(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'images/ic_gpay.png',
                        height: 40,
                        width: 40,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: gpayController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Google Pay Number",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          gpayNumber = gpayController.text.trim();

                          print('Gpay number: $gpayNumber');

                          if (gpayNumber != null &&
                              gpayNumber.isNotEmpty &&
                              gpayNumber.length == 10) {
                            HTTPService()
                                .changeGpayNumber(authToken, gpayNumber)
                                .then((response) => {
                                      updateGpayDetails(
                                          response, gpayNumber, gpayController)
                                    });
                          } else {
                            if (gpayNumber == null || gpayNumber.isEmpty)
                              showErrorDialog('GPay number cannot be blank');
                            else if (gpayNumber.length != 10)
                              showErrorDialog(
                                  'GPay number should be 10 characters');
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Add Gpay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showPhonePeNumber() {
    TextEditingController phonePeController = new TextEditingController();

    if (phonePeNumber != null && phonePeNumber != "")
      phonePeController.text = phonePeNumber;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return CustomAlertDialog(
            content: SingleChildScrollView(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        'images/ic_phonepe.png',
                        height: 40,
                        width: 40,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: phonePeController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Phonepe Number",
                          fillColor: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          phonePeNumber = phonePeController.text.trim();

                          if (phonePeNumber != null &&
                              phonePeNumber.isNotEmpty &&
                              phonePeNumber.length == 10) {
                            HTTPService()
                                .changePhonePeNumber(authToken, phonePeNumber)
                                .then((response) => {
                                      updatePhonePeDetails(response,
                                          phonePeNumber, phonePeController)
                                    });
                          } else {
                            if (phonePeNumber == null || phonePeNumber.isEmpty)
                              showErrorDialog('PhonePe number cannot be blank');
                            else if (phonePeNumber.length != 10)
                              showErrorDialog(
                                  'PhonePe number should be 10 characters');
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Add PhonePe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  updateAddressDetails(
      Response response,
      String address,
      TextEditingController addressLineController,
      TextEditingController cityLineController,
      TextEditingController pincodeController) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        Constants.SHARED_PREF_ADDRESS_LINE, addressLine);
    sharedPreferences.setString(Constants.SHARED_PREF_CITY_LINE, cityLine);
    sharedPreferences.setString(
        Constants.SHARED_PREF_PINCODE_LINE, pincodeLine);

    if (response.statusCode == 200) {
      print('Address number changed');

      showSuccessDialog(context, 'Address Details Updated Successfully');
    } else
      showErrorDialog('Address details could not be updated');

    setState(() {
      addressLineController.text = addressLine;
      pincodeController.text = pincodeLine;
      cityLineController.text = cityLine;
    });
  }

  updatePhonePeDetails(Response response, String phonePeNumber,
      TextEditingController phonePeController) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        Constants.SHARED_PREF_PHONE_PE_NUMBER, phonePeNumber);

    if (response.statusCode == 200) {
      print('PhonePe number changed');

      showSuccessDialog(context, 'PhonePe Updated Successfully');
    } else
      showErrorDialog('PhonePe details could not be updated');

    setState(() {
      phonePeController.text = phonePeNumber;
    });
  }

  updateGpayDetails(Response response, String gpayNumber,
      TextEditingController gpayController) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SHARED_PREF_GPAY_NUMBER, gpayNumber);

    if (response.statusCode == 200) {
      showSuccessDialog(context, 'Gpay Updated Successfully');
    } else
      showErrorDialog('Gpay details could not be updated');

    setState(() {
      gpayController.text = gpayNumber;
    });
  }

  updatePayTmDetails(Response response, String payTmNumber,
      TextEditingController paytmController) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        Constants.SHARED_PREF_PAYTM_NUMBER, payTmNumber);

    if (response.statusCode == 200) {
      print('Paytm Number changed');

      showSuccessDialog(context, 'Paytm Updated Successfully');
    } else
      showErrorDialog('Paytm details could not be updated');

    setState(() {
      paytmController.text = payTmNumber;
    });
  }

  updateBankDetails(Response response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.SHARED_PREF_BANK_NAME, bankName);
    sharedPreferences.setString(Constants.SHARED_PREF_IFSC_CODE, ifscCode);
    sharedPreferences.setString(
        Constants.SHARED_PREF_ACCOUNT_NUMBER, account_number);
    sharedPreferences.setString(Constants.SHARED_PREF_HOLDER_NAME, holder_name);

    if (response.statusCode == 200) {
      print('Bank Details changed');
      showSuccessDialog(context, 'Bank Details Updated Successfully');
    } else
      showErrorDialog('Bank details could not be changed');
  }

  void showSuccessDialog(BuildContext buildContext, String message) {
    if (mounted) {
      showDialog(
          context: buildContext,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 80,
                height: 200,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Image.asset(
                          'images/ic_success.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  void showErrorDialog(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (buildContext) {
            return CustomAlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              content: Container(
                width: 60,
                height: 170,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: InkWell(
                          child: RaisedButton(
                            color: Colors.red,
                            splashColor: Colors.white,
                            child: Text(
                              'Close',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
