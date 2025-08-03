import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ma_so_thue/blocs/product/image_cubit.dart';
import 'package:ma_so_thue/blocs/product/image_state.dart';
import 'package:ma_so_thue/data/models/product.dart';
import 'package:ma_so_thue/data/upload_image/upload_image_network.dart';
import 'package:ma_so_thue/ui/common/input_field.dart';

class showModelBottomSheetUpDateProduct extends StatefulWidget {
  final int? productID;
  final String? name;
  final int? price;
  final int? quantity;
  final String? cover;
  showModelBottomSheetUpDateProduct(
    this.productID,
    this.name,
    this.price,
    this.quantity,
    this.cover,
  );

  @override
  State<StatefulWidget> createState() =>
      _ShowModelBottomSheetUpDateProductState();
}

class _ShowModelBottomSheetUpDateProductState
    extends State<showModelBottomSheetUpDateProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _coverController;
  File? _selectedImage;
  Product? product;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _priceController = TextEditingController(text: widget.price.toString());
    _quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
    _coverController = TextEditingController(text: widget.cover);
    _loadProductFromHive();
  }

  Future<void> _loadProductFromHive() async {
    if (widget.productID == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.8,
      child: _customitemProduct(context),
    );
  }

  Widget _customitemProduct(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                BlocBuilder<ImageCubit, ImageState>(
                  builder: (context, state) {
                    return ImagePickerWidget(
                      label: 'Ảnh đại diện',
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
                SizedBox(height: 16),
                ModernInputField(
                  label: 'Sản phẩm',
                  hintText: 'Nhập tên sản phẩm',
                  controller: _nameController,
                  focusNode: FocusNode(),
                  keyboardType: TextInputType.text,
                ),
                ModernInputField(
                  label: 'Giá',
                  hintText: 'Nhập giá sản phẩm',
                  controller: _priceController,
                  focusNode: FocusNode(),
                  keyboardType: TextInputType.number,
                ),
                ModernInputField(
                  label: 'Số lượng',
                  hintText: 'Nhập số lượng',
                  controller: _quantityController,
                  focusNode: FocusNode(),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: () {
              final imageUrl = context.read<ImageCubit>().state.imageUrl;
              Navigator.pop(context, {
                'name': _nameController.text,
                'price': _priceController.text,
                'quantity': _quantityController.text,
                'cover': imageUrl,
              });
            },
            child: Text(
              'Update',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
              backgroundColor: Color(0xffF24E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
