/*
 * @Description: 客户列表页
 * @Author: iamsmiling
 * @Date: 2020-12-21 17:18:59
 * @LastEditTime: 2021-02-01 14:15:40
 */

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taoju5/b-end-app/domain/model/customer/customer_category_model.dart';
import 'package:taoju5/b-end-app/domain/model/customer/customer_model.dart';
import 'package:taoju5/b-end-app/res/b_colors.dart';
import 'package:taoju5/b-end-app/res/b_dimens.dart';
import 'package:taoju5/b-end-app/res/b_icons.dart';
import 'package:taoju5/b-end-app/routes/bapp_pages.dart';
import 'package:taoju5/b-end-app/ui/pages/customer/customer_list/customer_list_controller.dart';
import 'package:taoju5/b-end-app/ui/pages/customer/customer_list/customer_list_skeleton.dart';
import 'package:taoju5/b-end-app/ui/pages/home/customer_provider_controller.dart';
import 'package:taoju5/b-end-app/ui/pages/order/commit_order/commit_order_controller.dart';
import 'package:taoju5/b-end-app/ui/pages/search/search_controller.dart';
import 'package:taoju5/b-end-app/ui/widgets/base/x_loadstate_builder.dart';
import 'package:taoju5/config/app_config.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("客户列表页面"),
        actions: [
          IconButton(
              icon: Icon(BIcons.search),
              onPressed: () => Get.toNamed(BAppRoutes.search,
                  arguments: SearchType.customer)),
          IconButton(
              icon: Image.asset(
                  AppConfig.assetImagePrefixPath + "customer_add.png"),
              onPressed: () => Get.toNamed(BAppRoutes.customerEdit + "/0"))
        ],
      ),
      body: GetBuilder<CustomerListController>(builder: (_) {
        return Column(
          children: [
            for (CustomerCategoryModel e in _.categoryList)
              Column(
                children: [
                  Container(
                    color: BColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: BDimens.gap32, vertical: BDimens.gap24),
                    child: Row(
                      children: [
                        Image.asset(AppConfig.assetImagePrefixPath + e.icon),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: BDimens.gap24),
                          child: Text(e.name),
                        ),
                        Text("(${e.count})"),
                        Spacer(),
                        Icon(BIcons.next)
                      ],
                    ),
                  ),
                  Divider()
                ],
              ),
            Expanded(
              child: XLoadStateBuilder(
                  loadState: _.loadState,
                  loadingWidget: CustomerListSkeleton(),
                  builder: (BuildContext context) {
                    return AzListView(
                        data: _.customerList,
                        itemCount: _.customerList.length,
                        indexBarData:
                            _.customerList.map((e) => e.tag).toSet().toList(),
                        susItemBuilder: (BuildContext context, int i) {
                          String tag = _.customerList[i].tag;
                          String lastTag =
                              i == 0 ? "#" : _.customerList[i - 1].tag;
                          return Visibility(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: BDimens.gap32,
                                  vertical: BDimens.gap4),
                              child: Text(
                                "$tag",
                                textAlign: TextAlign.start,
                              ),
                            ),
                            visible: i == 0 ? true : tag != lastTag,
                          );
                        },
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            onTap: () {
                              if (!(Get.arguments ?? false)) {
                                Get.toNamed(BAppRoutes.customerDetail +
                                    "/${_.customerList[i].id}");
                                return;
                              }
                              Get.find<CustomerProviderController>()
                                  .setCustomer(_.customerList[i]);
                              return Get.until((route) => Get.currentRoute
                                  .contains(
                                      (Get.isRegistered<CommitOrderController>()
                                          ? BAppRoutes.commitOrder
                                          : BAppRoutes.productDetail)));
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              color: BColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: BDimens.gap32,
                                  vertical: BDimens.gap16),
                              child: Text("${_.customerList[i].name}"),
                            ),
                          );
                        });
                  }),
            )
          ],
        );
      }),
    );
  }
}
