import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z/models/image_dto.dart';
import 'package:shop_a_to_z/models/telescope_model.dart';
import 'package:shop_a_to_z/pages/description_page.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import 'package:shop_a_to_z/utils/constants.dart';
import 'package:shop_a_to_z/utils/helper_functions.dart';

import '../customwidgets/image_holder_view.dart';
import '../utils/widget_functions.dart';

class TelescopeDetailedPage extends StatefulWidget {
  static const String routeName = 'telescopedetails';
  final String telescopeId;
  const TelescopeDetailedPage({super.key, required this.telescopeId});

  @override
  State<TelescopeDetailedPage> createState() => _TelescopeDetailedPageState();
}

class _TelescopeDetailedPageState extends State<TelescopeDetailedPage> {
  late TelescopeModel telescope;
  late TelescopeProvider provider;
  @override
  void didChangeDependencies() {
    provider = Provider.of<TelescopeProvider>(context);
    telescope = provider.findTelescopeById(widget.telescopeId);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(telescope.model, style:const TextStyle(overflow: TextOverflow.ellipsis)),
      ),
      body: ListView(
        children: [
          //1) Uploaded thumbnail image
          CachedNetworkImage(
            imageUrl: telescope.thumbnail.downloadUrl,
            width: double.infinity,
            height: 200,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          //2) Add additional images
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Card(
              child: ListView(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                children: [
                  FloatingActionButton.small(onPressed: (){
                    getImage(ImageSource.gallery);
                  },
                  tooltip: 'Add additional image',
                   child: const Icon(Icons.add),  
                  ),
                  if(telescope.additionalImage.isEmpty)
                    Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Center(
                          child: Text('Add Other Images',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),  
                          ),
                        ),
                    ),
                  ...telescope.additionalImage.map((e)=> ImageHolderView(
                  imageModel: e, onImagePressed: () {
                    _showImageOnDialog(e);
                  },
                  )),
                ],
              ),
            ),
          ),
          //3) Description - to add
          ElevatedButton(onPressed: (){
            telescope.description == null ?
                context.goNamed(DescriptionPage.routeName, extra: telescope.id) :
                _showDescriptionDialog();
          },
              child: Text(telescope.description == null ? 'Add Description': 'Show Description')),
          //4) Show Telescope Information
          ListTile(
            title: Text(telescope.brand.name),
            subtitle: Text(telescope.model),
          ),
          //Other information with edit option:
          ListTile(
            title: Text('Sale Price (with discount): $currencySymbol${Helpers.priceAfterDiscount(telescope.price, telescope.discount).toStringAsFixed(0)}'),
            subtitle: Text('Original Price: $currencySymbol${telescope.price}'),
            trailing: IconButton(onPressed: ()=> Utils.showSingleTextInputDialog(
                context: context,
                title: 'Edit Price',
                onSubmit: (value){
                  EasyLoading.show(status: 'Please Wait...');
                  provider.updateTelescopeField(telescope.id!, 'price', num.parse(value)).then((value){
                    EasyLoading.dismiss();
                    Utils.showMsg(context, 'Price Updated');
                  });
                }),
                icon: Icon(Icons.edit)),
          ),
          ListTile(
            title: Text('Discount: ${telescope.discount}%'),
            trailing: IconButton(onPressed: ()=> Utils.showSingleTextInputDialog(
                context: context,
                title: 'Edit Discount',
                onSubmit: (value){
                  EasyLoading.show(status: 'Please Wait...');
                  provider.updateTelescopeField(telescope.id!, 'discount', num.parse(value)).then((value){
                    EasyLoading.dismiss();
                    Utils.showMsg(context, 'Discount Updated');
                  });
                }),
                icon: Icon(Icons.edit)),
          ),
          ListTile(
            title: Text('Stock: ${telescope.stock}'),
            trailing: IconButton(onPressed: ()=> Utils.showSingleTextInputDialog(
                context: context,
                title: 'Edit Stock',
                onSubmit: (value){
                  EasyLoading.show(status: 'Please Wait...');
                  provider.updateTelescopeField(telescope.id!, 'stock', num.parse(value)).then((value){
                    EasyLoading.dismiss();
                    Utils.showMsg(context, 'Stock Updated');
                  });
                }),
                icon: Icon(Icons.edit)),
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if(file != null){
      EasyLoading.show(status: 'Please wait...');
      //Upload the images to firestore
      final newImage = await provider.uploadImages(file.path); //returns new image model
      telescope.additionalImage.add(newImage);
      //To update the telescope fields - add additional images to existing list
      provider.updateTelescopeField(
          telescope.id!,
          'additionalImage',
          Helpers.toImageMapList(telescope.additionalImage))
          .then((value){
            EasyLoading.dismiss();
            Utils.showMsg(context, 'Images Added');
            setState(() {

            });
      })
          .catchError((error) {
            EasyLoading.dismiss();
            Utils.showMsg(context, 'Failed to add');

      });
    }

  }

void _showImageOnDialog(ImageDTO imageModel) {
   showDialog(context: context, builder: (innerCtx)=>
       AlertDialog(
          content: CachedNetworkImage(
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height / 2,
              imageUrl: imageModel.downloadUrl,
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
         actions: [
           TextButton(
               onPressed: ()=>   Navigator.pop(innerCtx),
               child: Text('CLOSE')),
           TextButton(
               onPressed: () async {
                 Navigator.pop(innerCtx);
                 EasyLoading.show(status: 'Please Wait...');
                 try {
                   //Commented this deleteImage() method because we don't have access in "Firebase - Storage"
                 //  await provider.deleteImage(telescope.id!, imageModel);
                   //Remove from the list and update the additionalImage list in database using 'updateTelescopeField'
                   telescope.additionalImage.remove(imageModel);
                   await provider.updateTelescopeField(
                       telescope.id!,
                       'additionalImage',
                       Helpers.toImageMapList(telescope.additionalImage));
                   EasyLoading.dismiss();
                   setState(() {
                   // to rebuild the widget with updated changes
                   });

                 } catch(error){
                   EasyLoading.dismiss();

                 }
               },
               child: Text('DELETE'))
         ],
       ));
}

  _showDescriptionDialog() {
    showDialog(
        context: context, builder: (innerCtx)=> AlertDialog(
        title: Text(telescope.model),
        content: SingleChildScrollView(
          child: Text(telescope.description!),
        ),
        actions: [
          TextButton(
              onPressed: (){
                innerCtx.pop();
                context.goNamed(DescriptionPage.routeName, extra: telescope.id!);
              },
              child: Text('Edit')),
          TextButton(
              onPressed: (){
                innerCtx.pop();
              },
              child: Text('Close'))
        ],
    ));
  }
}
