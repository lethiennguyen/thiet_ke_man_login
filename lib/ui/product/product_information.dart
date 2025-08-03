import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ma_so_thue/base/asset/base_asset.dart';
import 'package:ma_so_thue/blocs/product/image_cubit.dart';
import 'package:ma_so_thue/blocs/product/list_product_cubit.dart';
import 'package:ma_so_thue/blocs/product/product_detail_cubit.dart';
import 'package:ma_so_thue/blocs/product/product_detail_state.dart';
import 'package:ma_so_thue/data/models/product.dart';
import 'package:ma_so_thue/data/upload_image/image_picker_service.dart';
import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';
import 'package:ma_so_thue/ui/bottomsheet/bottomsheet_updateproduct.dart';
import 'package:ma_so_thue/ui/common/app_colors.dart';
import 'package:ma_so_thue/ui/common/dialog.dart';

class ProductInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormProductInformation();
  }
}

class FormProductInformation extends State<ProductInformation> {
  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');
  bool _hasFetched = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      _hasFetched = true;
      final id = ModalRoute.of(context)!.settings.arguments as int;
      print('Gửi event với id = $id');
      context.read<ProductDetailCubit>().fetchDetailProduct(id: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listener: (context, state) {
        if (state.status == ProductDetailStatus.deleteSuccess) {
          Navigator.pop(context);
        }
      },
      buildWhen: (pre, cur) {
        return pre.product != cur.product;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(),
          body: _buildBody(state),
          bottomNavigationBar: bottomNavigationBar(product: state.product),
        );
      },
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<ListProductCubit>().loadFirstPage();
        },
        icon: Icon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(color: boderAppbar, height: 1),
      ),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/shopping_cart');
          },
          icon: Image.asset(IconsAssets.shopping_cart),
          tooltip: 'Giỏ hàng',
        ),
        SizedBox(width: 8), // Cho icon cách mép phải 1 tí nhìn cho thoáng
      ],
    );
  }

  Widget _buildBody(ProductDetailState state) {
    switch (state.status) {
      case ProductDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ProductDetailStatus.failure:
        return const Center(child: Text('Có lỗi'));

      case ProductDetailStatus.successCache:
      case ProductDetailStatus.success:
      case ProductDetailStatus.successFresh:
        return SingleChildScrollView(
          child: _formProduct(products: state.product!),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _formProduct({required Product products}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: boderAppbar, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffF3F3F3), width: 1),
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(products.cover, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              '${currencyFormatter.format(products.price)} đ',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: informationCart,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6, top: 16),
            child: Text(
              products.name,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 6,
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Số lượng :',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${products.quantity}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SvgPicture.asset(IconsAssets.start),
                      Text(
                        ' 5/5',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
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
    );
  }

  Widget bottomNavigationBar({required Product? product}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 21),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<CartCubit>().addToCart(
                  CartItem(
                    id: product!.id!,
                    name: product!.name,
                    price: product!.price,
                    quantity: 1,
                    cover: product!.cover,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
                );
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(color: Color(0xff29AA98)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(IconsAssets.shopping_cart, color: Colors.white),
                    Text(
                      'Thêm vào giỏ hàng',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: _bottomNatigator(
              onTap: () async {
                if (product != null) {
                  final result = await showDialogProductDelete();
                  if (result == true) {
                    context.read<ProductDetailCubit>().deleteProduct(
                      product.id!,
                    );
                    context.read<ListProductCubit>().loadFirstPage();
                  }
                }
              },
              icon: Icons.clear_outlined,
              textButton: 'Delete',
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: _bottomNatigator(
              onTap: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return BlocProvider(
                      create: (_) => ImageCubit(ImagePickerService()),
                      child: showModelBottomSheetUpDateProduct(
                        product?.id,
                        product?.name,
                        product?.price,
                        product?.quantity,
                        product?.cover,
                      ),
                    );
                  },
                );
                if (product != null) {
                  context.read<ProductDetailCubit>().updateProduct(
                    product!.id!,
                    name: result['name'],
                    price: int.parse(result['price']),
                    quantity: int.parse(result['quantity']),
                    cover: result['cover'],
                  );
                }
              },
              icon: Icons.shopping_cart,
              textButton: 'Update',
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNatigator({
    required IconData icon,
    required String textButton,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108,
        height: 54,
        decoration: BoxDecoration(color: informationCart),
        // onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              textButton,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showDialogProductDelete() async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => CustomAlertDialogDeleteProduct(
            title: 'Thông báo',
            message: 'Bạn có chắc chắn xóa sản phẩm',
            onConfirm: () {
              Navigator.pop(context, true);
            },
            onCancel: () {
              Navigator.pop(context, false);
            },
          ),
    );
  }
}
