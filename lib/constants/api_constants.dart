class APIConstants {
  static const BASE_URL = "https://admin.ratanmatka.net.in/api/";

  static const ENDPOINT_REGISTER = BASE_URL + "Registation/Userdata";
  static const ENDPOINT_LOGIN = BASE_URL + "Login/Login";
  static const ENDPOINT_LOGIN_WITH_MPIN = BASE_URL + "Login/Loginbympin";
  static const ENDPOINT_FETCH_ALL_GAMES = BASE_URL + "Gameplay/Getgame";
  static const ENDPOINT_FETCH_STARLINE_GAMES = BASE_URL + "Game/Kuberstarline";
  static const ENDPOINT_CHANGE_PASSWORD =
      BASE_URL + "Credentials/Passwordchange";
  static const ENDPOINT_CHANGE_PASSWORD_NEW =
      BASE_URL + "Credentials/Passwordcreate";
  static const ENDPOINT_FORGOT_USER_ID = BASE_URL + "Credentials/Usercreate";
  static const ENDPOINT_GET_WALLET_DETAILS = BASE_URL + "Game/GetBalance";
  static const ENDPOINT_GET_SUBMIT_BID = BASE_URL + "Game/Gameplay";
  static const ENDPOINT_GET_RULES = BASE_URL + "Gamerule/Gameruleplay";
  static const ENDPOINT_HOW_TO_PLAY = BASE_URL + "Gamerule/Gameregulationplay";
  static const ENDPOINT_GENERATE_MPIN = BASE_URL + "Registation/UserMPIN";
  static const ENDPOINT_FETCH_GAME_RATES = BASE_URL + "Game/Gamebhou";
  static const ENDPOINT_FETCH_TRANSACTION_HISTORY =
      BASE_URL + "Game/Totaltranscation";
  static const ENDPOINT_FETCH_STARLINE_GAME_RATES =
      BASE_URL + "Game/GameratioStarline";
  static const ENDPOINT_FETCH_JACKPOT_GAME_RATES =
      BASE_URL + "Game/GameratioJackpot";
  static const ENDPOINT_FETCH_GAME_LIST = BASE_URL + "Game/AllGamelist";
  static const ENDPOINT_FETCH_PLAYING_HISTORY = BASE_URL + "Game/Playhistory";
  static const ENDPOINT_FETCH_WINNING_HISTORY = BASE_URL + "Game/Winnighistory";
  static const ENDPOINT_GET_WITHDRAW_REQUEST_HISTORY =
      BASE_URL + "Points/Fundwithdrawhistory";
  static const ENDPOINT_GET_ADD_FUNDS_REQUEST_HISTORY =
      BASE_URL + "Points/Fundhistory";
  static const ENDPOINT_GET_JACKPOT_GAMES = BASE_URL + "Game/Kuberjackpot";
  static const ENDPOINT_UPDATE_PROFILE_PICTURE =
      BASE_URL + "Credentials/Profilepicchange";
  static const ENDPOINT_PHONE_PE_NUMBER_CHANGE =
      BASE_URL + "Credentials/Phonepaychange";
  static const ENDPOINT_GPAY_NUMBER_CHANGE =
      BASE_URL + "Credentials/Googlepaychange";
  static const ENDPOINT_CHANGE_ADDRESS = BASE_URL + "Credentials/Addresschange";
  static const ENDPOINT_CHANGE_BANK_ADDRESS =
      BASE_URL + "Credentials/Bankchange";
  static const ENDPOINT_CHANGE_CHANGE_PAYTM =
      BASE_URL + "Credentials/Paytmchange";
  static const ENDPOINT_CHANGE_MOBILE_NUMBER =
      BASE_URL + "Credentials/Mobilechange";
  static const ENDPOINT_REQUEST_FUND = BASE_URL + "Points/UserFundwithdraw";
  static const ENDPOINT_ADD_FUND = BASE_URL + "Points/UserPointsRequest";
  static const ENDPOINT_GET_BANNER = BASE_URL + "Gamerule/Banner";
  static const ENDPOINT_RECOVER_PASSWORD = BASE_URL + "Login/Passwordchange";
  static const ENDPOINT_GET_ORDER_ID = BASE_URL + "Credentials/RazorpayId";
  static const ENDPOINT_GET_NOTIFICATIONS =
      BASE_URL + "Login/PushNotifications";
  static const ENDPOINT_GET_DETAILS = BASE_URL + "Credentials/StarJackDetails";
}
