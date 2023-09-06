import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
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

    useEffect(
      () {
        imageUrlTextController.text = vm.imageUrl ?? '';
        return null;
      },
      [vm.imageUrl],
    );
    useEffect(
      () {
        usernameTextController.text = vm.username ?? '';
        return null;
      },
      [vm.username],
    );
    useEffect(
      () {
        bioTextController.text = vm.bio ?? '';
        return null;
      },
      [vm.bio],
    );
    useEffect(
      () {
        emailTextController.text = vm.email ?? '';
        return null;
      },
      [vm.email],
    );
    useEffect(
      () {
        passwordTextController.text = vm.password ?? '';
        return null;
      },
      [vm.password],
    );

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
                onChanged: notifier.updatePictureUrl,
              ),
              _space(),
              TextFormField(
                controller: usernameTextController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
                onChanged: notifier.updateUsername,
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
                  onChanged: notifier.updateBio,
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
                onChanged: notifier.updateEmail,
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
                onChanged: notifier.updatePassword,
              ),
              _space(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: notifier.onTapUpdateButton,
                  child: const Text('Update Settings'),
                ),
              ),
              _space(),
              const Divider(),
              _space(),
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
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.white;
        } else {
          return AppColors.important;
        }
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.important;
        } else {
          return AppColors.white;
        }
      }),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      )),
      side: const MaterialStatePropertyAll(
        BorderSide(color: AppColors.important),
      ),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        style: style,
        onPressed: notifier.onTapSignoutButton,
        child: const Text('Or click here to logout.'),
      ),
    );
  }

  Widget _space() {
    return const SizedBox(height: 16);
  }
}
