import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';

/// The Nivaas Hub app mark (no wordmark) shown at the top of the login and
/// password screens.
class AuthBrandLogo extends StatelessWidget {
  const AuthBrandLogo({super.key, this.size = 104});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        AppAssets.splashMark,
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticsLabel: 'Nivaas Hub',
      ),
    );
  }
}
