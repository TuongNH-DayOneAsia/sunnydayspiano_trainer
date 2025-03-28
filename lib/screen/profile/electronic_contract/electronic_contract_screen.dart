import 'package:dayoneasia/screen/profile/pdf/pdf_viewer_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

import 'cubit/electronic_contract_cubit.dart';

class ElectronicContractScreen extends BaseStatelessScreenV2 {
  static const String route = '/electronic_contract';

  const ElectronicContractScreen({super.key});

  @override
  String? get title => 'profile.electronicContract'.tr();

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => ElectronicContractCubit()..getContract(),
      child: BlocBuilder<ElectronicContractCubit, ElectronicContractState>(
        builder: (context, state) {
          return state.contractOutput?.data?.isNotEmpty == true
              ? ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  shrinkWrap: true,
                  itemCount: state.contractOutput?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (state.contractOutput?.data?[index].file != null) {
                          pageContext.push(PdfViewerScreen.route, extra: state.contractOutput?.data?[index]);
                        }
                      },
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Row(
                            children: [
                              MyAppIcon.iconNamedCommon(iconName: 'profile/pdf.svg', width: 24.w, height: 24.w),
                              SizedBox(width: 12.w),
                              Expanded(child: Text(state.contractOutput?.data?[index].name ?? '')),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.h);
                  },
                )
              : Center(
                  child: Text(state.contractOutput?.message ?? ''),
                );
        },
      ),
    );
  }
}
