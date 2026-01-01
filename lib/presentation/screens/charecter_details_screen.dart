import '../../constants/my_colors.dart';
import '../../data/models/charecters.dart';
import '../widgets/custom_image.dart';
import 'package:flutter/material.dart';

class CharecterDetailsScreen extends StatelessWidget {
  const CharecterDetailsScreen({super.key, required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Character Info"),
                  const SizedBox(height: 16),
                  _infoCard([
                    _infoRow(
                      "Status",
                      character.status,
                      color: _statusColor(character.status),
                      icon: Icons.circle,
                    ),
                    _infoRow("Species", character.species, icon: Icons.pets),
                    _infoRow("Gender", character.gender, icon: Icons.person),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle("Location Details"),
                  const SizedBox(height: 16),
                  _infoCard([
                    _infoRow(
                      "Origin",
                      character.origin.name,
                      icon: Icons.public,
                    ),
                    _infoRow(
                      "Current Location",
                      character.location.name,
                      icon: Icons.location_on,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle("Appearances"),
                  const SizedBox(height: 16),
                  _infoCard([
                    _infoRow(
                      "Episodes",
                      "${character.episode.length} episodes",
                      icon: Icons.tv,
                    ),
                  ]),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 500,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        title: Text(
          character.name,
          style: const TextStyle(
            color: MyColors.myWhite,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CustomImage(
              image: character.image,
              heroTag: character.id.toString(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    MyColors.myGrey.withValues(alpha: .01),
                    MyColors.myGrey.withValues(alpha: .01),
                    MyColors.myGrey.withValues(alpha: .01),
                    MyColors.myGrey.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    const TextStyle titleStyle = TextStyle(
      color: MyColors.myYellow,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: title, style: titleStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final double titleWidth = textPainter.size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: titleWidth - 12,
              height: 3,
              decoration: BoxDecoration(
                color: MyColors.myYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 5,
              height: 3,
              decoration: BoxDecoration(
                color: MyColors.myYellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.myGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.myYellow.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String title, String value, {Color? color, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: color ?? MyColors.myYellow, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: MyColors.myWhite.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color ?? MyColors.myWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "alive":
        return Colors.greenAccent;
      case "dead":
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }
}
