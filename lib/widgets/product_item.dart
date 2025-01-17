import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName, arguments: product.id,);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            // eğer child olsaydı değişmesi gereken _ yerine child parametresi olurdu
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: themeOf.accentColor,
              ),
              onPressed: () {
                product.toggleFavoriteStatus();
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: product.isFavorite
                      ? Text('${product.title} added to Favorites!')
                      : Text('${product.title} removed from Favorites!'),
                  behavior: SnackBarBehavior.floating,
                  elevation: 4,
                  duration: Duration(
                    milliseconds: 500
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                  ),
                ));
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: themeOf.accentColor,
            ),
            onPressed: () {
              cart.addItemToCart(product.id, product.title, product.price);
              // Üst üste ürün eklerken altta sürekli snackbar çıkmasın diye,
              // eğer o anda zaten bi snackbar varsa onu otomatik gizleyecek
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${product.title} added to Cart!'),
                behavior: SnackBarBehavior.floating,
                elevation: 4,
                duration: Duration(
                  milliseconds: 800
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleIem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
