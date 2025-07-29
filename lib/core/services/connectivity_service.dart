import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final InternetConnectionChecker connectionChecker;

  ConnectivityService({required this.connectionChecker});

  Future<bool> get isConnected => connectionChecker.hasConnection;

  Stream<bool> get connectionStream => 
      InternetConnectionChecker().onStatusChange
          .map((status) => status == InternetConnectionStatus.connected);
}