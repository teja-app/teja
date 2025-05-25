# Comprehensive Testing Plan for Teja Application

## Executive Summary

This document outlines a comprehensive testing strategy for the Teja application, focusing on testing the Couchbase Lite integration, data models, repository patterns, and service interactions. The plan emphasizes unit testing and integration testing without UI testing, ensuring high code coverage and reliability.

## Goals and Objectives

1. **Ensure Data Integrity**: Verify all CRUD operations work correctly with Couchbase Lite
2. **Validate Business Logic**: Test all repository methods and saga workflows
3. **Test Integration Points**: Verify API interactions and data synchronization
4. **Improve Code Quality**: Achieve >80% code coverage for critical components
5. **Enable Confident Refactoring**: Create a safety net for future changes

## Testing Architecture

### 1. Test Types

#### Unit Tests
- **Repository Tests**: Test each repository method in isolation
- **Model Tests**: Validate data model conversions and serialization
- **Helper Tests**: Test utility functions and converters
- **Service Tests**: Test individual service methods with mocked dependencies

#### Integration Tests
- **Database Integration**: Test actual Couchbase Lite operations
- **Saga Integration**: Test complete saga workflows with real repositories
- **API Integration**: Test API client interactions with mock servers
- **End-to-End Service Tests**: Test complete feature flows

### 2. Testing Tools and Dependencies

```yaml
dev_dependencies:
  # Core testing
  flutter_test:
    sdk: flutter
  test: ^1.24.0
  
  # Mocking
  mockito: ^5.4.4
  build_runner: ^2.4.6
  
  # CBL testing
  cbl_flutter_test: ^3.1.0
  
  # API mocking
  http_mock_adapter: ^0.6.1
  
  # Test utilities
  faker: ^2.1.0
  equatable: ^2.0.5
  
  # Coverage
  test_coverage: ^0.5.0
```

## Test Structure

### Directory Organization

```
test/
├── unit/
│   ├── infrastructure/
│   │   ├── repositories/
│   │   │   ├── journal_entry_repository_test.dart
│   │   │   ├── mood_log_repository_test.dart
│   │   │   ├── master_feeling_repository_test.dart
│   │   │   ├── master_factor_repository_test.dart
│   │   │   └── media_repositories_test.dart
│   │   ├── models/
│   │   │   ├── mood_log_model_test.dart
│   │   │   ├── journal_entry_model_test.dart
│   │   │   └── master_data_models_test.dart
│   │   ├── services/
│   │   │   ├── auth_service_test.dart
│   │   │   └── sync_service_test.dart
│   │   └── helpers/
│   │       ├── cbl_helpers_test.dart
│   │       └── conversion_helpers_test.dart
│   └── domain/
│       ├── sagas/
│       │   ├── mood_editor_saga_test.dart
│       │   ├── mood_sync_saga_test.dart
│       │   └── master_data_saga_test.dart
│       └── entities/
│           └── entity_validation_test.dart
├── integration/
│   ├── database/
│   │   ├── cbl_database_test.dart
│   │   └── query_performance_test.dart
│   ├── sync/
│   │   ├── mood_sync_flow_test.dart
│   │   └── conflict_resolution_test.dart
│   └── workflows/
│       ├── create_mood_flow_test.dart
│       └── journal_entry_flow_test.dart
├── fixtures/
│   ├── mood_log_fixtures.dart
│   ├── journal_entry_fixtures.dart
│   └── master_data_fixtures.dart
├── helpers/
│   ├── test_database_helper.dart
│   ├── mock_generator.dart
│   └── test_utilities.dart
└── test_config.dart
```

## Detailed Test Specifications

### 1. Repository Layer Tests

#### MoodLogRepository Tests

