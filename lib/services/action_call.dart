import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'package:permission/permission.dart';

class Call {
  static phone(number) async {
    List<PermissionName> permissionNames = [PermissionName.Phone];
    final status = await Permission.getPermissionsStatus(permissionNames);
    print("permission Status : : $status");
    if (status[0].permissionStatus != PermissionStatus.allow) {
      print("not allowed ");
      var permissions = await Permission.requestPermissions(permissionNames);
    }
    android_intent.Intent()
      ..setAction(android_action.Action.ACTION_CALL)
      ..setData(Uri(scheme: 'tel', path: '$number'))
      ..startActivity().catchError((e) => print(e));
  }
}
