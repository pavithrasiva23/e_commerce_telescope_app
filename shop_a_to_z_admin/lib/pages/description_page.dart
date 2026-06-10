import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import '../utils/constants.dart';
import '../utils/widget_functions.dart';

class DescriptionPage extends StatefulWidget {
  static const String routeName = 'description';
  final String telescopeId;
  const DescriptionPage({super.key, required this.telescopeId});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final _descripCtrller = TextEditingController();
  String? description; //initially description is null

  // @override
  // void initState() {
  //  _descripCtrller.text = descriptionValue;
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    //To edit the description if already have:
    description = Provider.of<TelescopeProvider>(context, listen: false).findTelescopeById(widget.telescopeId).description;
    if(description != null){
      _descripCtrller.text = description!;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descripCtrller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
        actions: [
          IconButton(onPressed: _saveDescription, icon: const Icon(Icons.save)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.grey,
        height: double.infinity,
        child: TextField(
          controller: _descripCtrller,
          maxLines: 1000,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder()
          ),
        ),
      ),
    );
  }

  void _saveDescription() {
    if(_descripCtrller.text.isEmpty)  {
      Utils.showMsg(context, 'Field is empty');
      return;
    }
    EasyLoading.show(status: 'Please Wait...');
    Provider.of<TelescopeProvider>(context, listen: false)
        .updateTelescopeField(
        widget.telescopeId,
        'description',
        _descripCtrller.text).then((value){
          Utils.showMsg(context, 'Description Updated');
          context.pop();
          EasyLoading.dismiss();
    })
        .catchError((error){
          EasyLoading.dismiss();
    });
  }
}
