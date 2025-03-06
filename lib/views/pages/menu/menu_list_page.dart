import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/menu_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';
import '../../components/menu_widget.dart';

class MenuListPage extends StatefulWidget {
  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  List<MenuModel> menuList = [];
  int? si;
  List _selectedIndexs = [];
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getdata();
    });
  }

  // Fetch menu and category data
  getdata() async {
    setState(() {
      isloading = true;
    });

    final sharedPrefs = await SharedPreferences.getInstance();
    String? token = sharedPrefs.getString(AppConstants.TOKEN);
    String? shopId = sharedPrefs.getString(AppConstants.SHOPID);

    if (token == null || shopId == null) {
      print("Authentication failed: Missing token or shop ID");
      setState(() {
        isloading = false;
      });
      return;
    }

    try {
      await Future.wait(
          [gprovider.getMenuList(), provider.getMenuCategoriesList()]);

      setState(() {
        menuList = gprovider
            .menuList; // Ensure gprovider.menuList is being updated correctly
        isloading = false;
      });
    } catch (e) {
      print("Error loading menu data: $e");
      setState(() {
        isloading = false;
      });
    }
  }

  // Filter menus by category
  void menuSearch(value) {
    setState(() {
      menuList = gprovider.menuList
          .where((menu) => menu.menuCategoryId == value)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.whiteColor,
          ),
        ),
        backgroundColor: AppColor.mainColor,
        title: Text("Menu Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          await AppRouteName.menuAdd_page.push(context);
          getdata(); // Refresh menu data after adding new menu
        },
        tooltip: "Add Menu",
        backgroundColor: AppColor.mainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          color: AppColor.bgColor,
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColor.mainColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        // Category Filter Section
                        Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListView.builder(
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.menuCategoriesList.length,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= provider.menuCategoriesList.length)
                                return const SizedBox.shrink();

                              final _isSelected =
                                  _selectedIndexs.contains(index);
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      if (_isSelected) {
                                        _selectedIndexs.remove(si);
                                        menuList = gprovider
                                            .menuList; // Reset the menu list
                                      } else {
                                        _selectedIndexs.clear();
                                        _selectedIndexs.add(index);
                                        si = index;
                                        menuSearch(provider
                                            .menuCategoriesList[index]
                                            .menuCategoryId);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3.0),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                      color: _isSelected
                                          ? AppColor.mainColor
                                          : AppColor.whiteColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        provider.menuCategoriesList[index]
                                            .menuCategoryName,
                                        style: Styles.textStyleLarge(
                                          color: _isSelected
                                              ? AppColor.whiteColor
                                              : AppColor.mainColor,
                                        ).copyWith(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Menu List Display Section
                        menuList.isEmpty
                            ? Text(
                                "No Menu Added",
                                style: Styles.textStyleMedium(
                                    color: AppColor.redColor),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: menuList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Dismissible(
                                      key: Key(menuList[index].menuId),
                                      direction: DismissDirection.endToStart,
                                      background: Container(),
                                      confirmDismiss:
                                          (DismissDirection direction) {
                                        return showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Are you sure?'),
                                            content: Text(
                                                'Do you want delete this menu?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await deleteMenu(
                                                      menuList[index].menuId);
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      secondaryBackground: Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.redColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Icon(Icons.delete,
                                                color: AppColor.bgColor,
                                                size: 45),
                                          )),
                                      child: MenuWidget(
                                        image: menuList[index].image,
                                        name: menuList[index].menuName,
                                        rate: menuList[index].rate.toString(),
                                        date: menuList[index].menuDate ?? "N/A",
                                        width: width,
                                        height: height,
                                        onTap: () async {
                                          // await Navigator.pushNamed(
                                          //     context,
                                          //     AppConstants
                                          //         .MENUINGREDIENTLISTPAGE,
                                          //     arguments: menuList[index]);
                                          await AppRouteName
                                              .menuIngredients_page
                                              .push(context,
                                                  args: RouteArgument(data: {
                                                    'route': 'menuIngredient',
                                                    'menuIngredient':
                                                        menuList[index]
                                                  }));
                                          getdata(); // Refresh the data after navigation
                                        },
                                      ),
                                    ),
                                  );
                                }),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // Placeholder for delete functionality
  deleteMenu(String menuID) async {
    // Implement your delete logic here if needed.
  }
}
