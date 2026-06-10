import 'package:flutter/foundation.dart';
import 'package:shop_a_to_z_user/auth/auth_service.dart';
import 'package:shop_a_to_z_user/db/db_helper.dart';
import 'package:shop_a_to_z_user/models/cart_model.dart';
import 'package:shop_a_to_z_user/models/telescope_model.dart';
import 'package:shop_a_to_z_user/utils/helper_functions.dart';

class CartProvider with ChangeNotifier{
  List<CartModel> cartList = [];
  int get totalItemsInCart => cartList.length;

  //4)Get All Cart Items
  getAllCartItems() {
    DbHelper.getAllCartItems(AuthService.currentUser!.uid).listen((snapshot){
      cartList = List.generate(snapshot.docs.length, (index)=> CartModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  //1)Is Product is in the cartList or not check
   bool isTelescopeInCart(String prodId){
     bool tag = false;
     for(final cartModel in cartList){
       if(cartModel.telescopeId == prodId){
         tag = true;
         break;
       }
     }
     return tag;
   }

  //2) Add to Cart
   Future<void> addToCart(TelescopeModel telescope){
     final cartModel = CartModel(
         telescopeId: telescope.id!,
         telescopeModel: telescope.model,
         price: Utils.priceAfterDiscount(telescope.price, telescope.discount),
         imgUrl: telescope.thumbnail.downloadUrl);
     return DbHelper.addToCart(cartModel, AuthService.currentUser!.uid);
   }

   //3) Remove from cart
   Future<void> removeFromCart(String telescopeId){
     return DbHelper.removeFromCart(telescopeId, AuthService.currentUser!.uid);
   }

   //5) Increase the cart item quantity
  void increaseQuantity(CartModel model){
    model.quantity += 1;
    DbHelper.updateCartQty(AuthService.currentUser!.uid, model);
  }

  //6) Decrease the cart item quantity
  void decreaseQuantity(CartModel model){
    if(model.quantity > 1) {
      model.quantity -= 1;
      DbHelper.updateCartQty(AuthService.currentUser!.uid, model);
    }
  }

  //7) Price * Quantity
  num priceWithQuantity(CartModel model) => model.price * model.quantity;

  //8) Calculate the sub-total
  num getCartSubTotal(){
    num total = 0;
    for(final model in cartList){
      total+= priceWithQuantity(model);
    }
    return total;
  }

  //9) Clear the cart
  Future<void> clearCart() => DbHelper.clearCart(AuthService.currentUser!.uid, cartList);


}