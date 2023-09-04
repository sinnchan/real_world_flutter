import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/data_source/articles_data_source.dart';

class ArticlesList extends HookConsumerWidget {
  final ArticlesDataSource dataSource;

  const ArticlesList({
    super.key,
    required this.dataSource,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = useListenable(dataSource);

    return ListView.builder(
      itemCount: source.itemCount,
      itemBuilder: (context, index) {
        final item = source.getByIndex(index);
        return item.when(
          isLoading: () {
            return const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          data: (data) {
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox.square(
                              dimension: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  data.author.image.toString(),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.author.username,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  data.createdAt.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              data.favoritesCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 6,
                    runSpacing: 6,
                    children: data.tagList.map((e) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Text(
                          e,
                          style: const TextStyle(color: AppColors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  if (source.itemCount != index + 1) const Divider(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
