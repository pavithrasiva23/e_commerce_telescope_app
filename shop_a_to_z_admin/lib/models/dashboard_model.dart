import 'package:flutter/material.dart';
import 'package:shop_a_to_z/pages/add_telescope_page.dart';
import 'package:shop_a_to_z/pages/brand_page.dart';
import 'package:shop_a_to_z/pages/view_telescope_list_page.dart';

import '../pages/orders_page.dart';
import '../pages/report_page.dart';
import '../pages/users_profile_page.dart';

class DashboardModel {
  final String title;
  final IconData iconData;
  final String routeName;

  const DashboardModel({required this.title, required this.iconData, required this.routeName});
}

const List<DashboardModel> dashboardList = [
  DashboardModel(title: 'Add Telescope', iconData: Icons.add, routeName: AddTelescopePage.routeName),
  DashboardModel(title: 'View Telescope', iconData: Icons.inventory, routeName: ViewTelescopeListPage.routeName),
  DashboardModel(title: 'Brands', iconData: Icons.category, routeName: BrandPage.routeName),
  DashboardModel(title: 'Orders', iconData: Icons.monetization_on, routeName: OrdersPage.routeName),
  DashboardModel(title: 'Users', iconData: Icons.supervised_user_circle_sharp, routeName: UsersProfilePage.routeName),
  DashboardModel(title: 'Report', iconData: Icons.bar_chart, routeName: ReportPage.routeName),
];