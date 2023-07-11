import 'package:aws_chime/aws_chime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final observerProvider = ChangeNotifierProvider((ref) {
  return ObserverController();
});

final awsChimeProvider = ChangeNotifierProvider((ref) {
  return AwsChimeController();
});

final permissionProvider = Provider((ref) => PermissionController());
