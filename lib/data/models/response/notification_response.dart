/// Mirrors `NotificationResource` from `GET /patient/notifications`.
///
/// Backend groups notifications server-side via `group` (one of
/// `today | this_week | earlier`) and marks read state via `is_read` + the
/// Carbon timestamp `read_at`. `target` is the deep-link payload for taps
/// (e.g. `{"kind":"reservation","id":"..."}`). `date_label` is the
/// pre-formatted "today 2:30 pm" / "3 d ago" string per `Content-Language`.
class NotificationModel {
  String? id;
  String? type;
  String? title;
  String? description;
  String? date;
  String? dateLabel;
  String? readAt;
  bool? isRead;
  String? group;
  Map<String, dynamic>? target;

  NotificationModel({
    this.id,
    this.type,
    this.title,
    this.description,
    this.date,
    this.dateLabel,
    this.readAt,
    this.isRead,
    this.group,
    this.target,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    type = json['type'] as String?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    date = json['date'] as String?;
    dateLabel = json['date_label'] as String?;
    readAt = json['read_at'] as String?;
    isRead = json['is_read'] as bool?;
    group = json['group'] as String?;
    final rawTarget = json['target'];
    if (rawTarget is Map<String, dynamic>) {
      target = Map<String, dynamic>.from(rawTarget);
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'title': title,
        'description': description,
        'date': date,
        if (dateLabel != null) 'date_label': dateLabel,
        if (readAt != null) 'read_at': readAt,
        if (isRead != null) 'is_read': isRead,
        if (group != null) 'group': group,
        if (target != null) 'target': target,
      };
}
