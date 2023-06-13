class DeviceInfo {
  String registrationId;
  String devicePlatform;
  String deviceHardwareId;
  String? userId;
  String applicationId;

  DeviceInfo(
      {required this.registrationId,
        required this.devicePlatform,
        required this.deviceHardwareId,
        this.userId,
        required this.applicationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RegistrationId'] = this.registrationId;
    data['DevicePlatform'] = this.devicePlatform;
    data['DeviceHardwareId'] = this.deviceHardwareId;
    data['UserId'] = this.userId;
    data['ApplicationId'] = this.applicationId;
    return data;
  }
}

class RegisterDeviceInfo {
  bool? success;
  String? errorMessage;
  String? errorCode;

  RegisterDeviceInfo({this.success, this.errorMessage, this.errorCode});

  RegisterDeviceInfo.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    errorMessage = json['ErrorMessage'];
    errorCode = json['ErrorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['ErrorMessage'] = this.errorMessage;
    data['ErrorCode'] = this.errorCode;
    return data;
  }
}