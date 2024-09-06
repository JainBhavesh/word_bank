import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int currentIndex = 0;

  final List<Map<String, String>> reviewContent = [
    {
      'word': 'apple',
      'pronunciation': 'apple',
      'meaning': '蘋果',
      'type': 'noun',
      'sentence': 'He made an apple pie for his grandma.',
      'translation': '他給奶奶做了一個蘋果派。',
    },
    {
      'word': 'inappropriately',
      'pronunciation': 'inappropriately',
      'meaning': '不恰當地',
      'type': '(adv)',
      'sentence':
          "Even if you feel like you're using a word inappropriately at first, keep practicing and you'll get better every day!",
      'translation': '即使一開始你覺得自己用詞不當，但只要繼續練習，每天都會變得更好！',
    },
  ];

  void _next() {
    if (currentIndex < reviewContent.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _prev() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _quitReview() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final content = reviewContent[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${currentIndex + 1}/${reviewContent.length}'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '38812',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  content['word']!,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Icon(
                    Icons.volume_up), // Placeholder for pronunciation icon
                const SizedBox(height: 10),
                Text(
                  content['meaning']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  content['type']!,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle AI content logic here
                  },
                  icon: const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'AI content',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (content['sentence'] != null) ...[
              Text(
                content['sentence']!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                content['translation']!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _prev,
                  icon: const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  label:
                      const Text('Prev', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: _quitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                currentIndex == reviewContent.length - 1
                    ? '完成複習'
                    : 'Quit review',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
