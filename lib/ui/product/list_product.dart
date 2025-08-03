import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ma_so_thue/base/asset/base_asset.dart';
import 'package:ma_so_thue/blocs/product/cart_cubit.dart';
import 'package:ma_so_thue/blocs/product/list_product_cubit.dart';
import 'package:ma_so_thue/blocs/product/list_product_state.dart';
import 'package:ma_so_thue/data/models/product.dart';
import 'package:ma_so_thue/enums/product_type.dart';
import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';
import 'package:ma_so_thue/ui/common/app_colors.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductListScreen();
  }
}

class ProductListScreen extends State<ProductList> {
  Category _category = Category.all;
  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    print('INIT UI: Gọi fetchProducts');
    context.read<ListProductCubit>().loadFirstPage();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 50) {
        context.read<ListProductCubit>().loadMore();
        print('Đã loadmore');
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SvgPicture.asset(Pictures.logo, width: 158, height: 37),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/shopping_cart');
            },
            icon: Image.asset(IconsAssets.shopping_cart),
            tooltip: 'Giỏ hàng',
          ),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Color(0xfffffffe), height: 1),
        ),
      ),

      body: BlocBuilder<ListProductCubit, ListProductState>(
        builder: (context, state) {
          print('UI nhận được: ${state.products.length} sản phẩm');
          if (state.status == ListProductStatus.loading &&
              state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final bool isRefreshing =
              state.status == ListProductStatus.refreshing;
          return _formProductList(
            state.products,
            state.isLoadMore,
            isRefreshing,
          );
        },
      ),
    );
  }

  Widget _formProductList(
    List<Product> products,
    bool isLoadingMore,
    bool isRefreshing,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<ListProductCubit>().pullToRefresh(),
      child: CustomScrollView(
        controller: _scroll,
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Category.values.length,
                itemBuilder: (context, index) {
                  final category = Category.values[index];
                  final selected = category == _category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _category = category),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 20),
                        backgroundColor: selected ? kBrandOrange : Colors.white,
                        foregroundColor: selected ? Colors.white : Colors.black,
                        side: BorderSide(
                          color: selected ? kBrandOrange : Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(category.label),
                    ),
                  );
                },
              ),
            ),
          ),
          if (isRefreshing)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductItem(products: products[index]),
                childCount: products.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 3 / 4.5,
              ),
            ),
          ),
          // -------- LOADER ĐÁY --------
          if (isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget ProductItem({required Product products}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/thongtinsanpham',
          arguments: products.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: textGray, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                products.cover,
                fit: BoxFit.cover,
                height: 180,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Text(
                      products.name,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      bottom: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currencyFormatter.format(products.price)} VNĐ',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CartCubit>().addToCart(
                              CartItem(
                                id: products.id!,
                                name: products.name,
                                price: products.price,
                                quantity: 1,
                                cover: products.cover,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kBrandOrange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
