import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/popup/my_present_view_helper.dart';
import 'package:myutils/utils/widgets/my_web_view.dart';

class TermsAndConditions extends StatefulWidget {
  final Color? color;
  const TermsAndConditions({super.key, this.color});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final LocaleManager localeManager = injector();
  String urlPolicy = '';

  @override
  void initState() {
    super.initState();
    _loadPolicyUrl();
  }

  void _loadPolicyUrl() {
    urlPolicy = localeManager.loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)?.clauseLink ??
        'https://sunnydays.vn/privacy-policy';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPolicyUrl();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        MyPresentViewHelper.presentView(
          context: context,
          title: 'profile.termsAndConditions'.tr(),
          contentPadding: EdgeInsets.zero,
          enableDrag: false,
          hasInsetBottom: false,
          builder: Builder(
            builder: (context) {
              return FutureBuilder(
                future: Future.delayed(Duration.zero),
                builder: (contextFuture, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return MyWebViewWidget(
                      // url: urlPolicy,
                      url: 'https://sunnydays.vn/privacy-policy',
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
        );
      },
      child: StreamBuilder<String>(
          stream: LocalStream.shared.localeStream,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'authentication.agreementMessage'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: widget.color ?? MyColors.darkGrayColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: ' ${'authentication.termsOfService'.tr()} & ${'authentication.privacyPolicy'.tr()} ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: MyColors.accentColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: 'authentication.companyName'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: widget.color ?? MyColors.darkGrayColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
    );
  }
}
