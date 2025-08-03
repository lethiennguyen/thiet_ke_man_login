// app_routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/blocs/product/cart_cubit.dart';
import 'package:ma_so_thue/blocs/product/create_prodcut_cubit.dart';
import 'package:ma_so_thue/blocs/product/image_cubit.dart';
import 'package:ma_so_thue/blocs/product/list_product_cubit.dart';
import 'package:ma_so_thue/blocs/product/product_detail_cubit.dart';
import 'package:ma_so_thue/data/core/api_client.dart';
import 'package:ma_so_thue/data/repositories/product_reponsitories.dart';
import 'package:ma_so_thue/data/upload_image/image_picker_service.dart';
import 'package:ma_so_thue/hive/hive_constants.dart';
import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';
import 'package:ma_so_thue/ui/home/home_page.dart';
import 'package:ma_so_thue/ui/login/login.dart';
import 'package:ma_so_thue/ui/product/add_product.dart';
import 'package:ma_so_thue/ui/product/list_product.dart';
import 'package:ma_so_thue/ui/product/product_information.dart';
import 'package:ma_so_thue/ui/shopping_cart/shopping_cart.dart';

final productRepo = ProductRepository(dio);

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => MyHomeLogin(),

  '/product-list':
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              final cubit = ListProductCubit(productRepo);
              cubit.loadFirstPage();
              return cubit;
            },
          ),
        ],
        child: ProductList(),
      ),

  '/home': (_) => LogoutPage(),

  '/thongtinsanpham':
      (context) => BlocProvider(
        create: (_) => ProductDetailCubit(ProductDetailRepository(dio)),
        child: ProductInformation(),
      ),

  '/shopping_cart':
      (context) => BlocProvider(
        create: (_) => CartCubit(Hive.box<CartItem>(HiveBoxNames.cartbox)),
        child: ShoppingCart(),
      ),

  '/add_product':
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CreateProductCubit(CreateProductRepository(dio)),
          ),
          BlocProvider(create: (_) => ImageCubit(ImagePickerService())),
        ],
        child: AddProcduct(),
      ),
};
