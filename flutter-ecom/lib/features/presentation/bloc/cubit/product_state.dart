part of 'product_cubit.dart';

class ProductState extends Equatable {
  const ProductState({
    required bool isStorageLoading,
    required List<Product>? products,
  })  : _isStorageLoading = isStorageLoading,
        _products = products;

  final bool _isStorageLoading;
  final List<Product>? _products;

  bool get isStorageLoading => _isStorageLoading;
  List<Product>? get products => _products;

  ProductState copyWith({
    bool? isStorageLoading,
    List<Product>? products,
  }) {
    return ProductState(
        isStorageLoading: isStorageLoading ?? this.isStorageLoading,
        products: products ?? this.products);
  }

  @override
  List<Object> get props => [isStorageLoading];
}
