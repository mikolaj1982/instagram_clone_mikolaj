import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/post_comments/post_comments_view.dart';
import 'package:instagram_clone_mikolaj/views/tabs/search/search_grid_view.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');

    useEffect(() {
      controller.addListener(() {
        searchTerm.value = controller.text;
      });

      return () {};
    }, [controller]);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: Strings.enterYourSearchTermHere,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    dismissKeyboard();
                  },
                ),
              ),
            ),
          ),
        ),
        SearchGridView(
          searchTerm: searchTerm.value,
        ),
      ],
    );
  }
}

typedef SearchTerm = String;
