import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RegulationsScreen extends StatelessWidget {


  static const routeName = '/regulations';
  const RegulationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text('Regulamin'),
          cupertino: (_, __) => CupertinoNavigationBarData(
            transitionBetweenRoutes: false,
            previousPageTitle: 'Profil'
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Regulamin',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                          '1. Aplikacja Scanning World jest aplikacją na konkurs Hack Heroes. Nie należy korzystać z niej realnie. Jest to aplikacja pokazowa.'),
                      const Text(
                          '2. Zdjęcia i dane w aplikacji są losowe. Nie należy ich traktować jako prawdziwe.'),
                      const Text('3. Zdjęcia są użyte ze strony unsplash.com oraz pixabay.com.'),
                    ]))));
  }
}
