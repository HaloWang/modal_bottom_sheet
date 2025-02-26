import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const Radius kDefaultBarTopRadius = Radius.circular(15);

class BarBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? control;
  final Clip? clipBehavior;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final SystemUiOverlayStyle? overlayStyle;
  final bool additionalStyles;
  final bool showDragIndicator;
  final bool allowShape;
  final bool pure;

  const BarBottomSheet({
    super.key,
    required this.child,
    this.control,
    this.clipBehavior,
    this.shape,
    this.backgroundColor,
    this.elevation,
    this.overlayStyle,
    this.additionalStyles = false,
    this.showDragIndicator = false,
    this.allowShape = false,
    this.pure = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle ?? SystemUiOverlayStyle.light,
      child: pure
          ? child
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (additionalStyles) SizedBox(height: 12),
                if (showDragIndicator)
                  SafeArea(
                    bottom: false,
                    child: control ??
                        Container(
                          height: 6,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                  ),
                if (showDragIndicator) SizedBox(height: 8),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Material(
                    shape: allowShape
                        ? (shape ??
                            RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadius.only(
                                  topLeft: kDefaultBarTopRadius,
                                  topRight: kDefaultBarTopRadius),
                            ))
                        : null,
                    clipBehavior: clipBehavior ?? Clip.hardEdge,
                    color: backgroundColor ?? Colors.white,
                    elevation: elevation ?? 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: MediaQuery.removePadding(
                          context: context, removeTop: true, child: child),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

Future<T?> showBarModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color barrierColor = Colors.black87,
  bool bounce = true,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Widget? topControl,
  Duration? duration,
  RouteSettings? settings,
  SystemUiOverlayStyle? overlayStyle,
  double? closeProgressThreshold,
  bool additionalStyles = false,
  bool showDragIndicator = false,
  bool allowShape = false,
  bool pure = true,
  double minFlingVelocity = 500,
}) async {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  final result = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push(ModalSheetRoute<T>(
    builder: builder,
    bounce: bounce,
    minFlingVelocity: minFlingVelocity,
    closeProgressThreshold: closeProgressThreshold,
    containerBuilder: (_, __, child) => BarBottomSheet(
      additionalStyles: additionalStyles,
      showDragIndicator: showDragIndicator,
      child: child,
      control: topControl,
      clipBehavior: clipBehavior,
      shape: shape,
      backgroundColor: backgroundColor,
      elevation: elevation,
      overlayStyle: overlayStyle,
      allowShape: allowShape,
      pure: pure,
    ),
    secondAnimationController: secondAnimation,
    expanded: expand,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    enableDrag: enableDrag,
    animationCurve: animationCurve,
    duration: duration,
    settings: settings,
  ));
  return result;
}
