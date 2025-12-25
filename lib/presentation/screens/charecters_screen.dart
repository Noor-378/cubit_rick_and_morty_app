import 'dart:developer';

import 'package:cubit_rick_and_morty_app/business_logic/cubit/charecters_cubit.dart';
import 'package:cubit_rick_and_morty_app/constants/my_colors.dart';
import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';
import 'package:cubit_rick_and_morty_app/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharectersScreen extends StatefulWidget {
  const CharectersScreen({super.key});

  @override
  State<CharectersScreen> createState() => _CharectersScreenState();
}

class _CharectersScreenState extends State<CharectersScreen> {
  List<Character>? allCharacters;

  @override
  void initState() {
    super.initState();
    // Get.find
    allCharacters =
        BlocProvider.of<CharectersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text(
          "Characters",
          style: TextStyle(color: MyColors.myGrey),
        ),
      ),
      body: buildBlocWidget(),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharectersCubit, CharectersState>(
      builder: (context, state) {
        if (state is CharectersLoaded) {
          allCharacters = state.characters;

          return buildLoadedListWidgets();
        } else {
          return showLoadingIndecator();
        }
      },
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(children: [buildCharactersList()]),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: allCharacters?.length,
      itemBuilder: (context, index) {
        return CharacterItem(character: allCharacters![index]);
      },
    );
  }

  Widget showLoadingIndecator() {
    return const Center(
      child: CircularProgressIndicator(color: MyColors.myYellow),
    );
  }
}
