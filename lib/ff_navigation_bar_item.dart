import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ff_navigation_bar_theme.dart';

// This class has mutable instance properties as they are used to store
// calculated values required by multiple build functions but not known
// (or required to be specified) at creation of instance parameters.
// For example, a color attribute will be modified depending on whether
// the item is selected or not.
// They are also used to store values retrieved from a Provider allowing
// properties to be communicated from the navigation bar to the individual
// items of the bar.

// ignore: must_be_immutable
class FFNavigationBarItem extends StatelessWidget {
  final String label;
  final IconData iconData;
  final AssetImage assetImage;
  final int iconSize;
  final Duration animationDuration;
  Color selectedBackgroundColor;
  Color selectedForegroundColor;
  TextStyle selectedTextStyle;
  TextStyle unselectedTextStyle;
  int index;
  int selectedIndex;
  FFNavigationBarTheme theme;
  bool showSelectedItemTopShadow;
  bool showSelectedItemBottomShadow;
  double itemWidth;

  FFNavigationBarItem({
    Key key,
    this.label,
    this.itemWidth = 60,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.iconData,
    this.animationDuration = kDefaultAnimationDuration,
    this.assetImage,
    this.iconSize,
  }) : super(key: key);

  void setIndex(int index) {
    this.index = index;
  }

  Color _getDerivedBorderColor() {
    return theme.selectedItemBorderColor ?? theme.barBackgroundColor;
  }

  Color _getBorderColor(bool isOn) {
    return isOn ? _getDerivedBorderColor() : Colors.transparent;
  }

  bool _isItemSelected() {
    return index == selectedIndex;
  }

  static const kDefaultAnimationDuration = Duration(milliseconds: 1500);

  Center _makeLabel(String label) {
    bool isSelected = _isItemSelected();
    return Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: isSelected ? selectedTextStyle ?? theme.selectedItemTextStyle : unselectedTextStyle ?? theme.unselectedItemTextStyle,
      ),
    );
  }

  Widget _makeIconArea(double itemWidth, IconData iconData) {
    bool isSelected = _isItemSelected();
    double radius = itemWidth / 2;
    double innerBoxSize = itemWidth - 8;
    double innerRadius = (itemWidth - 8) / 2 - 4;

    return CircleAvatar(
      radius: isSelected ? radius : radius * 0.7,
      backgroundColor: _getBorderColor(isSelected),
      child: SizedBox(
        width: innerBoxSize,
        height: isSelected ? innerBoxSize : innerBoxSize / 2,
        child: CircleAvatar(
          radius: innerRadius,
          backgroundColor: isSelected ? selectedBackgroundColor ?? theme.selectedItemBackgroundColor : theme.unselectedItemBackgroundColor,
          child: iconData == null ? _makeImageIcon(assetImage) : _makeIcon(iconData),
        ),
      ),
    );
  }

  Widget _makeImageIcon(assetImage) {
    bool isSelected = _isItemSelected();
    return ImageIcon(
      assetImage,
      color: isSelected ? selectedForegroundColor ?? theme.selectedItemIconColor : theme.unselectedItemIconColor,
      size: iconSize?.toDouble() ?? theme.iconSize.toDouble(),
    );
  }

  Widget _makeIcon(
    IconData iconData,
  ) {
    bool isSelected = _isItemSelected();
    return Icon(
      iconData,
      color: isSelected ? selectedForegroundColor ?? theme.selectedItemIconColor : theme.unselectedItemIconColor,
      size: iconSize?.toDouble() ?? theme.iconSize.toDouble(),
    );
  }

  Widget _makeSelectedItemTopShadow() {
    bool isSelected = _isItemSelected();
    double height = isSelected ? 15 : 0;
    double width = isSelected ? itemWidth + 2 : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(itemWidth / 2, 2)),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
          ),
        ],
      ),
    );
  }

  Widget _makeSelectedItemBottomShadow() {
    bool isSelected = _isItemSelected();
    double height = isSelected ? 4 : 0;
    double width = isSelected ? itemWidth + 2 : 0;
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(itemWidth / 2, 2)),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<FFNavigationBarTheme>(context);
    showSelectedItemTopShadow = theme.showSelectedItemTopShadow;
    showSelectedItemBottomShadow = theme.showSelectedItemBottomShadow;
    itemWidth = theme.itemWidth;
    selectedIndex = Provider.of<int>(context);

    selectedBackgroundColor = selectedBackgroundColor ?? theme.selectedItemBackgroundColor;
    selectedForegroundColor = selectedForegroundColor ?? theme.selectedItemIconColor;

    bool isSelected = _isItemSelected();
    double itemHeight = itemWidth - 20;
    double topOffset = isSelected ? -20 : -10;
    double iconTopSpacer = isSelected ? 0 : 2;
    double shadowTopSpacer = 4;

    Widget labelWidget = _makeLabel(label);
    Widget iconAreaWidget = _makeIconArea(itemWidth, iconData);
    Widget topShadowWidget = showSelectedItemTopShadow ? _makeSelectedItemTopShadow() : Container();
    Widget bottomShadowWidget = showSelectedItemBottomShadow ? _makeSelectedItemBottomShadow() : Container();

    return AnimatedContainer(
      width: itemWidth,
      height: double.maxFinite,
      duration: animationDuration,
      child: SizedBox(
        width: itemWidth,
        height: itemHeight,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: topOffset - 2,
              left: -itemWidth / 2,
              right: -itemWidth / 2,
              child: Column(
                children: <Widget>[topShadowWidget],
              ),
            ),
            Positioned(
              top: isSelected ? topOffset - 3.5 : topOffset,
              left: -itemWidth / 2,
              right: -itemWidth / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: iconTopSpacer),
                  iconAreaWidget,
                  labelWidget,
                  SizedBox(height: shadowTopSpacer),
                  bottomShadowWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
