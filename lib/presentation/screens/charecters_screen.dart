import 'dart:developer';

import 'package:cubit_rick_and_morty_app/business_logic/cubit/charecters_cubit.dart';
import 'package:cubit_rick_and_morty_app/constants/my_colors.dart';
import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';
import 'package:cubit_rick_and_morty_app/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:lottie/lottie.dart';

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
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      appBar: _buildAppBar(),
      body: OfflineBuilder(
        connectivityBuilder: (context, value, child) {
          final bool connected = !value.contains(ConnectivityResult.none);
          log("con $connected");
          if (connected) {
            return BlocBuilder<CharectersCubit, CharectersState>(
              builder: (context, state) {
                if (state is CharectersLoading && state.isFirstFetch) {
                  return _showLoadingIndicator();
                }

                if (state is CharectersLoaded || state is CharectersLoading) {
                  allCharacters =
                      state is CharectersLoaded
                          ? state.characters
                          : (state as CharectersLoading).oldCharacters;

                  final hasMore =
                      state is CharectersLoaded ? state.hasNextPage : true;

                  return _buildBody(allCharacters ?? [], hasMore);
                }

                if (state is CharectersError) {
                  return _buildErrorWidget(state.message);
                }

                return _showLoadingIndicator();
              },
            );
          } else {
            return buildNoInternetWidget(onRetry: () {});
          }
        },
        child: const SizedBox.shrink(),
      ),
    );
  }

  Widget buildNoInternetWidget({VoidCallback? onRetry}) {
    return Container(
      color: MyColors.myYellow.withValues(alpha: 0.25),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 220,
                child: Lottie.asset(
                  "assets/animations/noInternet.json",
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'No Internet Connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.myWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.myWhite.withValues(alpha: 0.6),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.myYellow,
                    foregroundColor: MyColors.myGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 10,
      backgroundColor: MyColors.myGrey,
      title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
      actions: _buildAppBarActions(),
    );
  }

  Widget _buildBody(List<Character> characters, bool hasMore) {
    final displayList =
        _searchTextController.text.isNotEmpty
            ? searchedForCharacter
            : characters;

    if (displayList.isEmpty && _searchTextController.text.isNotEmpty) {
      return _buildEmptySearchResult();
    }

    return Column(
      children: [
        if (_searchTextController.text.isNotEmpty)
          _buildSearchResultsHeader(displayList.length),
        Expanded(child: _buildCharactersGrid(characters, hasMore)),
      ],
    );
  }

  Widget _buildSearchResultsHeader(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: MyColors.myYellow, size: 20),
          const SizedBox(width: 8),
          Text(
            'Found $count result${count != 1 ? 's' : ''}',
            style: TextStyle(
              color: MyColors.myWhite.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: MyColors.myYellow.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No characters found',
            style: TextStyle(
              color: MyColors.myWhite.withValues(alpha: 0.6),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with a different name',
            style: TextStyle(
              color: MyColors.myWhite.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharactersGrid(List<Character> characters, bool hasMore) {
    final displayList =
        _searchTextController.text.isNotEmpty
            ? searchedForCharacter
            : characters;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      itemCount:
          displayList.length +
          (hasMore && _searchTextController.text.isEmpty ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4.5,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        if (index < displayList.length) {
          return CharacterItem(character: displayList[index]);
        } else {
          return _buildLoadingCard();
        }
      },
    );
  }

  Widget _buildLoadingCard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyColors.myGrey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: MyColors.myYellow.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: MyColors.myYellow,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _showLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: MyColors.myYellow,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading characters...',
            style: TextStyle(
              color: MyColors.myWhite.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: MyColors.myWhite.withValues(alpha: 0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.myWhite.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                BlocProvider.of<CharectersCubit>(context).fetchCharacters();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.myYellow,
                foregroundColor: MyColors.myGrey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      autofocus: true,
      cursorColor: MyColors.myYellow,
      decoration: InputDecoration(
        hintText: "Search characters...",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColors.myWhite.withValues(alpha: 0.5),
          fontSize: 18,
        ),
        prefixIcon: const Icon(Icons.search, color: MyColors.myYellow),
      ),
      style: const TextStyle(color: MyColors.myWhite, fontSize: 18),
      onChanged: (searchedCharacter) {
        _addSearchedForItemToSearchedList(searchedCharacter);
      },
    );
  }

  void _addSearchedForItemToSearchedList(String searchedCharacter) {
    searchedForCharacter =
        allCharacters!
            .where(
              (element) => element.name.toLowerCase().contains(
                searchedCharacter.toLowerCase(),
              ),
            )
            .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        if (_searchTextController.text.isNotEmpty)
          IconButton(
            onPressed: () {
              _stopSearching();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: MyColors.myWhite),
            tooltip: 'Close search',
          ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(Icons.search, color: MyColors.myYellow),
          tooltip: 'Search characters',
        ),
      ];
    }
  }

  void _startSearch() {
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
      searchedForCharacter.clear();
    });
  }

  Widget _buildAppBarTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MyColors.myYellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person, color: MyColors.myYellow, size: 24),
        ),
        const SizedBox(width: 12),
        const Text(
          'Characters',
          style: TextStyle(
            color: MyColors.myWhite,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}
