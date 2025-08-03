import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/base/asset/base_asset.dart';
import 'package:ma_so_thue/blocs/auth/auth_bloc.dart';
import 'package:ma_so_thue/blocs/auth/auth_event.dart';
import 'package:ma_so_thue/blocs/auth/auth_state.dart';
import 'package:ma_so_thue/enums/login_field.dart';
import 'package:ma_so_thue/ui/common/dialog.dart';

class MyHomeLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormLogin();
  }
}

class FormLogin extends State<MyHomeLogin> {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _maSoThueFocus = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _maSoThueController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  late Map<LoginField, TextEditingController> _controllers;
  late Map<LoginField, FocusNode> _focusNodes;
  late Map<LoginField, String?> _fieldErrors;
  late Map<LoginField, bool> _hasBeenUnfocused;
  bool _submitted = false;
  bool _isClearing = false;
  @override
  void initState() {
    super.initState();

    final box = Hive.box('authBox');
    _controllers = {
      LoginField.tax_code: TextEditingController(
        text: box.get('maSoThue', defaultValue: ''),
      ),
      LoginField.user_name: TextEditingController(
        text: box.get('taiKhoan', defaultValue: ''),
      ),
      LoginField.password: TextEditingController(
        text: box.get('matKhau', defaultValue: ''),
      ),
    };
    _focusNodes = {
      LoginField.tax_code: FocusNode(),
      LoginField.user_name: FocusNode(),
      LoginField.password: FocusNode(),
    };
    _fieldErrors = {
      LoginField.tax_code: null,
      LoginField.user_name: null,
      LoginField.password: null,
    };
    _hasBeenUnfocused = {
      LoginField.tax_code: false,
      LoginField.user_name: false,
      LoginField.password: false,
    };
    LoginField.values.forEach((field) {
      _focusNodes[field]!.addListener(() {
        if (!_focusNodes[field]!.hasFocus) {
          setState(() {
            _hasBeenUnfocused[field] = true;
            _formKey.currentState?.validate();
            _fieldErrors[field] = field.validate(_controllers[field]!.text);
          });
        }
      });
      _controllers[field]!.addListener(() {
        if (_isClearing) return;
        setState(() {
          if (_hasBeenUnfocused[field]! || _submitted || true) {
            _fieldErrors[field] = field.validate(_controllers[field]!.text);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state.status == LoginStatus.failure) {
          showDialogLogin(context);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(child: _formLogin(context)),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _bottomNatigator(
                  asset: IconsAssets.headphone,
                  textButton: 'Trợ giúp',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _bottomNatigator(
                  asset: IconsAssets.Social_link,
                  textButton: 'Group',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _bottomNatigator(
                  asset: IconsAssets.search_normal,
                  textButton: 'Tra cứu',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLogin(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(height: 76),
        SvgPicture.asset(Pictures.logo, width: 158, height: 37),
        const SizedBox(height: 61),
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 137, right: 16, left: 16),
          child: Form(
            key: _formKey,
            autovalidateMode:
                _submitted // chỉ validate sau submit
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
            child: Column(
              children: [
                _buildInputField(field: LoginField.tax_code),
                _buildInputField(field: LoginField.user_name),
                _buildInputField(field: LoginField.password, isPassword: true),
                SizedBox(height: 20),
                _buttonLogin(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: 343,
      height: 54,
      decoration: BoxDecoration(color: Colors.transparent),
      child: ElevatedButton(
        onPressed:
            () => context.read<LoginBloc>().add(
              LoginRequested(
                _controllers[LoginField.tax_code]!.text,
                _controllers[LoginField.user_name]!.text,
                _controllers[LoginField.password]!.text,
              ),
            ),
        child: Text(
          'Đăng nhập',
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffF24E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _bottomNatigator({required String asset, required String textButton}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 108,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 1, color: Color(0xffEBECED)),
        ),
        // onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset, width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              textButton,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required LoginField field,
    bool isPassword = false,
  }) {
    final isFocused = _focusNodes[field]?.hasFocus ?? false;
    final hasError = (_fieldErrors[field] ?? '').isNotEmpty;

    return Column(
      children: [
        Container(
          width: 343,
          height: 86,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 62),
                child: Text(
                  field.lable,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xff242E37),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                child: AnimatedContainer(
                  height: 54,
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color:
                          hasError
                              ? Colors.red
                              : (isFocused
                                  ? Color(0xffF24E1E)
                                  : Color(0xffEBECED)),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 15, top: 15, left: 16),
                    child: TextFormField(
                      focusNode: _focusNodes[field],
                      keyboardType: field.keyboardType,
                      obscureText: isPassword ? !_isPasswordVisible : false,
                      controller: _controllers[field],
                      cursorColor: Color(0xffF24E1E),
                      decoration: InputDecoration(
                        hintText: field.hint,
                        suffixIcon:
                            field == LoginField.password
                                ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    _isPasswordVisible
                                        ? IconsAssets.eye_slash
                                        : IconsAssets.eye,
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                                : (_controllers[field]!.text.isNotEmpty
                                    ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isClearing = true;
                                          _controllers[field]!.clear();
                                        });
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              setState(() {
                                                _isClearing = false;
                                              });
                                            });
                                      },
                                      child: SvgPicture.asset(
                                        IconsAssets.clear,
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                    : null),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 16),
          height: 16,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              (_fieldErrors[field] ?? ''),
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xffFF0000),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  void showDialogLogin(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => const CustomAlertDialog(
            title: 'Thông báo',
            message: 'Thông tin đăng nhập không hợp lệ',
          ),
    );
  }
}
