import 'package:flutter/material.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  late TextEditingController _projectNameCntrl,
      _strudentName,
      _supervisorName,
      _keyWordController,
      _abstractController;

  DateTime? _selectedYear;
  Level _selectedLevel = Level.bachelor;
  final List<String> _keyWords = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _projectNameCntrl = TextEditingController();
    _strudentName = TextEditingController();
    _supervisorName = TextEditingController();
    _abstractController = TextEditingController();
    _keyWordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _projectNameCntrl,
                    lableText: Strings.projectName,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _strudentName,
                    lableText: Strings.studentName,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _supervisorName,
                    lableText: Strings.supervisorName,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _supervisorName,
                    lableText: Strings.studentPhoneNumber,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime.now())
                                .then(
                                    (sd) => setState(() => _selectedYear = sd));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(Strings.graduationYear),
                                    Text(
                                      _selectedYear?.year.toString() ??
                                          Strings.selectYear,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(Strings.level),
                              DropdownButtonFormField<Level>(
                                  isDense: true,
                                  icon: const SizedBox.shrink(),
                                  decoration: const InputDecoration.collapsed(
                                    hintText: '',
                                    border: InputBorder.none,
                                  ),
                                  // decoration:
                                  //     InputDecoration(icon: SizedBox.shrink()),
                                  items: Level.values
                                      .map((e) => DropdownMenuItem<Level>(
                                          child: Text(
                                            e.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                          ),
                                          value: e))
                                      .toList(),
                                  value: _selectedLevel,
                                  onChanged: (lvl) => setState(
                                        () => _selectedLevel = lvl!,
                                      )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _abstractController,
                    lableText: Strings.abstract + Strings.optionalWithBrackets,
                    minLines: 5,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Strings.keywords + Strings.optionalWithBrackets,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AppTextField(
                          lableText: 'مثال: تطبيق هاتف',
                          controller: _keyWordController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                            text: 'اضافة',
                            onPressed: () {
                              if (_keyWordController.text.isNotEmpty) {
                                setState(() {
                                  _keyWords.add(_keyWordController.text);
                                });
                              }
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    width: double.infinity,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 30 / 10,
                      children: _keyWords
                          .map((e) => Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.4),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(e),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _keyWords.remove(e);
                                          });
                                        },
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
