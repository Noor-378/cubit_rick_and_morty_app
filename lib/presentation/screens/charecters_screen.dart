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
  late final ScrollController _scrollController;
  List<Character> searchedForCharacter = [];
  bool _isSearching = false;
  List<Character>? allCharacters;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<CharectersCubit>(context).fetchCharacters();

    _scrollController =
        ScrollController()..addListener(() {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300) {
            BlocProvider.of<CharectersCubit>(context).fetchCharacters();
          }
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        centerTitle: true,

        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: BlocBuilder<CharectersCubit, CharectersState>(
        builder: (context, state) {
          if (state is CharectersLoading && state.isFirstFetch) {
            return showLoadingIndicator();
          }

          if (state is CharectersLoaded || state is CharectersLoading) {
            allCharacters =
                state is CharectersLoaded
                    ? state.characters
                    : (state as CharectersLoading).oldCharacters;

            final hasMore =
                state is CharectersLoaded ? state.hasNextPage : true;

            return buildCharactersGrid(allCharacters ?? [], hasMore);
          }

          if (state is CharectersError) {
            return Center(child: Text(state.message));
          }

          return showLoadingIndicator();
        },
      ),
    );
  }

  Widget buildCharactersGrid(List<Character> characters, bool hasMore) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount:
          _searchTextController.text.isNotEmpty
              ? searchedForCharacter.length
              : characters.length + (hasMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4.5,
      ),
      itemBuilder: (context, index) {
        if (index < characters.length) {
          return CharacterItem(
            character:
                _searchTextController.text.isNotEmpty
                    ? searchedForCharacter[index]
                    : characters[index],
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: MyColors.myYellow,
                strokeWidth: 2,
              ),
            ),
          );
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: MyColors.myYellow),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        hintText: "Find a character...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
      style: const TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemToSearchedList(String searchedCharacter) {
    searchedForCharacter =
        allCharacters!
            .where(
              (element) =>
                  element.name.toLowerCase().startsWith(searchedCharacter),
            )
            .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = false;
            });
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: MyColors.myGrey),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(Icons.search, color: MyColors.myGrey),
        ),
      ];
    }
  }

  void _startSearch() {
    // like we enter a new route so flutter put a back button
    ModalRoute.of(
      context,
    )!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey, fontWeight: FontWeight.bold),
    );
  }
}
