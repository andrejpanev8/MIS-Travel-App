import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/empty_list_indicator.dart';
import 'package:travel_app/utils/string_constants.dart';

Widget widgetBuilder<T>({
  required BuildContext context,
  required List<T> items,
  required Widget Function(BuildContext, T) itemBuilder,
  Future<void> Function()? onRefresh,
  Widget Function(BuildContext, int)? separatorBuilder,
  Widget? emptyWidget,
  ScrollPhysics? scrollPhysics,
}) {
  return SafeArea(
    child: RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: items.isNotEmpty
          ? ListView.separated(
              physics: scrollPhysics ?? AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  itemBuilder(context, items[index]),
              separatorBuilder:
                  separatorBuilder ?? (context, index) => SizedBox(height: 10),
              shrinkWrap: true,
            )
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(
                child: emptyWidget ??
                    emptyListIndicator(AppStrings.noItemsAvailable),
              ),
            ),
    ),
  );
}
