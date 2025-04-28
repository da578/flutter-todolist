import 'package:rive/rive.dart';

class RiveModel {
  final String source, artboard, stateMachineName;
  late SMIBool? status;

  RiveModel({
    required this.source,
    required this.artboard,
    required this.stateMachineName,
    this.status,
  });

  set setStatus(SMIBool state) {
    status = state;
  }
}
