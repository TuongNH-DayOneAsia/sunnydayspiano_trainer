import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/output/contract_output.dart';
import 'package:myutils/data/repositories/profile_repository.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';

part 'electronic_contract_state.dart';

class ElectronicContractCubit extends WidgetCubit<ElectronicContractState> {
  final ProfileRepository _profileRepository = injector();

  ElectronicContractCubit() : super(widgetState: ElectronicContractState());

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  Future<void> getContract() async {
    final contractOutput = await fetchApi(() => _profileRepository.contract(), showLoading: true);
    if (language == 'en') {
      showEasyLoading();
      if (contractOutput?.statusCode == ApiStatusCode.success && contractOutput?.data?.isNotEmpty == true) {
        if (contractOutput?.data?.isNotEmpty == true) {
          for (var i = 0; i < contractOutput!.data!.length; i++) {
            contractOutput.data![i].name = await ToolHelper.translateText(contractOutput.data![i].name ?? '');
          }
        }
      } else {
        contractOutput?.message = await ToolHelper.translateText(contractOutput.message ?? '');
      }
      hideEasyLoading();
    }

    emit(state.copyWith(contractOutput: contractOutput));
  }
}
