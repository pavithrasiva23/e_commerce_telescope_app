import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_a_to_z/customwidgets/radio_group.dart';
import 'package:shop_a_to_z/models/brand_model.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import 'package:shop_a_to_z/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/telescope_model.dart';
import '../utils/widget_functions.dart';

class AddTelescopePage extends StatefulWidget {
  static const String routeName = 'addtelescope';
  const AddTelescopePage({super.key});

  @override
  State<AddTelescopePage> createState() => _AddTelescopePageState();
}

class _AddTelescopePageState extends State<AddTelescopePage> {
  //Declaring the state properties
  final _modelController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _weightController = TextEditingController();
  final _lensDiameterController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BrandModel? brand; //initial value in dropDown list
  String? imgLocalPath;//image capturing or selecting from the gallery will save in this variable
  //DateTime? dateTime; //track of purchase date and adding telescope date to the server [DatePickerDialog]
  ///All below 3 properties with default value is selected for the radio button
  String mountDescription = TelescopeUtils.mountList.first;
  String focusType = TelescopeUtils.focusList.first;
  String telescopeType = TelescopeUtils.typeList.first;

  @override
  void dispose() {
    _modelController.dispose();
    _dimensionController.dispose();
    _weightController.dispose();
    _lensDiameterController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Telescope'),
        actions: [
          IconButton(onPressed: _saveTelescope, icon: Icon(Icons.save))
        ],
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              //1)Image
              Card(
              child: Column(
                children: [
                  imgLocalPath == null ? const Icon(Icons.photo, size: 100,) : Image.file(File(imgLocalPath!), width: 100, height: 100, fit: BoxFit.cover,),
                  const Text('Select Telescope Image \nfrom', textAlign: TextAlign.center),
                  //Capture and Select from gallery
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(onPressed: ()=> getImage(ImageSource.camera), label: Text('Camera'), icon: Icon(Icons.camera)),
                      TextButton.icon(onPressed: ()=> getImage(ImageSource.gallery), label: Text('Gallery'), icon: Icon(Icons.browse_gallery)),
                    ],
                  )
                ],
              ),
            ),
              //2)Brand
              Card(
                child: Padding(padding: const EdgeInsets.all(8),
                child: Consumer<TelescopeProvider>(
                  builder: (context, provider, child)=> 
                      //Validate : whether admin selected brand or not
                      DropdownButtonFormField<BrandModel>(
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                          items: provider.brandList.map((item)=> 
                              DropdownMenuItem<BrandModel>(
                                  value: item,
                                  child: Text(item.name))).toList(),
                          hint: Text('Select Brand'),
                          isExpanded: true,
                          initialValue: brand,
                          validator: (value){
                          if(value == null) {
                            return 'Please select a brand';
                          }
                          return null;
                          },
                          onChanged: (value){
                          //selected brand will assign to the 'brand'
                            brand = value;
                          })
                ),
                )),
              //3)Radio Groups:
              RadioItem(
                  groupValue: telescopeType,
                  label: 'Select Telescope Type',
                  items: TelescopeUtils.typeList,
                  onItemSelected: (item){
                    telescopeType = item;
                  }),
              RadioItem(
                  groupValue: mountDescription,
                  label: 'Select Mount Type',
                  items: TelescopeUtils.mountList,
                  onItemSelected: (item){
                    mountDescription = item;
                  }),
              RadioItem(
                  groupValue: focusType,
                  label: 'Select Focus Type',
                  items: TelescopeUtils.focusList,
                  onItemSelected: (item){
                    focusType = item;
                  }),
              //4)Build Text fields
              Padding(padding: const EdgeInsets.all(4),
              child: TextFormField(
                controller: _modelController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  labelText: 'Model'
                ),
                validator: (val){
                  if(val == null || val.isEmpty){
                    return 'This field must not be empty';
                  } return null;
                },
              ),
              ),
              Padding(padding: const EdgeInsets.all(4),
                child: TextFormField(
                  controller: _dimensionController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      labelText: 'Dimension'
                  ),
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return 'This field must not be empty';
                    } return null;
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(4),
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      labelText: 'Weight(lbs)'
                  ),
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return 'This field must not be empty';
                    } return null;
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(4),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _lensDiameterController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      labelText: 'Lens Diameter(mm)'
                  ),
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return 'This field must not be empty';
                    } return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      labelText: 'Price'
                  ),
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return 'This field must not be empty';
                    }
                    else if(num.parse(val) <= 0){
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _stockController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      labelText: 'Stock'
                  ),
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return 'This field must not be empty';
                    }
                    else if(num.parse(val) <= 0){
                      return 'Quantity should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ))
    );
  }

//get image
void getImage(ImageSource source) async {
    final file =

    await ImagePicker().pickImage(source: source, imageQuality: 50);
    if(file != null){
      setState(() {
        imgLocalPath = file.path;
      });
    }
}

//Save the new telescope
void _saveTelescope() async {
    if(imgLocalPath == null){
      Utils.showMsg(context, 'Please select a telescope image');
      return;
    }
    if(_formKey.currentState!.validate()){
      EasyLoading.show(status: 'Please wait...');
      try{
        final imageModel = await Provider.of<TelescopeProvider>(context, listen: false).uploadImages(imgLocalPath!);
        //Create telescope model
        final telescopeModel = TelescopeModel(
          model: _modelController.text,
          brand: brand!,
          type: telescopeType,
          dimension: _dimensionController.text,
          weightInPound: num.parse(_weightController.text),
          mountDescription: mountDescription,
          price: num.parse(_priceController.text),
          stock: num.parse(_stockController.text),
          thumbnail: imageModel,
          additionalImage: [], focusType: focusType, lensDiameterInMM: -num.parse(_lensDiameterController.text)
        );
        await Provider.of<TelescopeProvider>(context, listen: false).addTelescope(telescopeModel);
        EasyLoading.dismiss();
        Utils.showMsg(context, 'Saved Telescope');
        //reset all  fields
        _resetTelescopeFields();
      }
      catch(error){
        EasyLoading.dismiss();
        print(error.toString());

      }
    }
}

  void _resetTelescopeFields() {
    setState(() {
      _modelController.clear();
      _dimensionController.clear();
      _weightController.clear();
      _lensDiameterController.clear();
      _stockController.clear();
      _priceController.clear();
      // dateTime = null;
      brand = null;
      imgLocalPath = null;
      mountDescription = TelescopeUtils.mountList.first;
      focusType = TelescopeUtils.focusList.first;
      telescopeType = TelescopeUtils.typeList.first;
    });
  }
}
