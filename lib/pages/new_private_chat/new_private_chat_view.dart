import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/new_private_chat/new_private_chat.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewPrivateChatView extends StatelessWidget {
  final NewPrivateChatController controller;

  const NewPrivateChatView(this.controller, {Key? key}) : super(key: key);

  static const double _qrCodePadding = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(L10n.of(context)!.newChat),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed: () => VRouter.of(context).to('/newgroup'),
            child: Text(
              L10n.of(context)!.createNewGroup,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: controller.formKey,
                child: TextFormField(
                  controller: controller.controller,
                  autocorrect: false,
                  autofocus: !PlatformInfos.isMobile,
                  textInputAction: TextInputAction.go,
                  focusNode: controller.textFieldFocus,
                  onFieldSubmitted: controller.submitAction,
                  validator: controller.validateForm,
                  inputFormatters: controller.removeMatrixToFormatters,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    labelText: L10n.of(context)!.typeInInviteLinkManually,
                    hintText: '@username',
                    prefixText: NewPrivateChatController.prefixNoProtocol,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: controller.submitAction,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(_qrCodePadding),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(_qrCodePadding * 2),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 10,
                color: Colors.white,
                shadowColor: Theme.of(context).appBarTheme.shadowColor,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImage(
                      data:
                          'https://matrix.to/#/${Matrix.of(context).client.userID}',
                      version: QrVersions.auto,
                      size: min(MediaQuery.of(context).size.width - 16, 200),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.adaptive.share_outlined),
                      label: Text(L10n.of(context)!.shareYourInviteLink),
                      onPressed: controller.inviteAction,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PlatformInfos.isMobile && !controller.hideFab
          ? FloatingActionButton.extended(
              onPressed: controller.openScannerAction,
              label: Text(L10n.of(context)!.scanQrCode),
              icon: const Icon(Icons.camera_alt_outlined),
            )
          : null,
    );
  }
}
