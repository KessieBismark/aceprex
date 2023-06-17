class NotifyModel {
  final int id;
  final String from;
  final String to;
  final String title;
  final String hood;
  final String message;
  String status;
  final DateTime date;

  NotifyModel(
      {required this.id,
      required this.from,
      required this.to,
      required this.title,
      required this.hood,
      required this.message,
      required this.status,
      required this.date});

  factory NotifyModel.fromJson(Map<String, dynamic> map) {
    return NotifyModel(
        id: map['id'],
        from: map['fromUser'],
        to: map['toUser'],
        hood: map['hood'],
        title: map['title'],
        message: map['message'],
        status: map['status'],
        date: DateTime.parse(map['created_at']));
  }

  void updateStatusAtIndex(int index, String newStatus) {
    if (index >= 0 && index < status.length) {
      status = newStatus;
    }
  }
}
