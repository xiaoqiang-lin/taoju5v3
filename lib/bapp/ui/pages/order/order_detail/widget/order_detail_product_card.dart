/*
 * @Description: 订单详情商品卡片
 * @Author: iamsmiling
 * @Date: 2021-01-06 14:44:36
 * @LastEditTime: 2021-01-22 09:45:57
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taoju5/bapp/domain/model/order/order_detail_product_model.dart';
import 'package:taoju5/bapp/domain/model/order/order_status.dart';
import 'package:taoju5/bapp/domain/model/order/order_type.dart';
import 'package:taoju5/bapp/res/b_colors.dart';
import 'package:taoju5/bapp/res/b_dimens.dart';
import 'package:taoju5/bapp/ui/pages/order/order_detail/order_detail_controller.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taoju5/bapp/ui/widgets/common/x_photo_viewer.dart';

class OrderDetailProductCard extends StatelessWidget {
  final OrderDetailProductModel product;
  const OrderDetailProductCard(this.product, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: BDimens.gap16, vertical: BDimens.gap24),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: BDimens.gap32),
                      child: SizedBox(
                        height: 180.h,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: XPhotoViewer(url: product.image),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 180.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                      fontSize: BDimens.sp30,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  product.orderStatusName,
                                  style: TextStyle(
                                      fontSize: BDimens.sp30,
                                      color: BColors.pinkColor),
                                )
                              ],
                            ),
                            Text(
                              "¥${product.price}",
                              style: TextStyle(fontSize: BDimens.sp28),
                            ),
                            Text(product.description,
                                style: TextStyle(
                                    color: BColors.tipColor,
                                    fontSize: BDimens.sp24)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
                top: BDimens.gap32, bottom: BDimens.gap8, right: BDimens.gap32),
            child: Text(
              "小计:¥${product.totalPrice}",
              style: TextStyle(
                  fontSize: BDimens.sp24, fontWeight: FontWeight.w500),
            ),
          ),

          ///操作按钮
          Container(
            width: Get.width,
            alignment: Alignment.centerRight,
            child: _OrderDetailProductActionBar(
              product: product,
            ),
          )
        ],
      ),
    );
  }
}

class _OrderDetailProductActionBar extends StatelessWidget {
  final OrderDetailProductModel product;
  const _OrderDetailProductActionBar({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
      id: "buttonState",
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///进入生产环节的商品不可取消
            Visibility(
                child: Row(
                  children: [
                    GetBuilder<OrderDetailController>(
                        id: "${product.id}",
                        builder: (_) {
                          return Visibility(
                              child: OutlinedButton(
                                  onPressed: product.canRefund
                                      ? () => _.openCancelProductDialog(product)
                                      : null,
                                  child:
                                      Text(product.canRefund ? "取消" : "取消待审核")),
                              visible:
                                  product.canCancel || product.isCanceling);
                        }),

                    ///已取消
                    Visibility(
                        child:
                            OutlinedButton(onPressed: null, child: Text("已取消")),
                        visible: product.orderStatus == OrderStatus.canceled),
                  ],
                ),
                visible: product.orderStatus < OrderStatus.producing),
            SizedBox(
              width: BDimens.gap24,
            ),

            ///进入生产环节的商品不可取消
            Visibility(
                child: Row(
                  children: [
                    ///未选品
                    GetBuilder<OrderDetailController>(
                      id: "${product.id}",
                      builder: (_) {
                        return Visibility(
                            child: OutlinedButton(
                                onPressed: product.canRefund
                                    ? () => _.goToSelect(product)
                                    : null,
                                child: Text(
                                    !product.hasSelected ? "去选品" : "更换选品")),
                            visible: product.canSelect);
                      },
                    ),
                  ],
                ),
                visible: product.orderType == OrderType.measureOrder),
          ],
        );
      },
    );
  }
}
