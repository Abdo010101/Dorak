class AvailableSchedulesResponse {
  List<Schedules>? schedules;

  AvailableSchedulesResponse({this.schedules});

  AvailableSchedulesResponse.fromJson(Map<String, dynamic> json) {
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules!.add(new Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schedules != null) {
      data['schedules'] = this.schedules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedules {
  String? interval;
  List<Week>? week;

  Schedules({this.interval, this.week});

  Schedules.fromJson(Map<String, dynamic> json) {
    interval = json['interval'];
    if (json['week'] != null) {
      week = <Week>[];
      json['week'].forEach((v) {
        week!.add(new Week.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interval'] = this.interval;
    if (this.week != null) {
      data['week'] = this.week!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Week {
  String? name;
  String? shortName;
  String? number;
  String? date;
  int? status;
  List<TimeSlots>? timeSlots;

  Week(
      {this.name,
      this.shortName,
      this.number,
      this.date,
      this.status,
      this.timeSlots});

  Week.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortName = json['short_name'];
    number = json['number'];
    date = json['date'];
    status = json['status'];
    if (json['time_slots'] != null) {
      timeSlots = <TimeSlots>[];
      json['time_slots'].forEach((v) {
        timeSlots!.add(new TimeSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['number'] = this.number;
    data['date'] = this.date;
    data['status'] = this.status;
    if (this.timeSlots != null) {
      data['time_slots'] = this.timeSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlots {
  String? time;
  bool? available;

  TimeSlots({this.time, this.available});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['available'] = this.available;
    return data;
  }
}
