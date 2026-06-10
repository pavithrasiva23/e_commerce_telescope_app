import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z_user/models/telescope_model.dart';
import 'package:shop_a_to_z_user/providers/cart_provider.dart';
import 'package:shop_a_to_z_user/providers/telescope_provider.dart';
import 'package:shop_a_to_z_user/providers/user_provider.dart';
import 'package:shop_a_to_z_user/utils/colors.dart';
import 'package:shop_a_to_z_user/utils/constants.dart';

import '../utils/helper_functions.dart';

class TelescopeDetailsPage extends StatefulWidget {
  static const String routeName = 'productdetails';
  final String prodId;
  const TelescopeDetailsPage({super.key, required this.prodId});

  @override
  State<TelescopeDetailsPage> createState() => _TelescopeDetailsPageState();
}

class _TelescopeDetailsPageState extends State<TelescopeDetailsPage> {
  late TelescopeModel telescopeModel;
  late TelescopeProvider provider;
  double userRating = 0.0;
  
  @override
  void didChangeDependencies() {
    provider = Provider.of<TelescopeProvider>(context);
    telescopeModel = provider.findTelescopeById(widget.prodId);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(telescopeModel.model,
        style: TextStyle(
          overflow: TextOverflow.ellipsis
        ),
        ),
      ),
      body: ListView(
        children: [
          //1) Product Image
          CachedNetworkImage(
              imageUrl: telescopeModel.thumbnail.downloadUrl,
              width: double.infinity,
              height: 200,
              placeholder: (context, url)=> const Center(child: const CircularProgressIndicator(),),
              errorWidget: (context, url, error)=> const Icon(Icons.error),
          ),
          //2) Add to cart / Remove from cart button
          Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 30),
              child: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  final isInCart = provider.isTelescopeInCart(telescopeModel.id!);
                  return ElevatedButton.icon(
                      onPressed: (){
                        if(isInCart){
                          provider.removeFromCart(telescopeModel.id!);
                        }
                        else {
                          provider.addToCart(telescopeModel);
                        }
                      },
                      icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.shopping_cart),
                      label: Text(isInCart ? 'Remove from Cart' : 'Add to Cart',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ), // If selected product is inside the cart then show text as "Remove Product" orelse "Add to Cart"
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? kShrineBrown900 : kShrinePink400,
                        foregroundColor: isInCart ? kShrinePink100 : kShrineSurfaceWhite
                      ),
                  );
                },
              ),
          ),
          //3) Product discount price and stock left
          ListTile(
            title: Text('Sale Price: $currencySymbol${Utils.priceAfterDiscount(telescopeModel.price, telescopeModel.discount)}'),
            subtitle: Text('Stock: ${telescopeModel.stock}'),
          ),
          //4) Rating
          Card(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RatingBar.builder(
                        initialRating: 0.0,
                        minRating: 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, index)=> Icon(Icons.star, color: Colors.amber,),
                        onRatingUpdate: (value){
                          userRating = value;
                        }),
                    OutlinedButton(onPressed: _rateThisProduct, child: const Text('SUBMIT'))
                  ],
                ),
            ),
          ),
        ],
      ),
    );
  }

void _rateThisProduct() async {
    EasyLoading.show(status: 'Please Wait...');
    final appUser = Provider.of<UserProvider>(context, listen: false).appUser;
    await provider.addRating(telescopeModel.id!, appUser!,userRating);
    EasyLoading.dismiss();
    Utils.showMsg(context, 'Thanks for your rating');
}
}
