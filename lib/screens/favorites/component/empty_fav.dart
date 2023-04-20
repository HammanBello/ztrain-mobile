import 'package:flutter/material.dart';

class EmptyFav extends StatelessWidget {
  const EmptyFav({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      // 2
      child: Center(
        // 3
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  'assets/images/undraw_With_love_re_1q3m.png',
                ),
                // child: SvgPicture.asset(
                //     'assets/images/undraw_empty_cart_co35.svg'),
              ),
            ),
            Text(
              'Vous n\'avez pas de favoris',
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}
