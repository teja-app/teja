import 'package:flutter_test/flutter_test.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

/// Global test configuration
class TestConfig {
  /// Initialize test environment
  static Future<void> setUp() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Couchbase Lite for tests
    await CouchbaseLiteFlutter.init();
  }
  
  /// Clean up test environment
  static Future<void> tearDown() async {
    // Cleanup logic if needed
  }
  
  /// Run a test with proper setup and teardown
  static void runTest(
    String description,
    Future<void> Function() body, {
    bool skip = false,
  }) {
    test(
      description,
      () async {
        await setUp();
        try {
          await body();
        } finally {
          await tearDown();
        }
      },
      skip: skip,
    );
  }
}