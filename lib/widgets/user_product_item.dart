import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/dialogs/sure_dialog.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {

  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: id
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                try {
                  // TODO this is not working with sure dialog Fix it
                  showDialog(context: context, builder: (ctx) =>
                      SureDialog(() async {
                        print('dialog block before delete');
                        await Provider.of<ProductProvider>(
                            context, listen: false)
                            .deleteProduct(id);
                        print('dialog block after delete');
                      }
                      ));
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Deleting failed!', textAlign: TextAlign.center,),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