```dart
// test/unit/infrastructure/repositories/mood_log_repository_test.dart

group('MoodLogRepository', () {
  late Database mockDatabase;
  late Collection mockCollection;
  late MoodLogRepository repository;
  
  setUp(() {
    // Setup mocks and repository
  });
  
  group('CRUD Operations', () {
    test('should save a new mood log', () async {
      // Test implementation
    });
    
    test('should update an existing mood log', () async {
      // Test implementation
    });
    
    test('should retrieve mood log by id', () async {
      // Test implementation
    });
    
    test('should handle null id gracefully', () async {
      // Test implementation
    });
  });
  
  group('Query Operations', () {
    test('should get paginated mood logs', () async {
      // Test with various page sizes and filters
    });
    
    test('should filter by date range', () async {
      // Test date filtering logic
    });
    
    test('should calculate mood streak correctly', () async {
      // Test streak calculation with various scenarios
    });
  });
  
  group('Sync Operations', () {
    test('should track sync timestamps', () async {
      // Test sync timestamp management
    });
    
    test('should handle batch updates', () async {
      // Test batch operations
    });
  });
  
  group('Error Handling', () {
    test('should handle database errors', () async {
      // Test error scenarios
    });
  });
});
```

#### Key Testing Scenarios for Each Repository

1. **JournalEntryRepository**
   - Text entry creation with various lengths
   - Media attachment handling (images, videos, voice)
   - Question-answer pair management
   - Pagination with different page sizes
   - Date range filtering
   - Soft delete and recovery

2. **MasterFeelingRepository**
   - Bulk insertion of feelings
   - Slug-based lookups
   - Parent-child relationships
   - Energy and pleasantness calculations

3. **MasterFactorRepository**
   - Category and subcategory management
   - Filtering by multiple slugs
   - Entity conversion

4. **Media Repositories (Image/Video/Voice)**
   - File hash validation
   - Linking/unlinking to journal entries
   - Duplicate detection
   - Storage path management

### 2. Model Layer Tests

#### Data Model Validation

```dart
// test/unit/infrastructure/models/mood_log_model_test.dart

group('MoodLog Model', () {
  test('should serialize to JSON correctly', () {
    final moodLog = MoodLogFixtures.complete();
    final json = moodLog.toJson();
    
    expect(json['id'], equals(moodLog.id));
    expect(json['moodRating'], equals(moodLog.moodRating));
    expect(json['feelings'], isA<List>());
  });
  
  test('should deserialize from JSON correctly', () {
    final json = MoodLogFixtures.completeJson();
    final moodLog = MoodLog.fromJson(json);
    
    expect(moodLog.id, equals(json['id']));
    expect(moodLog.feelings?.length, equals(2));
  });
  
  test('should handle missing optional fields', () {
    final minimalJson = MoodLogFixtures.minimalJson();
    final moodLog = MoodLog.fromJson(minimalJson);
    
    expect(moodLog.comment, isNull);
    expect(moodLog.feelings, isNull);
    expect(moodLog.attachments, isNull);
  });
});
```

### 3. Saga Layer Tests

#### Saga Workflow Testing

```dart
// test/unit/domain/sagas/mood_editor_saga_test.dart

group('MoodEditorSaga', () {
  late MockMoodLogRepository mockRepository;
  late MockMasterFeelingRepository mockFeelingRepo;
  late TestSagaMiddleware sagaMiddleware;
  
  setUp(() {
    // Setup mocks and saga
  });
  
  test('should create mood log successfully', () async {
    // Arrange
    final moodData = MoodLogFixtures.newMoodData();
    when(mockRepository.addOrUpdateMoodLog(any))
        .thenAnswer((_) async => MoodLogFixtures.created());
    
    // Act
    sagaMiddleware.dispatch(CreateMoodLogAction(moodData));
    await sagaMiddleware.waitForActions([
      CreateMoodLogSuccessAction,
      TriggerMoodSyncAction,
    ]);
    
    // Assert
    verify(mockRepository.addOrUpdateMoodLog(any)).called(1);
    expect(sagaMiddleware.getState().moodEditor.isSaving, isFalse);
  });
  
  test('should handle creation failure', () async {
    // Test error scenarios
  });
});
```

### 4. Integration Tests

#### Database Integration

