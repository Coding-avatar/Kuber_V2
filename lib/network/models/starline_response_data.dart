import 'package:kuber_starline/network/models/game_min_data.dart';

class StarlineResponseData {
  List<MinData> minData;
  int pkUserCreation;
  String gamename;
  String timeSlots;
  String slot2Time1;
  String result1;
  List<String> dayData;
  List<String> holidayData;

  StarlineResponseData(
      {this.minData,
      this.pkUserCreation,
      this.gamename,
      this.timeSlots,
      this.slot2Time1,
      this.result1,
      this.dayData,
      this.holidayData});

  StarlineResponseData.fromJson(Map<String, dynamic> json) {
    if (json['minData'] != null) {
      minData = new List<MinData>();
      json['minData'].forEach((v) {
        minData.add(new MinData.fromJson(v));
      });
    }
    pkUserCreation = json['pk_UserCreation'];
    gamename = json['gamename'];
    timeSlots = json['timeSlots'];
    slot2Time1 = json['slot2Time1'];
    result1 = json['result1'];
    dayData = json['dayData'].cast<String>();
    holidayData = json['holidayData'] == null ? List() : json['holidayData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minData'] = this.minData;
    data['pk_UserCreation'] = this.pkUserCreation;
    data['gamename'] = this.gamename;
    data['timeSlots'] = this.timeSlots;
    data['slot2Time1'] = this.slot2Time1;
    data['result1'] = this.result1;
    data['dayData'] = this.dayData;
    data['holidayData'] = this.holidayData;
    return data;
  }
}
