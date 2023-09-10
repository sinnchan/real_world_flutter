import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/common/color/ext_color.dart';
import 'package:real_world_flutter/presentation/ui/common/molecules/loading_overlay.dart';
import 'package:real_world_flutter/presentation/ui/settings/organisms/settings_state_notifier.dart';
import 'package:real_world_flutter/presentation/ui/settings/organisms/settings_view_model.dart';

class Settings extends HookConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(SettingsStateNotifier.provider);
    final notifier = ref.watch(SettingsStateNotifier.provider.notifier);

    final imageUrlTextController = useTextEditingController();
    final usernameTextController = useTextEditingController();
    final bioTextController = useTextEditingController();
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();

    // handle changed state.
    useValueChanged<String?, void>(vm.imageUrl, (_, __) {
      imageUrlTextController.text = vm.imageUrl ?? '';
    });
    useValueChanged<String?, void>(vm.username, (_, __) {
      usernameTextController.text = vm.username ?? '';
    });
    useValueChanged<String?, void>(vm.bio, (_, __) {
      bioTextController.text = vm.bio ?? '';
    });
    useValueChanged<String?, void>(vm.email, (_, __) {
      emailTextController.text = vm.email ?? '';
    });
    useValueChanged<String?, void>(vm.password, (_, __) {
      passwordTextController.text = vm.password ?? '';
    });
    _ifNeedShowDialog(context, vm, notifier);

    return LoadingOverlay(
      isLoading: vm.isLoading,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Text(
                'Your Settings',
                style: TextStyle(fontSize: 32),
              ),
              _space(),
              TextFormField(
                controller: imageUrlTextController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  hintText: 'URL of profile picture',
                ),
              ),
              _space(),
              TextFormField(
                controller: usernameTextController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              _space(),
              SizedBox(
                height: 150,
                child: TextFormField(
                  controller: bioTextController,
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Short bio about you',
                  ),
                ),
              ),
              _space(),
              TextFormField(
                controller: emailTextController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              _space(),
              TextFormField(
                controller: passwordTextController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'New Password',
                ),
              ),
              _space(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    notifier.onTapUpdateButton(
                      imageUrl: imageUrlTextController.text,
                      username: usernameTextController.text,
                      bio: bioTextController.text,
                      email: emailTextController.text,
                      password: passwordTextController.text,
                    );
                  },
                  child: const Text('Update Settings'),
                ),
              ),
              _space(),
              const Divider(),
              _space(40),
              _logoutButton(notifier),
            ],
          ),
        ),
      ),
    );
  }

  void _ifNeedShowDialog(
    BuildContext context,
    SettingsViewModel vm,
    SettingsStateNotifier notifier,
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

  Widget _logoutButton(
    SettingsStateNotifier notifier,
  ) {
    final style = ButtonStyle(
      foregroundColor: const MaterialStatePropertyAll(AppColors.white),
      backgroundColor: const MaterialStatePropertyAll(AppColors.important),
      overlayColor: MaterialStatePropertyAll(AppColors.important.withDark()),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      )),
      side: const MaterialStatePropertyAll(
        BorderSide(color: AppColors.important),
      ),
    );

    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        style: style,
        onPressed: notifier.onTapSignoutButton,
        child: const Text('Or click here to logout.'),
      ),
    );
  }

  Widget _space([double? size]) {
    return SizedBox(height: size ?? 16);
  }
}