```dart
// test/integration/database/cbl_database_test.dart

group('CBL Database Integration', () {
  late Database database;
  late MoodLogRepository repository;
  
  setUpAll(() async {
    database = await TestDatabaseHelper.createTestDatabase();
    repository = MoodLogRepository(database);
  });
  
  tearDownAll(() async {
    await database.close();
    await TestDatabaseHelper.cleanup();
  });
  
  test('should perform CRUD operations', () async {
    // Create
    final moodLog = MoodLogFixtures.complete();
    await repository.addOrUpdateMoodLog(moodLog);
    
    // Read
    final retrieved = await repository.getMoodLogById(moodLog.id);
    expect(retrieved, isNotNull);
    expect(retrieved!.id, equals(moodLog.id));
    
    // Update
    final updated = moodLog.copyWith(comment: 'Updated comment');
    await repository.addOrUpdateMoodLog(updated);
    
    final retrievedAgain = await repository.getMoodLogById(moodLog.id);
    expect(retrievedAgain!.comment, equals('Updated comment'));
    
    // Delete
    await repository.deleteMoodLogById(moodLog.id);
    final deleted = await repository.getMoodLogById(moodLog.id);
    expect(deleted, isNull);
  });
  
  test('should handle concurrent operations', () async {
    // Test concurrent reads/writes
  });
});
```

#### Sync Flow Integration

```dart
// test/integration/sync/mood_sync_flow_test.dart

group('Mood Sync Flow', () {
  late Database database;
  late MoodLogRepository repository;
  late MockMoodLogApiService mockApi;
  late MoodSyncSaga syncSaga;
  
  test('should sync new mood logs to server', () async {
    // Create local mood logs
    final moodLogs = MoodLogFixtures.multipleUnsyncedLogs();
    for (final log in moodLogs) {
      await repository.addOrUpdateMoodLog(log);
    }
    
    // Mock API responses
    when(mockApi.syncEntries(any)).thenAnswer((_) async => SyncResult.success());
    
    // Trigger sync
    await syncSaga.performSync();
    
    // Verify
    verify(mockApi.syncEntries(any)).called(1);
    final syncedLogs = await repository.getUnsyncedMoodLogs();
    expect(syncedLogs, isEmpty);
  });
  
  test('should handle sync conflicts', () async {
    // Test conflict resolution
  });
  
  test('should retry failed syncs', () async {
    // Test retry logic
  });
});
```

## Test Data Management

### 1. Fixtures

```dart
// test/fixtures/mood_log_fixtures.dart

class MoodLogFixtures {
  static MoodLog complete() => MoodLog(
    id: 'test-mood-${DateTime.now().millisecondsSinceEpoch}',
    timestamp: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    moodRating: 4,
    comment: 'Feeling good today',
    feelings: [
      MoodLogFeeling(
        feelingSlug: 'happy',
        factors: ['sunshine', 'exercise'],
      ),
    ],
    factors: ['weather', 'health'],
    isDeleted: false,
  );
  
  static MoodLog minimal() => MoodLog(
    id: 'test-mood-minimal',
    timestamp: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    moodRating: 3,
    isDeleted: false,
  );
  
  static List<MoodLog> weekOfMoodLogs() {
    // Generate a week's worth of mood logs
  }
}
```

### 2. Mock Generators

```dart
// test/helpers/mock_generator.dart

@GenerateMocks([
  Database,
  Collection,
  MoodLogRepository,
  MasterFeelingRepository,
  MoodLogApiService,
])
void main() {}
```

### 3. Test Utilities

```dart
// test/helpers/test_database_helper.dart

class TestDatabaseHelper {
  static Future<Database> createTestDatabase() async {
    final dir = await getTemporaryDirectory();
    final dbPath = '${dir.path}/test_${DateTime.now().millisecondsSinceEpoch}';
    
    return await Database.openAsync(
      'test_db',
      DatabaseConfiguration(directory: dbPath),
    );
  }
  
  static Future<void> cleanup() async {
    // Clean up test databases
  }
  
  static Future<void> seedMasterData(Database db) async {
    // Seed feelings and factors
  }
}
```

## Testing Best Practices

### 1. Test Organization

- **AAA Pattern**: Arrange, Act, Assert
- **Given-When-Then**: For integration tests
- **Descriptive Names**: Test names should describe the scenario
- **Single Responsibility**: Each test should verify one behavior

### 2. Mock Usage

- **Mock External Dependencies**: Database, API, Services
- **Use Real Objects When Possible**: Models, Entities, Helpers
- **Verify Interactions**: Use `verify()` to ensure methods are called
- **Stub Behavior**: Use `when()` to define mock behavior

### 3. Async Testing

```dart
test('should handle async operations', () async {
  // Use async/await
  final result = await repository.getMoodLogById('123');
  
  // Use expectAsync for callbacks
  stream.listen(expectAsync1((data) {
    expect(data, isNotNull);
  }));
  
  // Use completer for complex async scenarios
  final completer = Completer<void>();
  // ... setup
  await completer.future;
});
```

