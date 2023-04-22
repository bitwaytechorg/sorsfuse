import 'package:flutter/material.dart';

/// //////////////////////////////////////////////////////////////
/// Styles - Contains the design system for the entire app.
/// Includes paddings, text styles, timings etc. Does not include colors, check [AppTheme] file for that.

/// Used for all animations in the  app
class Times {
  static const Duration fastest = const Duration(milliseconds: 150);
  static const fast = const Duration(milliseconds: 250);
  static const medium = const Duration(milliseconds: 350);
  static const slow = const Duration(milliseconds: 700);
  static const slower = const Duration(milliseconds: 1000);
}

class Sizes {
  static double hitScale = 1;
  static double get hit => 40 * hitScale;
}

class IconSizes {
  static const double scale = 1;
  static const double med = 24;
}

class Insets {
  static double scale = 1;
  static double offsetScale = 1;
  // Regular paddings
  static double get xs => 4 * scale;
  static double get sm => 8 * scale;
  static double get med => 12 * scale;
  static double get lg => 16 * scale;
  static double get xl => 32 * scale;
  // Offset, used for the edge of the window, or to separate large sections in the app
  static double get offset => 40 * offsetScale;
}

class Corners {
  static const double sm = 3;
  static const BorderRadius smBorder = const BorderRadius.all(smRadius);
  static const Radius smRadius = const Radius.circular(sm);

  static const double med = 5;
  static const BorderRadius medBorder = const BorderRadius.all(medRadius);
  static const Radius medRadius = const Radius.circular(med);

  static const double lg = 8;
  static const BorderRadius lgBorder = const BorderRadius.all(lgRadius);
  static const Radius lgRadius = const Radius.circular(lg);
}

class Strokes {
  static const double thin = 1;
  static const double thick = 4;
}

class Shadows {
  static List<BoxShadow> get universal => [
    BoxShadow(
        color: Color(0xff333333).withOpacity(.15),
        spreadRadius: 0,
        blurRadius: 10),
  ];
  static List<BoxShadow> get small => [
    BoxShadow(
        color: Color(0xff333333).withOpacity(.15),
        spreadRadius: 0,
        blurRadius: 3,
        offset: Offset(0, 1)),
  ];
}

/// Font Sizes
/// You can use these directly if you need, but usually there should be a predefined style in TextStyles.
class FontSizes {
  /// Provides the ability to nudge the app-wide font scale in either direction
  static double get scale => 1;
  static double get s10 => 10 * scale;
  static double get s11 => 11 * scale;
  static double get s12 => 12 * scale;
  static double get s14 => 14 * scale;
  static double get s16 => 16 * scale;
  static double get s24 => 24 * scale;
  static double get s48 => 48 * scale;
}

/// Fonts - A list of Font Families, this is uses by the TextStyles class to create concrete styles.
class Fonts {
  static const String raleway = "Raleway";
  static const String fraunces = "Fraunces";
}

/// TextStyles - All the core text styles for the app should be declared here.
/// Don't try and create every variant in existence here, just the high level ones.
/// More specific variants can be created on the fly using `style.copyWith()`
/// `newStyle = TextStyles.body1.copyWith(lineHeight: 2, color: Colors.red)`
class TextStyles {
  /// Declare a base style for each Family
  static const TextStyle raleway = const TextStyle(
      fontFamily: Fonts.raleway,
      fontWeight: FontWeight.w400,
      height: 1,
      color: Colors.blueGrey);
  static const TextStyle fraunces = const TextStyle(
      fontFamily: Fonts.fraunces,
      fontWeight: FontWeight.w400,
      height: 1,
      color: Color(0xFF436E7A)); //FF546E7A

