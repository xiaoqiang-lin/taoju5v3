/*
 * @Description: 窗帘商品
 * @Author: iamsmiling
 * @Date: 2021-01-18 14:29:37
 * @LastEditTime: 2021-01-19 12:14:39
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:taoju5/b-end-app/domain/model/product/curtain_product_attr_model.dart';
import 'package:taoju5/b-end-app/res/b_dimens.dart';
import 'package:taoju5/b-end-app/ui/modal/product/base/x_base_attr_modal.dart';
import 'package:taoju5/b-end-app/ui/pages/product/product_detail/fragment/product_attrs_selector/base/base_attr_selector_controller.dart';
import 'package:taoju5/b-end-app/ui/pages/product/product_detail/fragment/product_attrs_selector/base/curtain_product_attr_option_card.dart';
import 'package:taoju5/b-end-app/ui/widgets/common/button/x_border_frame.dart';

class CurtainProductAttrModal<T extends BaseAttrSelectorController>
    extends StatelessWidget {
  final String title;
  final String tag;
  final Function onConfirm;
  const CurtainProductAttrModal(
      {Key key,
      @required this.title,
      @required this.tag,
      @required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XBaseAttrModal(
      title: title,
      height: Get.height * .72,
      builder: (BuildContext context) {
        return GetBuilder<T>(
          tag: tag,
          id: tag,
          builder: (_) {
            return WillPopScope(
              onWillPop: _.reset,
              child: Container(
                child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: BDimens.gap32),
                    physics: BouncingScrollPhysics(),
                    itemCount: _.attr?.optionList?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      //横轴间距
                    ),
                    itemBuilder: (BuildContext context, int i) {
                      CurtainProductAttrOptionModel option =
                          _.attr.optionList[i];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _.select(_.attr, option);
                        },
                        child: XBorderFrame(
                          visible: option.isChecked,
                          child: CurtainProductAttrOptionCard(
                            option: option,
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        );
      },
      onConfirm: onConfirm,
    );
  }
}
