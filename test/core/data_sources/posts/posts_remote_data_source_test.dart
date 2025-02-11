import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider_start/core/constant/api_routes.dart';
import 'package:provider_start/core/data_sources/posts/posts_remote_data_source.dart';
import 'package:provider_start/core/models/post/post.dart';
import 'package:provider_start/core/services/http/http_service.dart';
import 'package:provider_start/locator.dart';

import '../../../data/mocks.dart';

@GenerateNiceMocks([MockSpec<HttpService>()])
import 'posts_remote_data_source_test.mocks.dart';

void main() {
  late PostsRemoteDataSource postsRemoteDataSource;
  late HttpService httpService;

  setUp(() {
    locator.allowReassignment = true;

    locator.registerSingleton<HttpService>(MockHttpService());
    httpService = locator<HttpService>();

    locator
        .registerSingleton<PostsRemoteDataSource>(PostsRemoteDataSourceImpl());
    postsRemoteDataSource = locator<PostsRemoteDataSource>();
  });

  tearDown(() {
    // Reset the registered services after each test
    locator.reset();
  });

  test('should call httpService.getHttp when we fetch posts', () async {
    // arrange
    when(httpService.getHttp(ApiRoutes.posts))
        .thenAnswer((_) => Future.value(mockPostsJson));

    // act
    await postsRemoteDataSource.fetchPosts();

    // assert
    verify(httpService.getHttp(ApiRoutes.posts));
  });

  test('should convert json data to posts when we fetch posts', () async {
    // arrange
    when(httpService.getHttp(ApiRoutes.posts))
        .thenAnswer((_) => Future.value(mockPostsJson));
    final mockPosts =
        mockPostsJson.map<Post>((postMap) => Post.fromMap(postMap)).toList();

    // act
    final posts = await postsRemoteDataSource.fetchPosts();

    // assert
    expect(posts, equals(mockPosts));
  });
}
