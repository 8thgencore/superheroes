import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Stack(
      children: [
        MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: "Next state",
            onTap: () => bloc.nextState(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
          child: SearchWidget(),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() => print("Controller: ${controller.text}"));
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return TextField(
      controller: controller,
      onChanged: (text) => bloc.updateText(text),
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: SuperheroesColors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        isDense: true,
        prefixIcon: Icon(Icons.search, color: Colors.white54, size: 24),
        suffix: GestureDetector(
          onTap: () => controller.clear(),
          child: Icon(Icons.clear, color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white24),
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.minSymbols:
            return MinSymbolsWidget();
          case MainPageState.favorites:
            return FavoritesWidget();
          case MainPageState.searchResults:
            return SearchResultsWidget();
          case MainPageState.noFavorites:
            return NoFavoritesWidget();
          case MainPageState.nothingFound:
            return NothingFoundWidget();
          case MainPageState.loadingError:
            return LoadingErrorWidget();
          default:
            return Center(
              child: Text(
                state.toString(),
                style: TextStyle(color: Colors.white),
              ),
            );
        }
      },
    );
  }
}

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: "Error happened",
      subtitle: "Please, try again",
      buttonText: "Retry",
      assetImage: SuperheroesImages.superman,
      imageHeight: 106,
      imageWidth: 126,
      imageTopPadding: 22,
    );
  }
}

class NoFavoritesWidget extends StatelessWidget {
  const NoFavoritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: "No favorites yet",
      subtitle: "Search and add",
      buttonText: "Search",
      assetImage: SuperheroesImages.ironman,
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
    );
  }
}

class NothingFoundWidget extends StatelessWidget {
  const NothingFoundWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: "Nothing found",
      subtitle: "Search for something else",
      buttonText: "Search",
      assetImage: SuperheroesImages.hulk,
      imageHeight: 112,
      imageWidth: 84,
      imageTopPadding: 16,
    );
  }
}

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Search results",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Venom',
            realName: 'Eddie Brock',
            imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Your favorites",
            style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SuperheroPage(name: 'Batman'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Ironman',
            realName: 'Tony Stark',
            imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SuperheroPage(name: 'Ironman'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MinSymbolsWidget extends StatelessWidget {
  const MinSymbolsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: Text(
          "Enter at least 3 symbols",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          // color: SuperheroesColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
