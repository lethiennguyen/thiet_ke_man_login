class ProductRequestID {
  final int id;

  ProductRequestID(this.id);
  Map<String, dynamic> toQueryParams() {
    return {'id': id};
  }
}
