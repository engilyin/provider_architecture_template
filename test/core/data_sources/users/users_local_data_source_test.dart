import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';
import 'package:provider_start/core/constant/local_storage_keys.dart';
import 'package:provider_start/core/data_sources/users/users_local_data_source.dart';
import 'package:provider_start/core/exceptions/cache_exception.dart';
import 'package:provider_start/core/models/user/user_h.dart';
import 'package:provider_start/core/utils/file_helper.dart';
import 'package:provider_start/locator.dart';

import '../../../data/mocks.dart';

@GenerateNiceMocks([MockSpec<HiveInterface>(), MockSpec<FileHelper>(), MockSpec<Box<UserH>>(as: #MockBox)])
import 'users_local_data_source_test.mocks.dart';


void main() {
  late UsersLocalDataSource usersLocalDataSource;
  late FileHelper fileHelper;
  late HiveInterface hive;
  late MockBox usersBox;

  final fakePath = 'users/';

  setUp(() {
    locator.allowReassignment = true;

    locator.registerSingleton<FileHelper>(MockFileHelper());
    fileHelper = locator<FileHelper>();

    locator.registerSingleton<HiveInterface>(MockHiveInterface());
    hive = locator<HiveInterface>();

    locator.registerSingleton<UsersLocalDataSource>(UsersLocalDataSourceImpl());
    usersLocalDataSource = locator<UsersLocalDataSource>();

    usersBox = MockBox();
  });

  tearDown(() {
    // Reset the registered services after each test
    locator.reset();
  });

  void setupHiveDirectoryWithClosedBox() {
    when(hive.isBoxOpen(LocalStorageKeys.users)).thenReturn(false);
    when(fileHelper.getApplicationDocumentsDirectoryPath())
        .thenAnswer((_) => Future.value(fakePath));
  }

  void setupHiveDirectoryWithOpenBox() {
    when(hive.isBoxOpen(LocalStorageKeys.users)).thenReturn(true);
    when(fileHelper.getApplicationDocumentsDirectoryPath())
        .thenAnswer((_) => Future.value(fakePath));
  }

  void setupOpenedBox() {
    when(hive.openBox<UserH>(LocalStorageKeys.users))
        .thenAnswer((_) => Future.value(usersBox));
    when(hive.box<UserH>(LocalStorageKeys.users)).thenReturn(usersBox);
  }

  test(
      'local data source should use the applications directory path when initializing',
      () async {
    // arrange
    setupHiveDirectoryWithClosedBox();

    // act
    await usersLocalDataSource.init();

    // assert
    verify(fileHelper.getApplicationDocumentsDirectoryPath()).called(1);
  });

  test('local data source should initialize hive when initializing', () async {
    // arrange
    setupHiveDirectoryWithClosedBox();

    // act
    await usersLocalDataSource.init();

    // assert
    verify(hive.init(fakePath)).called(1);
  });

  test('local data source should register a user adapter', () async {
    // arrange
    setupHiveDirectoryWithOpenBox();
    setupOpenedBox();

    // act
    await usersLocalDataSource.init();

    // assert
    verify(hive.registerAdapter<UserH>(UserHAdapter())).called(1);
  });

  test('local data source should open box when box is not open', () async {
    // arrange
    setupHiveDirectoryWithClosedBox();

    // act
    await usersLocalDataSource.init();

    // assert
    verify(hive.openBox(LocalStorageKeys.users)).called(1);
  });

  test('local data source should not open box when box is open', () async {
    // arrange
    setupHiveDirectoryWithOpenBox();

    // act
    await usersLocalDataSource.init();

    // assert
    verifyNever(hive.openBox(LocalStorageKeys.users));
  });

  test(
      'local data fetchUser(uid) should throw CacheException when no user is found',
      () async {
    // arrange
    setupHiveDirectoryWithOpenBox();
    setupOpenedBox();

    when(usersBox.isEmpty).thenReturn(true);

    try {
      // act
      await usersLocalDataSource.fetchUser(1);
    } catch (e) {
      // assert
      expect(e, equals(isA<CacheException>()));
    }
  });

  test('local data source should call putAll() when cachePosts() is called',
      () async {
    // arrange
    setupHiveDirectoryWithOpenBox();
    setupOpenedBox();

    // act
    await usersLocalDataSource.cacheUser(mockUser);

    // assert
    verify(usersBox.put(mockUser.id, UserH.fromUser(mockUser))).called(1);
  });
}