  static TextStyle get h1 => fraunces.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.s48,
      letterSpacing: -1,
      height: 1.17);
  static TextStyle get h2 =>
      h1.copyWith(fontSize: FontSizes.s24, letterSpacing: -.5, height: 1.16);
  static TextStyle get h3 =>
      h1.copyWith(fontSize: FontSizes.s14, letterSpacing: -.05, height: 1.29);
  static TextStyle get title1 => raleway.copyWith(
      fontWeight: FontWeight.bold, fontSize: FontSizes.s16, height: 1.31);
  static TextStyle get title2 => title1.copyWith(
      fontWeight: FontWeight.w500, fontSize: FontSizes.s14, height: 1.36);
  static TextStyle get s1 => title1.copyWith(
      fontWeight: FontWeight.w400, fontSize: FontSizes.s14, height: 1.26);
  static TextStyle get s2 => title1.copyWith(
      fontWeight: FontWeight.w400, fontSize: FontSizes.s14, height: 1.30);

  static TextStyle get body1 => raleway.copyWith(
      fontWeight: FontWeight.normal, fontSize: FontSizes.s14, height: 1.71);
  static TextStyle get body2 =>
      body1.copyWith(fontSize: FontSizes.s12, height: 1.5, letterSpacing: .2);
  static TextStyle get body3 => body1.copyWith(
      fontSize: FontSizes.s12, height: 1.5, fontWeight: FontWeight.bold);
  static TextStyle get callout1 => raleway.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: FontSizes.s12,
      height: 1.17,
      letterSpacing: .5);
  static TextStyle get callout2 =>
      callout1.copyWith(fontSize: FontSizes.s10, height: 1, letterSpacing: .25);
  static TextStyle get caption => raleway.copyWith(
      fontWeight: FontWeight.w500, fontSize: FontSizes.s11, height: 1.36);
}


enum ListOrder {
  unordered,
  ordered,
}

enum BulletType {
  numbered,
  conventional,
}

/// Flutter widget that defines both *unordered lists* of Widgets and *ordered
/// lists* of Strings of text with a default round bullet preceding each item.
///

class BulletedList extends StatelessWidget {
  /// Required. [listItems] may be a list of Strings or a list of Widgets
  final List<dynamic> listItems;

  /// Optional. Additional styling for a String item. Ignored for Widget items.
  final TextStyle? style;

  /// Optional. If this widget is not specified, a default dark circle is used.
  final Widget? bullet;

  /// Optional. Applicable only for String items. Ignored for Widget items.
  final ListOrder listOrder;

  /// Optional. Color for the default bullet. Ignored if [bullet] above is specified.
  final Color bulletColor;

  /// Optional. Cross axis alignment of the items list. Center is default.
  final CrossAxisAlignment crossAxisAlignment;

  /// Optional. Specify BulletType.numbered to generate a numbered list. Conventional is the default.
  final BulletType bulletType;

  /// Optional. Specify text color for the number in numbered bullet.
  final Color numberColor;

  /// Optional. Specify shape of the default bullet. Circle is the default.
  final BoxShape boxShape;

  const BulletedList({
    Key? key,
    required this.listItems,
    this.style,
    this.bullet,
    this.listOrder = ListOrder.unordered,
    this.bulletColor = Colors.blueGrey,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.bulletType = BulletType.conventional,
    this.numberColor = Colors.white,
    this.boxShape = BoxShape.circle,
  }) : super(key: key);

  Widget _bullet(BuildContext context) {
    return bullet ??
        Container(
          height: 10,
          width: 10,
          decoration: new BoxDecoration(
            color: bulletColor,
            shape: boxShape,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    Widget _numberedBullet(dynamic item) {
      final int number = 1 + listItems.indexWhere((e) => e == item);
      if (number < 1) {
        return _bullet(context);
      }
      final double boxSize = 10 + (1.0 * listItems.length);
      return Container(
        alignment: Alignment.center,
        height: boxSize,
        width: boxSize,
        decoration: new BoxDecoration(
          color: bulletColor,
          shape: boxShape,
        ),
        child: Text(
          number.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (listOrder == ListOrder.ordered && listItems is List<String>) {
      listItems.sort((a, b) => a.compareTo(b));
    }

    return Container(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: listItems
            .map(
              (item) => ListTile(
              dense: true,
              minLeadingWidth: 10,
              leading: bulletType == BulletType.conventional
                  ? _bullet(context)
                  : _numberedBullet(item),
              title: item == null
                  ? Text(
                '',
                style: TextStyles.body1,
              )
                  : item is String
                  ? Text(item, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))
                  : item is Widget
                  ? item
                  : Text(
                'Error: Only Widget/String allowed:\n' +
                    item.toString(),
              )),
        )
            .toList(),
      ),
    );
  }
}
