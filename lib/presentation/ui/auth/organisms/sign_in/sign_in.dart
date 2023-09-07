import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/auth/organisms/sign_in/sign_in_state_notifier.dart';
import 'package:real_world_flutter/presentation/ui/auth/organisms/sign_in/sign_in_view_model.dart';
import 'package:real_world_flutter/presentation/ui/common/molecules/loading_overlay.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(SignInStateNotifier.provider);
    final notifier = ref.watch(SignInStateNotifier.provider.notifier);

    _ifNeedShowDialog(context, vm, notifier);

    return LoadingOverlay(
      isLoading: vm.isLoading,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _title(),
              _needAccount(notifier),
              _forms(vm, notifier),
              _signInButton(context, vm, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Container _signInButton(
    BuildContext context,
    SignInViewModel vm,
    SignInStateNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: vm.isEnableSignInButton
            ? () {
                FocusScope.of(context).unfocus();
                notifier.onTapSignIn();
              }
            : null,
        child: const Text('Sign in'),
      ),
    );
  }

  void _ifNeedShowDialog(
    BuildContext context,
    SignInViewModel vm,
    SignInStateNotifier notifier,
  ) {
    final error = vm.errorMessage;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(error),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    notifier.onTapErrorDialogOk();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  Widget _needAccount(SignInStateNotifier notifier) {
    return TextButton(
      onPressed: notifier.onTapNeedAccount,
      child: const Text('Need an account?'),
    );
  }

  Widget _title() {
    return const Text(
      'Sign in',
      style: TextStyle(fontSize: 32),
    );
  }

  Widget _forms(SignInViewModel vm, SignInStateNotifier notifier) {
    return FocusTraversalGroup(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              initialValue: vm.email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
              onChanged: notifier.onUpdateEmail,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: vm.password,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
              onChanged: notifier.onUpdatePassword,
            ),
          ],
        ),
      ),
    );
  }
}
