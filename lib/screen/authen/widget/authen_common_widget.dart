import 'dart:io';

import 'package:dayoneasia/screen/authen/widget/register_terms_and_conditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

abstract class AuthenCommonWidget extends BaseStatelessScreenV2 {
  const AuthenCommonWidget({super.key});

  @override
  Widget buildBody(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: KeyboardDismisser(
        child: Column(
          children: [
            Expanded(
              child: buildContent(pageContext),
            ),
            const TermsAndConditions(),
            if (Platform.isIOS) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext pageContext);
}
