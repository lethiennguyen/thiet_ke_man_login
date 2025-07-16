import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomeLogin extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return FormLogin();
  }

}
class FormLogin  extends State<MyHomeLogin>{
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _maSoThue = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _maSoThueController = TextEditingController();
  bool _isPasswordVisible = false;
  late List<TextEditingController> _controller;
  late List<FocusNode> _focusNode;
  late List<bool> _isFocused;
  final List<String> title = ['Mã số thuế','Tài khoản','Mật khẩu'];
  final List<String> titleHint = ['000012','Tài khoản','Mật khẩu'];
  final List<String> Notification = ['','Tên đăng nhập không được để trống','Mật khẩu phải từ 8 đến 50 ký tự'];
  final List<List<String>> suffixIconSVG = [['asset/clear.svg'], [''], ['asset/eye.svg', 'asset/eye-slash.svg']];
  @override
  void initState() {
    super.initState();
    _controller=[
      _maSoThueController,
      _usernameController,
      _passwordController,
    ];
    _focusNode=[
      _maSoThue,
      _usernameFocus,
      _passwordFocus
    ];
    _isFocused = [false, false, false];
    for (int i = 0; i < _focusNode.length; i++) {
      _focusNode[i].addListener(() {
        setState(() {
          _isFocused[i] = _focusNode[i].hasFocus;
        });
      });
    }
    for (var ctrl in _controller) {
      ctrl.addListener(() {
        setState(() {});
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child:_formLogin(context),
        ),
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
    );
  }
  Widget _formLogin(BuildContext context)
  {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top : 76,
            left: 16,
          ),
          child: SvgPicture.asset(
            'asset/Frame427324088.svg',
            width: 158,
            height: 37,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top : 137,
            right: 16,
            left: 16,
          ),
          child: Expanded(
            child: Column(
              children: [
                Column(
                  children: List.generate(3, (index){
                    return _buildInputField(
                        text: title[index],
                        isColorBoder: _isFocused[index],
                        focusNode: _focusNode[index],
                        controller: _controller[index],
                        hintText: titleHint[index],
                        suffixIconSVG: suffixIconSVG[index][0],
                        notification: Notification[index],
                        isPassword: index ==2,
                        index: index,
                    );
                  })
                ),
                SizedBox(height: 20,),
                Container(
                  width: 343,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
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
                )
              ],
            ),
          ),
        ),

      ],
    );
  }
  Widget _bottomNatigator({
    required String asset,
    required String textButton,
  }) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: 108,
        height: 54,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                width: 1,
                color: Color(0xffEBECED)
            )
        ),
       // onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
             SvgPicture.asset(
                asset,
                width: 20,
                height: 20,
              ),
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
        )
      ),
    );
  }
  Widget _buildInputField(
      {
        required String text,
        required bool isColorBoder,
        required FocusNode focusNode,
        required TextEditingController controller,
        required String hintText,
        required String suffixIconSVG,
        required String notification,
        required int index,
        bool isPassword = false
      }
      ){
    return Column(
      children: [
        Container(
          width: 343,
          height: 86,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 62,
                ),
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
                        color: isColorBoder ? Color(0xffF24E1E): Color(0xffEBECED)
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 15,
                      top: 15,
                      left: 16,
                    ),
                    child: TextFormField(
                      focusNode: focusNode,
                      obscureText: isPassword ? !_isPasswordVisible : false,
                      controller: controller,
                      cursorColor: Color(0xffF24E1E),
                      decoration: InputDecoration(
                        hintText: hintText,
                        suffixIcon: index == 0&& controller.text.isNotEmpty
                            ? GestureDetector(
                          onTap: () {
                            controller.clear();
                            setState(() {});
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
              notification,
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xffFF0000),
              ),
            ),
          ),
        ),
        SizedBox(height: 4,)
      ],
    );
  }
}
