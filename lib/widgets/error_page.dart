import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    @required this.errorMessage,
    this.imgPath = 'assets/illustrations/undraw_warning.png',
    this.info,
    this.actionText,
    this.actionOnTap,
    Key key,
  }) : super(key: key);

  final String imgPath;
  final String errorMessage;
  final List<InlineSpan> info;
  final String actionText;
  final void Function() actionOnTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(image: AssetImage(imgPath)),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (info != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.subtitle1,
                            children: info,
                          ),
                        ),
                      ),
                    ),
                  if (actionText != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: actionOnTap,
                        child: Text(actionText,
                            style: Theme.of(context)
                                .accentTextTheme
                                .subtitle2
                                .copyWith(fontWeight: FontWeight.w500)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}
