import 'package:hive_business/statemanagement/statusInfo/statusInfoModel.dart';

class StatusInfoController {
  var statusInfo = StatusInfoModel();
  void setStatus({required bool status}) {
    statusInfo.isOnline.value = status;
  }
}
