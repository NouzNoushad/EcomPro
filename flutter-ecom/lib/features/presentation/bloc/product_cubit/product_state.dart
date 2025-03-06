part of 'product_cubit.dart';

class ProductState extends Equatable {
  const ProductState({
    required this.isStorageLoading,
    required this.products,
  });

  final bool isStorageLoading;
  final List<Product>? products;

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
