
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
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}