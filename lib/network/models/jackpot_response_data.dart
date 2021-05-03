import 'package:kuber_starline/network/models/game_min_data.dart';

class JackpotResponseData {
  List<MinData> minData;
  int pkUserCreation;
  String gamename;
  String timeSlots;
  String slot2Time1;
  String slot2Time2;
  String result1;
  String result2;
  List<String> dayData;
  List<String> holidayData;

  JackpotResponseData(
      {this.minData,
      this.pkUserCreation,
      this.gamename,
      this.timeSlots,
      this.slot2Time1,
      this.slot2Time2,
      this.result1,
      this.result2,
      this.dayData,
      this.holidayData});

  JackpotResponseData.fromJson(Map<String, dynamic> json) {
    pkUserCreation = json['pk_UserCreation'];
    gamename = json['gamename'];
    timeSlots = json['timeSlots'];
    slot2Time1 = json['slot2Time1'];
    slot2Time2 = json['slot2Time2'];
    result1 = json['result1'];
    result2 = json['result2'];

    if (json['minData'] != null) {
      minData = new List<MinData>();
      json['minData'].forEach((v) {
        minData.add(new MinData.fromJson(v));
      });
    } else {
      minData = List();
    }

    if (json['dayData'] != null) {
      dayData = new List<String>();
      json['dayData'].forEach((v) {
        dayData.add(v);
      });
    } else {
      dayData = List();
    }

    if (json['holidayData'] != null) {
      holidayData = new List<String>();
      json['holidayData'].forEach((v) {
        holidayData.add(v);
      });
    } else {
      holidayData = List();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.minData != null) {
      data['minData'] = this.minData.map((v) => v.toJson()).toList();
    }
    data['pk_UserCreation'] = this.pkUserCreation;
    data['gamename'] = this.gamename;
    data['timeSlots'] = this.timeSlots;
    data['slot2Time1'] = this.slot2Time1;
    data['slot2Time2'] = this.slot2Time2;
    data['result1'] = this.result1;
    data['result2'] = this.result2;
    data['dayData'] = this.dayData;
    data['holidayData'] = this.holidayData;
    return data;
  }
}
