import 'package:flutter/material.dart';
import '../game/suika_game.dart';
import '../game/constants.dart';

class ProgressionBar extends StatelessWidget {
  final SuikaGame game;

  const ProgressionBar({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Collect all fruit types in order
    final types = FruitType.values;
    
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 8,
      runSpacing: 16,
      children: types.map((type) {
        final isLast = type == types.last;
        
        // Significantly larger multiplier to make size differences very obvious
        final visualSize = type.radius * 90; 

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: visualSize,
              height: visualSize,
              child: _buildItem(context, type),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.black.withOpacity(0.1),
                  size: 14,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildItem(BuildContext context, FruitType type) {
    final theme = game.gameTheme;
    final path = 'assets/images/${type.getSpriteFile(theme)}';
    
    // Check if it's specialized tinted planet
    final tint = type.getSpriteTint(theme);
    
    Widget image = Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to emoji if asset missing (unlikely given instructions but safe)
        return Center(
          child: Text(
            type.getEmoji(theme),
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );

    if (tint != null) {
      image = ColorFiltered(
        colorFilter: ColorFilter.mode(tint, BlendMode.srcATop),
        child: image,
      );
    }

    return image;
  }
}
