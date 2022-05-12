import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/backupAndRestore/backupandrestore_cubit.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/backup.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/download.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_header.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';
import 'package:projects_archiving/view/widgets/error_widget.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  late BackupandrestoreCubit _backupB;
  final _backupNameC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _backupB = BlocProvider.of<BackupandrestoreCubit>(context);
    _backupB.getAllBackups();
  }

  void restoreAndLogout(Future<void> restoreFunc) async {
    await restoreFunc;
    if (!mounted) return;
    BlocProvider.of<UserCubit>(context).logOut();
    AutoRouter.of(context).replace(const LogInRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
          child: Column(
        children: [
          Text(
            Strings.backups,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.black),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  lableText: Strings.backupName + Strings.optionalWithBrackets,
                  controller: _backupNameC,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: AppButton(
                    text: Strings.createBackup,
                    buttonType: ButtonType.secondary,
                    onPressed: () {
                      _backupB.creatBackup(_backupNameC.text);
                      _backupNameC.clear();
                    }),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: AppButton(
                    text: Strings.restoreFromFile,
                    icon: const Icon(Icons.upload_file),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              withData: true,
                              allowedExtensions: ['zip']);

                      if (result != null) {
                        for (var file in result.files) {
                          final appfile =
                              AppFile(bytes: file.bytes!, name: file.name);
                          if (!mounted) return;
                          context.showConfirmDialog(
                            () => restoreAndLogout(
                                _backupB.restoreBackupWithFile(appfile)),
                            title: Strings.mustLogOutWhenRestore,
                          );
                        }
                      } else {
                        // User canceled the picker
                      }
                    }),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<BackupandrestoreCubit,
                BlocsState<ResWithCount<Backup>?>>(
              builder: (context, state) {
                return state.maybeWhen(
                    data: (results) {
                      if (results != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Strings.count(results.count.toString())),
                            Expanded(
                              child: ListView.builder(
                                itemCount: results.results.length,
                                itemBuilder: (context, index) {
                                  final b = results.results[index];
                                  return BakcupItem(
                                    backup: b,
                                    onDeletePressed: () =>
                                        _backupB.deleteBackup(b.key),
                                    onRestorePressed: () {
                                      restoreAndLogout(
                                          _backupB.restoreBackupWithKey(b.key));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        _backupB.getAllBackups();
                        return const SizedBox.shrink();
                      }
                    },
                    failure: (e) => AppErrorWidget(
                        errorMessage: e.readableMessage,
                        onRefresh: _backupB.getAllBackups),
                    loading: () => const CircularProgressIndicator.adaptive(),
                    orElse: () => const SizedBox.shrink());
              },
            ),
          )
        ],
      )),
    );
  }
}

class BakcupItem extends StatelessWidget {
  final Backup backup;
  final VoidCallback onDeletePressed;
  final VoidCallback onRestorePressed;

  const BakcupItem(
      {Key? key,
      required this.backup,
      required this.onDeletePressed,
      required this.onRestorePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(backup.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(intl.DateFormat.yMEd('ar').format(backup.date)),
            Text(backup.size, textDirection: TextDirection.ltr),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: () => context.showConfirmDialog(
                onRestorePressed,
                title: Strings.mustLogOutWhenRestore,
              ),
              text: Strings.restore,
              icon: const Icon(Icons.restore),
            ),
            const SizedBox(width: 10),
            AppButton(
                onPressed: () => downLoadStorageBackup(backup.key),
                text: Strings.downloadfiles,
                icon: const Icon(Icons.storage),
                backroundColor: Colors.green),
            const SizedBox(width: 10),
            AppButton(
              onPressed: () => downLoadDBackup(backup.key),
              text: Strings.downloadSQL,
              icon: const Icon(Icons.download_for_offline_outlined),
              backroundColor: Colors.blue,
            ),
            const SizedBox(width: 10),
            AppButton(
              onPressed: () => context.showConfirmDialog(onDeletePressed),
              text: Strings.delete,
              icon: const Icon(Icons.delete),
              backroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
