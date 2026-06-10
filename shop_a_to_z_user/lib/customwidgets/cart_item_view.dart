import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_a_to_z_user/models/cart_model.dart';
import 'package:shop_a_to_z_user/providers/cart_provider.dart';
import 'package:shop_a_to_z_user/utils/constants.dart';

class CartItemView extends StatelessWidget {
  final CartModel cartModel;
  final CartProvider provider;
  const CartItemView({super.key, required this.cartModel, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              //1) Item details
              ListTile(
                leading: CachedNetworkImage(
                    imageUrl: cartModel.imgUrl,
                    width: 70,
                    height: 70,
                    placeholder: (context, url)=> const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error)=> const Icon(Icons.error)
                ),
                title: Text(cartModel.telescopeModel),
                subtitle: Text('Unit Price: $currencySymbol${cartModel.price}'),
                trailing: IconButton(onPressed: (){
                  provider.removeFromCart(cartModel.telescopeId);
                }, icon: Icon(Icons.delete)),
              ),
              //2) Quantity Counter
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        provider.decreaseQuantity(cartModel);
                      },
                      icon: Icon(Icons.remove_circle)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('${cartModel.quantity}',
                      style: Theme.of(context).textTheme.titleLarge,
                      ),
                  ),

                  IconButton(
                      onPressed: (){
                        provider.increaseQuantity(cartModel);
                      },
                      icon: Icon(Icons.add_circle)),
                  const Spacer(),
                  Text('$currencySymbol${provider.priceWithQuantity(cartModel)}', style: Theme.of(context).textTheme.titleLarge,)
                ],
              )
            ],
          ),
      ),
    );
  }
}