### 4. Error Testing

```dart
test('should handle errors gracefully', () {
  // Test exceptions
  expect(
    () => repository.getMoodLogById(null),
    throwsA(isA<ArgumentError>()),
  );
  
  // Test error states
  when(mockApi.syncEntries(any))
      .thenThrow(NetworkException('No connection'));
  
  // Verify error handling
  expect(result.isError, isTrue);
  expect(result.error, contains('No connection'));
});
```

## Performance Testing

### Query Performance Tests

```dart
// test/integration/database/query_performance_test.dart

test('should query large datasets efficiently', () async {
  // Insert 10,000 mood logs
  await TestDataGenerator.generateMoodLogs(10000);
  
  final stopwatch = Stopwatch()..start();
  final results = await repository.getMoodLogsPage(0, 20);
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
  expect(results.data.length, equals(20));
});
```

## Test Execution Strategy

### 1. Test Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/infrastructure/repositories/mood_log_repository_test.dart

# Run integration tests
flutter test test/integration/

# Run with verbose output
flutter test -v
```

### 2. CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
```

### 3. Test Coverage Goals

- **Repositories**: 90%+ coverage
- **Models**: 95%+ coverage
- **Sagas**: 80%+ coverage
- **Services**: 85%+ coverage
- **Overall**: 85%+ coverage

## Implementation Timeline

### Phase 1: Foundation (Week 1) ✅
- [x] Set up test infrastructure
- [x] Create test helpers and utilities
- [x] Implement fixture generators
- [x] Create mock generators

### Phase 2: Unit Tests (Week 2-3) ⏳
- [ ] Repository unit tests
  - [x] MoodLogRepository tests
  - [ ] JournalEntryRepository tests
  - [x] MasterFeelingRepository tests
  - [ ] MasterFactorRepository tests
  - [ ] Media repositories tests (Image/Video/Voice)
- [ ] Model serialization tests
  - [x] MoodLog model tests
  - [ ] JournalEntry model tests
  - [x] Master feeling model tests
  - [ ] Master factor model tests
- [ ] Helper function tests
  - [ ] CBL helper tests
  - [ ] Conversion helper tests
- [ ] Service unit tests
  - [ ] Auth service tests
  - [ ] Sync service tests

### Phase 3: Integration Tests (Week 4) 📋
- [ ] Database integration tests
  - [ ] CBL database CRUD operations
  - [ ] Query performance tests
  - [ ] Concurrent operations tests
- [ ] Saga workflow tests
  - [ ] Mood editor saga tests
  - [ ] Mood sync saga tests
  - [ ] Master data saga tests
- [ ] Sync flow tests
  - [ ] Mood sync flow tests
  - [ ] Conflict resolution tests
  - [ ] Retry logic tests
- [ ] Performance tests
  - [ ] Large dataset query tests
  - [ ] Memory usage tests

### Phase 4: Refinement (Week 5) 📅
- [ ] Increase coverage
  - [ ] Achieve 85%+ overall coverage
  - [ ] Add missing test cases
- [ ] Add edge case tests
  - [ ] Error handling scenarios
  - [ ] Boundary conditions
- [ ] Documentation
  - [ ] Test documentation updates
  - [ ] Code examples
- [ ] CI/CD setup
  - [ ] GitHub Actions configuration
  - [ ] Coverage reporting

## Success Metrics

1. **Code Coverage**: Achieve 85%+ overall coverage
2. **Test Execution Time**: All unit tests run in <30 seconds
3. **Test Reliability**: Zero flaky tests
4. **Bug Detection**: Catch 90%+ of bugs before production
5. **Developer Confidence**: Team confident in making changes

## Maintenance Strategy

1. **Test Review**: Review tests during code reviews
2. **Coverage Monitoring**: Track coverage trends
3. **Performance Monitoring**: Regular performance test runs
4. **Test Refactoring**: Keep tests clean and maintainable
5. **Documentation**: Keep test documentation updated

## Conclusion

This comprehensive testing plan provides a solid foundation for ensuring the reliability and maintainability of the Teja application. By focusing on testing the data layer, business logic, and integration points, we can achieve high confidence in the application's behavior without the complexity of UI testing.