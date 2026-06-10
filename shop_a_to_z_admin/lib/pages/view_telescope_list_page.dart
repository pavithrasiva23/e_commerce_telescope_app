import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_a_to_z/pages/telescope_detailed_page.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewTelescopeListPage extends StatefulWidget {
  static const String routeName = 'viewtelescopes';
  const ViewTelescopeListPage({super.key});

  @override
  State<ViewTelescopeListPage> createState() => _ViewTelescopeListPageState();
}

class _ViewTelescopeListPageState extends State<ViewTelescopeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telescopes'),
      ),
      body: Consumer<TelescopeProvider>(
        builder: (context, provider, child)=> ListView.builder(
            itemCount: provider.telescopeList.length,
            itemBuilder: (context, index){
              final item = provider.telescopeList[index];
              return InkWell(
                onTap: (){
                  context.goNamed(TelescopeDetailedPage.routeName, extra: item.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            imageUrl: item.thumbnail.downloadUrl,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => const Icon(Icons.error)
                        ),
                        Expanded(
                            child: Padding(padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.brand.name, style: Theme.of(context).textTheme.titleMedium),
                                Text(item.model, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis),


                              ],
                            ),
                            ))

                      ],
                    ),
                  ),
                ),
              );
            })
      )
    );
  }
}
