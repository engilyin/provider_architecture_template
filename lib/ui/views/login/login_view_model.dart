import 'package:logging/logging.dart';
import 'package:provider_start/core/exceptions/auth_exception.dart';
import 'package:provider_start/core/services/auth/auth_service.dart';
import 'package:provider_start/locator.dart';
import 'package:provider_start/ui/router.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final appRouter = locator<AppRouter>();
  final _log = Logger('HomeViewModel');

  Future<void> login(String email, String password) async {
    setBusy(true);
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      await appRouter.navigate(MainRoute());
    } on AuthException catch (e) {
      _log.shout(e.message);
      setBusy(false);
    }
  }
}
