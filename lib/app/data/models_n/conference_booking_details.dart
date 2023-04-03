
class ConferenceBookingDetails {
  String? id;
  String? bookingId;
  String? date;
  String? startTime;
  String? endTime;

  ConferenceBookingDetails(
      {this.id, this.bookingId, this.date, this.startTime, this.endTime});

  ConferenceBookingDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['bookingId'] = bookingId;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}