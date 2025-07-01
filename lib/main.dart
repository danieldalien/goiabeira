import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goiabeira/0_Core/Config/app_dependencies.dart';
import 'package:goiabeira/1_UI_Layer/Screen/main_screen_old.dart';
import 'package:goiabeira/1_UI_Layer/main_screen.dart';
import 'package:goiabeira/2_State_layer/analytics/analytics_bloc.dart';
import 'package:goiabeira/2_State_layer/inventory/inventory_bloc.dart';
import 'package:goiabeira/2_State_layer/sold_inventory/sold_inventory_bloc.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';
import 'package:goiabeira/4_Data_Layer/Repo/local_database_repo.dart';
import 'package:goiabeira/4_Data_Layer/Repo/local_file_storage_repo.dart';
import 'package:goiabeira/4_Data_Layer/Service/get_it_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseRepository<StockItem> stockItemRepository =
      LocalDatabaseRepo<StockItem>(
        toMap: StockItem.toMap,
        fromMap: StockItem.fromJson,
      );
  DatabaseRepository<SoldItem> soldItemRepository = LocalDatabaseRepo<SoldItem>(
    toMap: SoldItem.toMap,
    fromMap: SoldItem.fromJson,
  );
  DatabaseRepository<ItemCategory> itemCategoryRepository =
      LocalDatabaseRepo<ItemCategory>(
        toMap: ItemCategory.toMap,
        fromMap: ItemCategory.fromJson,
      );

  final FileStorageRepo fileStorageRepository = LocalFileStorageRepo();
  final AppDependencies appDependencies = AppDependencies();
  await appDependencies.initAll(
    stockItemRepository: stockItemRepository,
    fileStorageRepository: fileStorageRepository,
    soldItemRepository: soldItemRepository,
    itemCategoryRepository: itemCategoryRepository,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InventoryBloc()),
        BlocProvider(create: (context) => SoldInventoryBloc()),
        BlocProvider(create: (context) => AnalyticsBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const seed = Color.fromARGB(255, 255, 114, 20);

  static final lightScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );
  static final darkScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goiabeira',
      themeMode: ThemeMode.system, // Use system theme mode
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: (lightScheme.surface),
          indicatorColor: lightScheme.primaryContainer,

          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            elevation: WidgetStatePropertyAll(0), // flat in M3
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkScheme.surface,
          indicatorColor: darkScheme.primaryContainer,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MainScreen();
  }
}
