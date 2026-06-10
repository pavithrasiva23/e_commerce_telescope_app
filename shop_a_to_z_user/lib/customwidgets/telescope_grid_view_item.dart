import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_a_to_z_user/models/telescope_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_a_to_z_user/pages/telescope_details_page.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class TelescopeGridItemView extends StatelessWidget {
  final TelescopeModel telescope;
  const TelescopeGridItemView({super.key, required this.telescope});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.goNamed(TelescopeDetailsPage.routeName, extra: telescope.id);
      },
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                //1) Product Image
                Expanded(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                      imageUrl: telescope.thumbnail.downloadUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    errorWidget: (context, url, error)=> const Icon(Icons.error),
                  ),
                ),
                //2) Model Name
                Text(telescope.model,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  overflow: TextOverflow.ellipsis
                ),
                ),
                //3) Discount Price
                if(telescope.discount > 0)
                  Padding(
                      padding: EdgeInsets.all(4.0),
                      child: RichText(
                          text: TextSpan(
                            text: '$currencySymbol${Utils.priceAfterDiscount(telescope.price, telescope.discount)}',
                            style: const TextStyle(
                              fontSize: 20, color: Colors.black
                            ),
                            children: [
                              TextSpan(
                                text: '$currencySymbol${telescope.price}',
                                style: const TextStyle(
                                  fontSize: 16, color: Colors.grey,
                                  decoration: TextDecoration.lineThrough
                                )
                              )
                            ]
                          )),
                  ),
                //4)Price If discount is 0
                if(telescope.discount == 0)
                  Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('$currencySymbol${telescope.price}',
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                  ),
                //5) Product Rating
                Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(telescope.avgRating.toStringAsFixed(1)),
                        const SizedBox(width: 5,),
                        RatingBar.builder(
                          initialRating: telescope.avgRating.toDouble(),
                            minRating: 0.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true, //user cannot interact with rating bar
                            itemSize: 20,
                            itemCount: 5,
                            itemPadding: const EdgeInsetsGeometry.symmetric(horizontal: 0.0),
                            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber,),
                            onRatingUpdate: (rating){
                            })
                      ],
                    ),
                )
              ],
            ),
            //6) Discount Offer View
            if(telescope.discount > 0)
              Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '${telescope.discount}% OFF',
                      style: const TextStyle(
                        fontSize: 20, color: Colors.white
                      ),
                    ),

                  ))
          ],
        ),
      ),
    );
  }
}
