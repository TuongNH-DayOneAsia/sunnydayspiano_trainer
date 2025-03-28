import 'package:dayoneasia/screen/authen/apple_testing/otp/apple_otp_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'apple_register_account_cubit.dart';

class AppleRegisterAccountScreen extends BaseStatelessScreenV2 {
  static const String route = '/register';

  const AppleRegisterAccountScreen({
    super.key,
  });

  @override
  String get title => 'Tạo tài khoản';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppleRegisterAccountCubit(),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<AppleRegisterAccountCubit, AppleRegisterAccountState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              CustomTextField(
                keyboardType: TextInputType.text,
                onChanged: (v) {
                  context.read<AppleRegisterAccountCubit>().firstNameSubject.add(v);
                },
                hintText: 'Họ',
              ),
              const SizedBox(
                height: 18,
              ),
              CustomTextField(
                keyboardType: TextInputType.text,
                onChanged: (v) {
                  context.read<AppleRegisterAccountCubit>().lastNameSubject.add(v);
                },
                hintText: 'Tên',
              ),
              const SizedBox(
                height: 18,
              ),
              // BirthdayPicker(),
              // const SizedBox(
              //   height: 18,
              // ),
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) {
                  context.read<AppleRegisterAccountCubit>().phoneOrEmailSubject.add(v);
                },
                hintText: 'Email',
                validateInput: (value) {
                  return ''.validateEmail(value);
                },
              ),
              const SizedBox(
                height: 18,
              ),
              // _BuildSelectGender(),
              const SizedBox(
                height: 18,
              ),
              StreamBuilder<bool>(
                stream: context.read<AppleRegisterAccountCubit>().isValidStream,
                initialData: false,
                builder: (context, snapshot) {
                  return Center(
                    child: MyButton(
                      width: Dimens.getProportionalScreenWidth(context, 295),
                      fontSize: 14,
                      text: 'Tiếp tục',
                      isEnable: snapshot.data!,
                      color: snapshot.data! ? MyColors.mainColor : MyColors.lightGrayColor.withOpacity(0.6),
                      height: 38.h,
                      onPressed: (value) {
                        if (snapshot.data!) {
                          context.read<AppleRegisterAccountCubit>().sendCodeVerify(onSuccess: (v) {
                            context.push(AppleOtpScreen.route, extra: v);
                          }, onError: (String message) {
                            _showPopupError(context: context, description: message, title: 'Notification');
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPopupError({required BuildContext context, required String description, required String title}) {
    MyPopupMessage.showPopUpWithIcon(
      title: title,
      context: context,
      barrierDismissible: false,
      description: description,
      colorIcon: MyColors.redColor,
      iconAssetPath: 'booking/booking_not_data.svg',
      confirmText: 'bookingClass.goBack'.tr(),
    );
  }
}

class _BuildSelectGender extends StatefulWidget {
  @override
  _BuildSelectGenderState createState() => _BuildSelectGenderState();
}

class _BuildSelectGenderState extends State<_BuildSelectGender> {
  String? selectedGender;

  Widget _buildSelectGender() {
    List<String> genders = ['Male', 'Female'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: genders.map((data) => _buildDurationItem(data)).toList(),
    );
  }

  Widget _buildDurationItem(String data) {
    bool isSelected = selectedGender == data;
    return BlocBuilder<AppleRegisterAccountCubit, AppleRegisterAccountState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: InkWell(
            onTap: () {
              setState(() {
                if (selectedGender == data) {
                  selectedGender = null;
                  context.read<AppleRegisterAccountCubit>().gender = '';
                } else {
                  selectedGender = data;
                  context.read<AppleRegisterAccountCubit>().gender = data;
                }
              });
            },
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: MyColors.mainColor,
                  size: 16.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectGender();
  }
}

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({super.key});

  @override
  _BirthdayPickerState createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  DateTime? selectedDate;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = "No date chosen";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime fourYearsAgo = DateTime(now.year - 4, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? fourYearsAgo,
      firstDate: DateTime(1900),
      lastDate: fourYearsAgo,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        context.read<AppleRegisterAccountCubit>().birthday = _dateController.text;
      });
    }
  }

  void _clearDate() {
    setState(() {
      selectedDate = null;
      _dateController.text = "No date chosen";
      context.read<AppleRegisterAccountCubit>().birthday = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: MyColors.mainColor),
        labelText: 'Birthday',
        suffixIcon: selectedDate != null
            ? IconButton(
                icon: Icon(Icons.clear, color: MyColors.mainColor),
                onPressed: _clearDate,
              )
            : Icon(
                Icons.calendar_today,
                color: MyColors.mainColor,
              ),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
