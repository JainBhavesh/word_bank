import 'package:flutter/material.dart';
import 'package:insta_login/insta_view.dart';

class InstaLoginScreen extends StatelessWidget {
  final String? instaAppId;
  final String? instaAppSecret;
  final String? redirectUrl;

  const InstaLoginScreen({
    super.key,
    this.instaAppId,
    this.instaAppSecret,
    this.redirectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instagram Login')),
      body: Center(
        child: InstaView(
          instaAppId: instaAppId ?? 'default_instagram_app_id',
          instaAppSecret: instaAppSecret ?? 'default_instagram_app_secret',
          redirectUrl: redirectUrl ?? 'https://your_default_redirect_url.com/',
          onComplete: (token, userId, username) {
            Navigator.pop(context, {
              'token': token,
              'userId': userId,
              'username': username,
            });
          },
        ),
      ),
    );
  }
}
