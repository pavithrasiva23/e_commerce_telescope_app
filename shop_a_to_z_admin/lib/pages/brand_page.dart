import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z/utils/widget_functions.dart';

class BrandPage extends StatelessWidget {
  static const String routeName = 'brand';
  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Brands"),
      ),
      body: Consumer<TelescopeProvider>(
        builder: (context,provider, child) => provider.brandList.isEmpty ? Center(
          child: Text('No brands found')
        ):ListView.builder(
            itemCount: provider.brandList.length,
            itemBuilder: (context, index){
              final brand = provider.brandList[index];
              return ListTile(
                title: Text(brand.name),
              );
            })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        Utils.showSingleTextInputDialog(context: context, title: 'Add Brand', onSubmit: (value){
          EasyLoading.show(status: 'Please Wait...');
          Provider.of<TelescopeProvider>(context, listen: false).addBrand(value).then((value){
            EasyLoading.dismiss();
            Utils.showMsg(context, 'Brand Added');
          });
        });
      },

      child: Icon(Icons.add),),
      );
  }
}
