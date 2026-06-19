import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            children: [
              const TextSpan(text: 'Desenvolvido por '),
              TextSpan(
                text: 'Multiti Consultoria & Solucoes em Tecnologia',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Visitar site'),
                        content: const SelectableText('https://www.multiti.com.br'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
