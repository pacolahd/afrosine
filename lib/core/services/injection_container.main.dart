part of 'injection_container.dart';

// This is the main file for the dependency injection container.
// when the GetIt.instance is called, the app will look for the import in the injection_container.dart file
// and then execute the code in the file thereby importing all the dependencies in the file.

// In other files, we import only the injection_container.dart file and not the injection_container.main.dart file

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
  await _initRecipe();
}

Future<void> _initAuth() async {
  // Feature --> Auth
  // Business Logic

  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initRecipe() async {
  // Feature --> Recipe
  // Business Logic

  // Initialize SQLite database
  // final database = await openDatabase(
  //   join(await getDatabasesPath(), 'recipe_database.db'),
  //   onCreate: (db, version) {
  //     return db.execute(
  //       '''
  //       CREATE TABLE recipes(
  //         id TEXT PRIMARY KEY,
  //         name TEXT,
  //         description TEXT,
  //         imageUrl TEXT,
  //         ingredients TEXT,
  //         instructions TEXT,
  //         cuisine TEXT,
  //         dishType TEXT,
  //         preparationMethod TEXT,
  //         spiceLevel TEXT,
  //         servingSize TEXT,
  //         mealTypes TEXT,
  //         rating REAL,
  //         ratingCount INTEGER,
  //         feedback TEXT,
  //         isFavorite INTEGER
  //       )
  //       ''',
  //     );
  //   },
  //   version: 1,
  //   readOnly: false,
  // );

  final databaseHelper = DatabaseHelper();

  sl
    ..registerLazySingleton(() => databaseHelper)
    ..registerFactory(() => RecipeBloc(
          getRecipes: sl(),
          getRecipeById: sl(),
          toggleFavoriteRecipe: sl(),
          getFavoriteRecipeIds: sl(),
          addFeedback: sl(),
          getRecipeFeedback: sl(),
          searchRecipes: sl(),
          filterRecipes: sl(),
          generateRecipe: sl(),
        ))
    ..registerLazySingleton(() => GenerateRecipe(sl()))
    ..registerLazySingleton(() => GetRecipes(sl()))
    ..registerLazySingleton(() => GetRecipeById(sl()))
    ..registerLazySingleton(() => ToggleFavoriteRecipe(sl()))
    ..registerLazySingleton(() => GetFavoriteRecipeIds(sl()))
    ..registerLazySingleton(() => AddFeedback(sl()))
    ..registerLazySingleton(() => GetRecipeFeedback(sl()))
    ..registerLazySingleton(() => SearchRecipes(sl()))
    ..registerLazySingleton(() => FilterRecipes(sl()))
    ..registerLazySingleton<RecipeRepository>(() => RecipeRepoImpl(sl()))
    ..registerLazySingleton<RecipeRemoteDataSource>(
      () => RecipeRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
        geminiAIService: sl(),
      ),
    )
    ..registerLazySingleton(() => GeminiAIService(apiKey: geminiApiKey));

  // ..registerLazySingleton<Database>(() => database);
}

Future<void> _initOnBoarding() async {
  // We await for the shared prefs to load before we inject any other dependencies.
  // We want only 1 shared prefs instance to be created and used throughout the app
  final prefs = await SharedPreferences.getInstance();
  // Feature --> OnBoarding
  // Business Logic

  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSrcImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}
