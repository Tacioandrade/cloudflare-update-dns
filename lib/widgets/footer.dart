import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Desenvolvido por ', style: TextStyle(color: Colors.grey, fontSize: 12)),
          InkWell(
            onTap: () async {
              final url = Uri.parse('https://www.multiti.com.br');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: const Text(
              'Multiti Consultoria & Solucoes em Tecnologia',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        ),
      ),
    );
  }
}
