import 'dart:async';
import 'dart:io';

class GlobalConnectivityService {
  static final GlobalConnectivityService _instance =
      GlobalConnectivityService._internal();
  factory GlobalConnectivityService() => _instance;
  GlobalConnectivityService._internal();

  final StreamController<bool> _controller = StreamController.broadcast();
  Stream<bool> get connectivityStream => _controller.stream;

  Timer? _timer;

  /// Start periodic internet checks
  void startMonitoring({Duration interval = const Duration(seconds: 3)}) {
    // immediately check once
    _checkConnection();

    // periodic check
    _timer = Timer.periodic(interval, (_) => _checkConnection());
  }

  /// Dispose stream and timer
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  /// Check real internet connection
  Future<void> _checkConnection() async {
    bool isOnline = await _hasInternet();
    _controller.add(isOnline);
  }

  /// Utility method to check actual internet access
  Future<bool> _hasInternet({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(timeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  /// Optional: check immediately from anywhere
  Future<bool> checkConnection() async => await _hasInternet();
}
