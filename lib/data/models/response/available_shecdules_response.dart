class AvailableSchedulesResponse {
  List<Schedules>? schedules;

  AvailableSchedulesResponse({this.schedules});

  AvailableSchedulesResponse.fromJson(Map<String, dynamic> json) {
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules!.add(Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (schedules != null) {
      data['schedules'] = schedules!.map((v) => v.toJson()).toList();
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
        week!.add(Week.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['interval'] = interval;
    if (week != null) {
      data['week'] = week!.map((v) => v.toJson()).toList();
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
        timeSlots!.add(TimeSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['short_name'] = shortName;
    data['number'] = number;
    data['date'] = date;
    data['status'] = status;
    if (timeSlots != null) {
      data['time_slots'] = timeSlots!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['available'] = available;
    return data;
  }
}
