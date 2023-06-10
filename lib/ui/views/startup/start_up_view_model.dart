import 'package:provider_start/core/data_sources/posts/posts_local_data_source.dart';
import 'package:provider_start/core/data_sources/users/users_local_data_source.dart';
import 'package:provider_start/core/services/auth/auth_service.dart';
import 'package:provider_start/core/services/hardware_info/hardware_info_service.dart';
import 'package:provider_start/locator.dart';
import 'package:provider_start/ui/router.dart';
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _appRouter = locator<AppRouter>();
  final postsLocalDataSource = locator<PostsLocalDataSource>();
  final usersLocalDataSource = locator<UsersLocalDataSource>();
  final hardwareInfoService = locator<HardwareInfoService>();

  Future handleStartUpLogic() async {
    final hasLoggedInUser = await _authService.isUserLoggedIn();

    await Future.wait([
      postsLocalDataSource.init(),
      usersLocalDataSource.init(),
      hardwareInfoService.init(),
    ]);

    if (hasLoggedInUser) {
      await _appRouter.navigate(MainRoute());
    } else {
      await _appRouter.navigate(LoginRoute());
    }
  }
}
