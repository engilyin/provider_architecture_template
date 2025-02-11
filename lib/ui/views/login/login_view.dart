import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider_start/core/localization/localization.dart';
import 'package:provider_start/core/mixins/validators.dart';
import 'package:provider_start/ui/shared/ui_helper.dart';
import 'package:provider_start/ui/views/login/login_view_model.dart';
import 'package:provider_start/ui/widgets/cupertino/cupertino_text_form_field.dart';
import 'package:provider_start/ui/widgets/stateless/loading_animation.dart';
import 'package:stacked/stacked.dart';

@RoutePage()
class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () {
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: PlatformScaffold(
          appBar: PlatformAppBar(
            title: Text(local.loginViewTitle),
            cupertino: (_, __) =>
                CupertinoNavigationBarData(previousPageTitle: ''),
          ),
          body: Form(
            key: formKey,
            child: IgnorePointer(
              ignoring: model.isBusy,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      _EmailTextField(
                        controller: emailController,
                        onFieldSubmitted: (_) =>
                            passwordFocusNode.requestFocus(),
                        validator: (_) => local.translate(
                          Validators.validateEmail(emailController.text),
                        ),
                      ),
                      UIHelper.verticalSpaceMedium(),
                      _PasswordTextField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        onFieldSubmitted: (_) {
                          if (!formKey.currentState!.validate()) return;

                          model.login(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        validator: (_) => local!.translate(
                          Validators.validatePassword(passwordController.text),
                        ),
                      ),
                      UIHelper.verticalSpaceMedium(),
                      _SignInButton(
                        busy: model.isBusy,
                        onPressed: () {
                          //if (formKey.currentState!.validate()) {
                            model.login(
                              emailController.text,
                              passwordController.text,
                            );
                          //}
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final bool busy;
  final void Function() onPressed;

  const _SignInButton({
    Key? key,
    required this.busy,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return busy
        ? LoadingAnimation()
        : ElevatedButton(
            child: Text(local!.loginButton),
            onPressed: onPressed,
          );
  }
}

class _EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onFieldSubmitted;
  final String? Function(String?) validator;

  const _EmailTextField({
    Key? key,
    required this.controller,
    required this.onFieldSubmitted,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return PlatformWidget(
      material: (_, __) => TextFormField(
        controller: controller,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: local!.emailHint,
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFormField(
        controller: controller,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        placeholder: local!.emailHint,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        prefix: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(CupertinoIcons.mail),
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onFieldSubmitted;
  final String? Function(String?) validator;

  const _PasswordTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onFieldSubmitted,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return PlatformWidget(
      material: (_, __) => TextFormField(
        controller: controller,
        validator: validator,
        focusNode: focusNode,
        obscureText: true,
        textInputAction: TextInputAction.send,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          hintText: local!.passwordHint,
          prefixIcon: Icon(Icons.lock),
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFormField(
        validator: validator,
        controller: controller,
        focusNode: focusNode,
        placeholder: local!.passwordHint,
        obscureText: true,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: TextInputAction.send,
        prefix: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(CupertinoIcons.padlock),
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
