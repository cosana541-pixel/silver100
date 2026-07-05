import 'package:flutter/material.dart';

import '../state/app_settings_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '설정',
      child: AnimatedBuilder(
        animation: appSettingsStore,
        builder: (context, _) => ListView(
          children: [
            Text('글씨 크기', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              '현재 글씨: ${appSettingsStore.textSizeLabel}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            LargeButton(
              label: '기본 글씨',
              icon: appSettingsStore.textSize == AppTextSize.normal
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: appSettingsStore.textSize == AppTextSize.normal
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () => appSettingsStore.setTextSize(AppTextSize.normal),
            ),
            const SizedBox(height: 12),
            LargeButton(
              label: '글씨 크게',
              icon: appSettingsStore.textSize == AppTextSize.large
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: appSettingsStore.textSize == AppTextSize.large
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () => appSettingsStore.setTextSize(AppTextSize.large),
            ),
            const SizedBox(height: 12),
            LargeButton(
              label: '글씨 아주 크게',
              icon: appSettingsStore.textSize == AppTextSize.veryLarge
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: appSettingsStore.textSize == AppTextSize.veryLarge
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () =>
                  appSettingsStore.setTextSize(AppTextSize.veryLarge),
            ),
            const SizedBox(height: 28),
            Text('쉬운 설명 보기', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            _EasyExplanationSwitch(
              value: appSettingsStore.easyExplanation,
              onChanged: appSettingsStore.setEasyExplanation,
            ),
          ],
        ),
      ),
    );
  }
}

class _EasyExplanationSwitch extends StatelessWidget {
  const _EasyExplanationSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 76),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                Icon(
                  value ? Icons.toggle_on : Icons.toggle_off,
                  size: 54,
                  color: value
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black45,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    value ? '켜짐' : '꺼짐',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
