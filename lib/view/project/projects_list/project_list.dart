import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/blocs/projects_filter/projects_filter_bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/download.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/project/projects_list/project_card.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/error_widget.dart';
import 'package:projects_archiving/view/widgets/projects_filter_dilaog.dart';

extension PagingUtils on PagingController {
  void addItems<T>(ResWithCount<T> data, [int limitSize = 25]) {
    final nextPageKey = (itemList?.length ?? 0) + limitSize;

    final isLastPage = nextPageKey >= data.count;
    if (isLastPage) {
      appendLastPage(data.results);
    } else {
      appendPage(data.results, nextPageKey);
    }
  }
}

class ProjectsList extends StatefulWidget {
  const ProjectsList({Key? key}) : super(key: key);

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  late ProjectsBloc _projectsP;
  late ProjectsFilterBloc projectsF;

  final PagingController<int, Project> _pagingController =
      PagingController(firstPageKey: 0);

  late StreamSubscription<BlocsState<ResWithCount<Project>>> projectsStream;

  @override
  void initState() {
    _projectsP = ProjectsBloc.of(context);
    projectsF = BlocProvider.of<ProjectsFilterBloc>(context, listen: false);

    _pagingController.addPageRequestListener((pageKey) {
      _projectsP.add(ProjectsEvent.loadProjects(pageKey));
    });
    projectsStream = _projectsP.stream.listen((event) {
      event.whenOrNull(
        data: (results) => _pagingController.addItems(results),
        failure: (e) => _pagingController.error = e.readableMessage,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    projectsStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Row(
              children: [
                BlocBuilder<ProjectsBloc, BlocsState>(
                  builder: (context, state) {
                    return Text(
                      Strings.count(_projectsP.state.whenOrNull(
                          data: (r) => r.count.toString(),
                          loading: () => Strings.loading)),
                    );
                  },
                ),
                const Spacer(),
                AppButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => FilterDialog(
                              onFilterChange: () {
                                _pagingController.refresh();
                              },
                            ));
                  },
                  buttonType: ButtonType.secondary,
                  text: Strings.filtering,
                  textColor: Colors.black,
                  icon: Icon(
                    Icons.filter_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                if (BlocProvider.of<UserCubit>(context, listen: false)
                    .isLoggedIn)
                  AppButton(
                    onPressed: () => downLoadExcel(projectsF.state.filter),
                    buttonType: ButtonType.secondary,
                    text: Strings.downloadData,
                    textColor: Colors.black,
                    icon: Icon(
                      Icons.download,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LayoutBuilder(builder: (context, c) {
              final cac = (c.maxWidth ~/ 400).toInt();
              return PagedGridView<int, Project>(
                pagingController: _pagingController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cac == 0 ? 1 : cac,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 280,
                ),
                builderDelegate: PagedChildBuilderDelegate<Project>(
                  animateTransitions: false,
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Strings.noProjects,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => FilterDialog(
                                      onFilterChange: () {
                                        _pagingController.refresh();
                                      },
                                    ));
                          },
                          child: const Text(Strings.changeFilter),
                        )
                      ],
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => AppErrorWidget(
                      errorMessage: _pagingController.error,
                      onRefresh: () {
                        _projectsP.add(const ProjectsEvent.started());
                      }),
                  itemBuilder: (context, item, index) => ProjectCard(p: item),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
