import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_product/get_product_bloc.dart';

import '../../../core/core.dart';
import '../models/menu_model.dart';
import '../widgets/form_menu_bottom_sheet.dart';
import '../widgets/menu_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetProductBloc>().add(GetProductEvent.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Menu',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const FormMenuBottomSheet(),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),

          // Sliver untuk konten
          BlocBuilder<GetProductBloc, GetProductState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                loading: () {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                error: (message) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text(message)),
                  );
                },
                loaded: (menus) {
                  if (menus.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: const Center(child: Text('No Menu Available')),
                    );
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 3 / 4,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => MenuCard(item: menus[index]),
                          childCount: menus.length,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
