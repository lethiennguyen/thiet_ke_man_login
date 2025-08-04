import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ma_so_thue/blocs/product/create_prodcut_cubit.dart';
import 'package:ma_so_thue/blocs/product/create_prodcut_state.dart';
import 'package:ma_so_thue/blocs/product/image_cubit.dart';
import 'package:ma_so_thue/blocs/product/image_state.dart';
import 'package:ma_so_thue/blocs/product/list_product_cubit.dart';
import 'package:ma_so_thue/data/models/product.dart';
import 'package:ma_so_thue/data/upload_image/upload_image_network.dart';
import 'package:ma_so_thue/enums/product_field.dart';
import 'package:ma_so_thue/ui/common/app_colors.dart';
import 'package:ma_so_thue/ui/common/input_field.dart';

class AddProcduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return buildAddPProdcut();
  }
}

class buildAddPProdcut extends State<AddProcduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _priceController = TextEditingController();
  late TextEditingController _quantityController = TextEditingController();
  Product? prodcut;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(),
          body:
              state.status == CreateProductStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : formAddProduct(state.product),
          bottomNavigationBar: bottomNavigator(state.product),
        );
      },
    );
  }

  Widget formAddProduct(Product? product) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  BlocBuilder<ImageCubit, ImageState>(
                    builder: (context, state) {
                      return ImagePickerWidget(
                        label: 'Ảnh sản phẩm',
                        width: 200,
                        height: 200,
                        imageUrl: state.imageUrl,
                        isLoading: state.isUploading,
                        progress: 0,
                        onTap: () {
                          context.read<ImageCubit>().pickAndUploadImage();
                        },
                        placeholder: Icon(Icons.person, size: 60),
                      );
                    },
                  ),
                  ModernInputField(
                    label: ProductField.name.lable,
                    hintText: ProductField.name.hint,
                    controller: _nameController,
                    focusNode: FocusNode(),
                  ),
                  ModernInputField(
                    label: ProductField.price.lable,
                    hintText: ProductField.price.hint,
                    controller: _priceController,
                    focusNode: FocusNode(),
                  ),
                  ModernInputField(
                    label: ProductField.quantity.lable,
                    hintText: ProductField.quantity.hint,
                    controller: _quantityController,
                    focusNode: FocusNode(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigator(Product? product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          var imageUrl = context.read<ImageCubit>().state.imageUrl;
          context.read<CreateProductCubit>().createprodcut(
            name: _nameController.text,
            price: int.parse(_priceController.text),
            quantity: int.parse(_quantityController.text),
            cover: imageUrl.toString(),
          );
          context.read<ListProductCubit>().loadFirstPage();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Thêm thành công')));
          _nameController.clear();
          _priceController.clear();
          _quantityController.clear();
        },
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            color: kBrandOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Thêm sản phẩm',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
