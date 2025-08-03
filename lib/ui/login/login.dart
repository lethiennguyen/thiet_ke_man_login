import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/blocs/auth/auth_bloc.dart';
import 'package:ma_so_thue/blocs/auth/auth_event.dart';
import 'package:ma_so_thue/blocs/auth/auth_state.dart';
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
  final FocusNode _maSoThue = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _maSoThueController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  late List<TextEditingController> _controller;
  late List<FocusNode> _focusNode;
  late List<bool> _isFocused;

  // Thêm list để theo dõi trạng thái validation của từng field
  late List<bool> _hasBeenUnfocused;
  late List<String?> _fieldErrors;

  final List<String> title = ['Mã số thuế', 'Tài khoản', 'Mật khẩu'];
  final List<String> titleHint = ['000012', 'Tài khoản', 'Mật khẩu'];
  final List<List<String>> suffixIconSVG = [
    [''],
    [''],
    ['asset/eye.svg', 'asset/eye-slash.svg'],
  ];
  bool _isClearing = false;
  @override
  void initState() {
    super.initState();
    _controller = [
      _maSoThueController,
      _usernameController,
      _passwordController,
    ];
    _focusNode = [_maSoThue, _usernameFocus, _passwordFocus];
    _isFocused = [false, false, false];
    _hasBeenUnfocused = [false, false, false];
    _fieldErrors = [null, null, null];
    //ddieenfn tai khoản khi quay ve
    final box = Hive.box('authBox');
    _maSoThueController.text = box.get('maSoThue', defaultValue: '');
    _usernameController.text = box.get('taiKhoan', defaultValue: '');
    _passwordController.text = box.get('matKhau', defaultValue: '');
    for (int i = 0; i < _focusNode.length; i++) {
      final index = i;
      _focusNode[index].addListener(() {
        setState(() {
          bool wasFocused = _isFocused[index];
          _isFocused[index] = _focusNode[index].hasFocus;
          if (wasFocused && !_focusNode[index].hasFocus) {
            _hasBeenUnfocused[index] = true;
            _formKey.currentState?.validate();
            _fieldErrors[index] = _fieldValidator(
              index,
              _controller[index].text,
            );
          }
        });
      });
    }

    for (int i = 0; i < _controller.length; i++) {
      final index = i;
      _controller[index].addListener(() {
        if (_isClearing) return;
        setState(() {
          if (true || _hasBeenUnfocused[index] || _submitted) {
            _fieldErrors[index] = _fieldValidator(
              index,
              _controller[index].text,
            );
          }
        });
      });
    }
  }

  String? _fieldValidator(int index, String? value) {
    final v = (value ?? '').trim();
    if (index == 0 && v.length != 10) {
      return 'Mã số thuế phải đúng 10 ký tự';
    }
    if (index == 1 && v.isEmpty) {
      return 'Tài khoản không được để trống';
    }
    if (index == 2 && (v.length < 6 || v.length > 50)) {
      return 'Mật khẩu phải từ 6 đến 50 ký tự';
    }
    return null;
  }

  void _onSubmit() {
    setState(() {
      _submitted = true;
      for (int i = 0; i < _controller.length; i++) {
        _fieldErrors[i] = _fieldValidator(i, _controller[i].text);
      }
    });
    if (_formKey.currentState!.validate()) {
      final box = Hive.box('authBox');
      box.put('maSoThue', _maSoThueController.text);
      box.put('taiKhoan', _usernameController.text);
      context.read<AuthBloc>().add(
        LoginRequested(
          _maSoThueController.text,
          _usernameController.text,
          _passwordController.text,
        ),
      );
    } else {
      print('hiển thi dialog');
      showDialogLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state.status == AuthStatus.failure) {
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
                  asset: 'asset/headphone.svg',
                  textButton: 'Trợ giúp',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _bottomNatigator(
                  asset: 'asset/Social_link.svg',
                  textButton: 'Group',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _bottomNatigator(
                  asset: 'asset/search-normal.svg',
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
        SvgPicture.asset('asset/Frame427324088.svg', width: 158, height: 37),
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
                Column(
                  children: List.generate(3, (index) {
                    return _buildInputField(
                      text: title[index],
                      isColorBoder: _isFocused[index],
                      focusNode: _focusNode[index],
                      controller: _controller[index],
                      hintText: titleHint[index],
                      suffixIconSVG: suffixIconSVG[index][0],
                      isPassword: index == 2,
                      index: index,
                      keyboardType:
                          index == 0
                              ? TextInputType.number
                              : TextInputType.text,
                      validator: (value) => _fieldValidator(index, value),
                    );
                  }),
                ),
                SizedBox(height: 20),
                Container(
                  width: 343,
                  height: 54,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: ElevatedButton(
                    onPressed: _onSubmit,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          //mainAxisSize: MainAxisSize.min,
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
    required String text,
    required bool isColorBoder,
    required FocusNode focusNode,
    required TextEditingController controller,
    required String hintText,
    required String suffixIconSVG,
    required int index,
    required TextInputType keyboardType,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
  }) {
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
                  text,
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
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color:
                          isColorBoder ? Color(0xffF24E1E) : Color(0xffEBECED),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 15, top: 15, left: 16),
                    child: TextFormField(
                      focusNode: focusNode,
                      keyboardType: keyboardType,
                      obscureText: isPassword ? !_isPasswordVisible : false,
                      controller: controller,
                      cursorColor: Color(0xffF24E1E),
                      decoration: InputDecoration(
                        hintText: hintText,
                        suffixIcon:
                            (index == 0 || index == 1) &&
                                    controller.text.isNotEmpty
                                ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isClearing = true;
                                      controller.clear();
                                    });

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          setState(() {
                                            _isClearing = false;
                                          });
                                        });
                                  },
                                  child: SvgPicture.asset(
                                    'asset/clear.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                                : index == 2
                                ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    _isPasswordVisible
                                        ? 'asset/eye-slash.svg'
                                        : 'asset/eye.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                                : (suffixIconSVG != ''
                                    ? SvgPicture.asset(
                                      suffixIconSVG,
                                      width: 20,
                                      height: 20,
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
              // Chỉ hiển thị lỗi nếu field đã từng bị unfocus hoặc đã submit
              (_fieldErrors[index] ?? ''),
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
