class ServiceBooking {
  String? id;
  String? employeeId;
  String? bookingDatetime;
  String? bookingExpiryDateTime;
  String? serviceStartDate;
  String? serviceEndEndDate;
  int? isRoom;
  String? name;
  String? phone;
  int? peopleCount;
  int? roomNumber;
  String? bookingType;
  String? bookingStatus;
  String? invoiceNo;
  String? advancePayment;
  int? serviceValue;

  ServiceBooking(
      {this.id,
        this.bookingStatus,
        this.employeeId,
        this.bookingDatetime,
        this.bookingExpiryDateTime,
        this.serviceStartDate,
        this.serviceEndEndDate,
        this.isRoom,
        this.name,
        this.phone,
        this.peopleCount,
        this.roomNumber,
        this.bookingType,
        this.invoiceNo,
        this.serviceValue,
        this.advancePayment});

  ServiceBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    bookingDatetime = json['bookingDatetime'];
    bookingExpiryDateTime = json['bookingExpiryDateTime'];
    serviceStartDate = json['serviceStartDate'];
    serviceEndEndDate = json['serviceEndEndDate'];
    serviceValue = json['serviceValue'];
    isRoom = json['isRoom'];
    bookingStatus= json['bookingStatus'];
    name = json['name'];
    phone = json['phone'];
    peopleCount = json['peopleCount'];
    roomNumber = json['roomNumber'];
    bookingType = json['bookingType'];
    invoiceNo = json['invoiceNo'];
    advancePayment = json['advancePayment'];
  }
  List<ServiceBooking> fromJsonList(List<Map<String,dynamic>> serviceBookingsList){
    List<ServiceBooking> serviceBookings = [];
    for(Map<String,dynamic> booking in serviceBookingsList){
      serviceBookings.add(ServiceBooking.fromJson(booking));
    }
    return serviceBookings;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['bookingDatetime'] = bookingDatetime;
    data['bookingExpiryDateTime'] = bookingExpiryDateTime;
    data['serviceStartDate'] = serviceStartDate;
    data['serviceEndEndDate'] = serviceEndEndDate;
    data['isRoom'] = isRoom;
    data['serviceValue'] = serviceValue;
    data['bookingStatus']= bookingStatus;
    data['name'] = name;
    data['phone'] = phone;
    data['peopleCount'] = peopleCount;
    data['roomNumber'] = roomNumber;
    data['bookingType'] = bookingType;
    data['invoiceNo'] = invoiceNo;
    data['advancePayment'] = advancePayment;
    return data;
  }
}