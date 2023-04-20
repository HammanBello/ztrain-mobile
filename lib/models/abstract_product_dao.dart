import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';

abstract class AbsProductDAO {
  Future<List<Product>> getAllProduct();
  Future<List<Cart>> getProductForCart();
  Future<Product> getProductById(String id);
  Future<Product> setProductFavorite();
  Future<void> addToCartd(String productId, int quantity, double price);
  Future<void> deletedFromCard(String cartId);
  Future<void> setIsFavorite(String productId);
  getCartStream();
  getFavProdStream();
}
