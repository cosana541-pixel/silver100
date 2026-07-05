import 'package:flutter/material.dart';

import '../widgets/large_button.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _page = 0;

  static const _items = [
    _TutorialItem(
      icon: Icons.apps,
      title: '게임을 고르세요',
      text: '홈 화면에서 하고 싶은 게임 카드를 하나 고르면 됩니다.',
    ),
    _TutorialItem(
      icon: Icons.touch_app,
      title: '천천히 누르세요',
      text: '급하게 하지 않아도 됩니다. 큰 버튼을 천천히 눌러 주세요.',
    ),
    _TutorialItem(
      icon: Icons.favorite,
      title: '틀려도 괜찮아요',
      text: '정답이 아니어도 괜찮습니다. 연습하듯이 다시 해보면 됩니다.',
    ),
    _TutorialItem(
      icon: Icons.emoji_events,
      title: '결과를 확인하세요',
      text: '게임이 끝나면 결과와 오늘의 기록을 볼 수 있습니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final item = _items[_page];
    final isLast = _page == _items.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      '실버100',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12, width: 2),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            item.icon,
                            size: 108,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            item.text,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _items.length,
                  (index) => Container(
                    width: index == _page ? 36 : 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: index == _page
                          ? Theme.of(context).primaryColor
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              LargeButton(
                label: isLast ? '홈으로 가기' : '다음',
                icon: isLast ? Icons.play_arrow : Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (isLast) {
                    widget.onDone();
                  } else {
                    setState(() => _page += 1);
                  }
                },
              ),
              const SizedBox(height: 12),
              LargeButton(
                label: '홈으로 가기',
                icon: Icons.home,
                onPressed: widget.onDone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialItem {
  const _TutorialItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;
}
