import 'package:provider_start/core/models/post/post.dart';
import 'package:stacked/stacked.dart';

class PostTileViewModel extends BaseViewModel {

  late Post _post;
  Post get post => _post;

  void init(Post post) {
    _post = post;
  }

  void showPostDetails() {
    // _navigationService.pushNamed(PostDetailsRoute.name,
    //     arguments: PostDetailsViewArguments(post: _post));
  }
}
