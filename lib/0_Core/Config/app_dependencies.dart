import 'package:get_it/get_it.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Services/analytics_service.dart';
import 'package:goiabeira/4_Data_Layer/Interface/item_category_repo.dart';
import 'package:goiabeira/4_Data_Layer/Interface/sell_handler_impl.dart';
import 'package:goiabeira/4_Data_Layer/Interface/stock_handler_impl.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';
import 'package:goiabeira/4_Data_Layer/Service/analytics_service_impl.dart';
import 'package:goiabeira/4_Data_Layer/Service/get_it_service.dart';

class AppDependencies {
  final GetItService _getIt = GetItService();

  Future<void> initAll({
    required DatabaseRepository<StockItem> stockItemRepository,
    required DatabaseRepository<SoldItem> soldItemRepository,
    required FileStorageRepo fileStorageRepository,
    required DatabaseRepository<ItemCategory> itemCategoryRepository,
  }) async {
    await fileStorageRepository.init();
    await _initStockHandler(stockItemRepository, fileStorageRepository);
    await initSetllingHandler(soldItemRepository, fileStorageRepository);
    await initItemCategory(itemCategoryRepository);

    final StockHandlerInterface stockHandler =
        GetIt.instance<StockHandlerInterface>();

    final SellHandlerInterface sellHandler =
        GetIt.instance<SellHandlerInterface>();

    await initAnalyticsService(
      sellHandlerInterface: sellHandler,
      stockHandlerInterface: stockHandler,
    );
  }

  Future<void> initItemCategory(
    DatabaseRepository<ItemCategory> repository,
  ) async {
    var table = {
      'item_category_table': '''
    CREATE TABLE item_category_table (
      id TEXT PRIMARY KEY,
      title TEXT,
      description TEXT,
      iconData INTEGER
    )
  ''',
    };
    await repository.init(table);
    ItemCategoryRepo itemCategoryHandlerInterface = ItemCategoryRepo(
      repository: repository,
    );

    _getIt.registerSingleton<ItemCategoryRepo>(itemCategoryHandlerInterface);
  }

  Future<void> _initStockHandler(
    DatabaseRepository<StockItem> repository,
    FileStorageRepo fileStorageRepository,
  ) async {
    var table = {
      'stock_items_table': '''
    CREATE TABLE stock_items_table (
      id TEXT PRIMARY KEY,
      title TEXT,
      description TEXT,
      buyPrice REAL,
      sellPrice REAL,
      category TEXT,
      imageList TEXT,
      idSupplier TEXT,
      barcodeArticel TEXT,
      barcodeSupplier TEXT,
      quantity INTEGER
    )
  ''',
    };
    await repository.init(table);

    StockHandlerInterface stockHandlerInterface = StockHandlerImpl(
      repository: repository,
      fileStorageRepository: fileStorageRepository,
    );
    _getIt.registerSingleton<StockHandlerInterface>(stockHandlerInterface);
  }

  Future<void> initSetllingHandler(
    DatabaseRepository<SoldItem> repository,
    FileStorageRepo fileStorageRepository,
  ) async {
    var table = {
      'sell_items_table': '''
    CREATE TABLE sell_items_table (
      id TEXT PRIMARY KEY,
      title TEXT,
      description TEXT,
      buyPrice REAL,
      sellPrice REAL,
      idSoldItem TEXT,
      category TEXT,
      imageList TEXT,
      idSupplier TEXT,
      barcodeArticel TEXT,
      barcodeSupplier TEXT,
      quantity INTEGER,
      quantitySold INTEGER,
      sellPriceReal REAL,
      sellDate TEXT,
      customerId TEXT 
    )
    ''',
    };

    await repository.init(table);

    SellHandlerInterface sellHandlerImpl = SellHandlerImpl(
      repository: repository,
      fileStorageRepository: fileStorageRepository,
    );
    await sellHandlerImpl.init(repository);
    _getIt.registerSingleton<SellHandlerInterface>(sellHandlerImpl);
  }

  Future<void> initAnalyticsService({
    required SellHandlerInterface sellHandlerInterface,
    required StockHandlerInterface stockHandlerInterface,
  }) async {
    _getIt.registerSingleton<AnalyticsService>(
      AnalyticsServiceImpl(
        sellHandlerInterface: sellHandlerInterface,
        stockHandlerInterface: stockHandlerInterface,
      ),
    );
  }
}
