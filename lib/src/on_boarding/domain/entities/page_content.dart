import 'package:afrosine/core/resources/media_resources.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.backgroundImage,
    required this.foregroundImage,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
          backgroundImage: MediaRes.onBoardingBackground,
          foregroundImage: MediaRes.onBoardingImage1,
          title: 'Explore Diverse Recipes',
          description:
              'Find recipes for breakfast, lunch, and dinner, all inspired by African cuisine',
        );

  const PageContent.second()
      : this(
          backgroundImage: MediaRes.onBoardingBackground,
          foregroundImage: MediaRes.onBoardingImage2,
          title: 'Save Your Favorites',
          description:
              'Discover important tips and tricks to help you prepare delicious meals with ease',
        );

  const PageContent.third()
      : this(
            backgroundImage: MediaRes.onBoardingBackground,
            foregroundImage: MediaRes.onBoardingImage3,
            title: 'Essential Cooking Tips',
            description:
                'Easily save and access your favorite recipes for quick reference');
  final String backgroundImage;
  final String foregroundImage;
  final String title;
  final String description;

  @override
  List<Object?> get props =>
      [backgroundImage, foregroundImage, title, description];
}
