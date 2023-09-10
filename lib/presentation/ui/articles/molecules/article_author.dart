import 'package:flutter/material.dart';
import 'package:real_world_flutter/main.dart';
import 'package:real_world_flutter/presentation/ui/common/color/ext_color.dart';

class ArticleAuthor extends StatelessWidget {
  const ArticleAuthor({
    super.key,
    required this.username,
    this.image,
    required this.createdAt,
    this.onTap,
    this.textColor,
  });

  final Uri? image;
  final String username;
  final DateTime createdAt;
  final void Function()? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.main.withLight(0.4),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            _icon(),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _username(context),
                _date(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return SizedBox.square(
      dimension: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          image.toString(),
          fit: BoxFit.contain,
          errorBuilder: (context, _, __) {
            return Container(
              color: AppColors.lightGray,
              child: const Icon(Icons.person, color: AppColors.grey),
            );
          },
        ),
      ),
    );
  }

  Widget _date() {
    return Text(
      createdAt.toString(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w200,
        color: textColor,
      ),
    );
  }

  Widget _username(BuildContext context) {
    return Text(
      username,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
    );
  }
}
