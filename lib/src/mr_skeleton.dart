import 'package:flutter/material.dart';

typedef MRSkeletonMobileBuilder = Widget Function(Widget child);

class MRSkeleton extends StatelessWidget {
  const MRSkeleton({
    Key? key,
    required this.top,
    required this.left,
    required this.body,
    required this.mobileBuilder,
    this.right,
    this.collapsedLeftWidth = 60,
    this.expandedLeftWidth,
    this.expandedRightWidth,
    this.isLeftExpanded = false,
    this.isRightExpanded = false,
    this.desktopBreakpointWidth = 1100,
    this.onDesktopBreakpointChanged,
  }) : super(key: key);

  final Widget top;
  final Widget body;
  final Widget left;
  final MRSkeletonMobileBuilder mobileBuilder;

  final Widget? right;
  final double collapsedLeftWidth;
  final bool isLeftExpanded;
  final bool isRightExpanded;
  final double? expandedRightWidth;
  final double? expandedLeftWidth;
  final double desktopBreakpointWidth;
  final Function(bool)? onDesktopBreakpointChanged;

  @override
  Widget build(BuildContext context) {
    final leftChild = isLeftExpanded
        ? expandedLeftWidth != null
            ? SizedBox(width: expandedLeftWidth, child: left)
            : Flexible(
                child: left,
                fit: FlexFit.tight,
              )
        : SizedBox(width: collapsedLeftWidth, child: left);

    var rightChild;
    if (right != null) {
      rightChild = expandedRightWidth != null
          ? SizedBox(width: expandedRightWidth, child: right)
          : Expanded(
              flex: 3,
              child: right!,
            );
    }

    final isDesktop =
        MediaQuery.of(context).size.width >= desktopBreakpointWidth;

    if (onDesktopBreakpointChanged != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        onDesktopBreakpointChanged!(isDesktop);
      });
    }

    if (isDesktop) {
      return Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftChild,
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    top,
                    Expanded(
                      flex: 5,
                      child: body,
                    ),
                  ],
                ),
              ),
              if (isRightExpanded && rightChild != null) rightChild
            ],
          ),
        ),
      );
    }

    return mobileBuilder(body);
  }
}
