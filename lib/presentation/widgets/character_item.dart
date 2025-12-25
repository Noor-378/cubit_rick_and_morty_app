import 'package:cubit_rick_and_morty_app/constants/my_colors.dart';
import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';
import 'package:cubit_rick_and_morty_app/presentation/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  const CharacterItem({super.key, required this.character});
  final Character? character;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: MyColors.myYellow.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridTile(
        footer: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black45],
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          alignment: Alignment.bottomCenter,
          child: Text(
            character?.name ?? "",
            style: const TextStyle(
              height: 1.3,
              fontSize: 16,
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        child: Container(
          color: MyColors.myGrey,
          // or FadeInImage.assetNetwork : put a placeholder till the image load
          child: CustomImage(image: character?.image ?? ""),
        ),
      ),
    );
  }
}
