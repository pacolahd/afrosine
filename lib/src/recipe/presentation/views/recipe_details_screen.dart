import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/recipe.jpeg',
                    height: 250,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredients for egusi soup',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Ground egusi (melon seeds)\n'
                      '• Assorted meats or fish\n'
                      '• Leafy vegetables (e.g., spinach, bitter leaf)\n'
                      '• Palm oil\n'
                      '• Onions, tomatoes, and peppers\n'
                      '• Seasonings (salt, pepper, bouillon)\n'
                      '• Garri (cassava flour)\n'
                      '• Hot water\n',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Preparation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Cook the meats or fish until tender.\n'
                      '2. Sauté onions, tomatoes, and peppers in palm oil.\n'
                      '3. Add ground egusi and cook until fragrant.\n'
                      '4. Add water and bring to a boil. Simmer until soup thickens.\n'
                      '5. Add vegetables and cook until tender.\n'
                      '6. Serve with garri, pounded yam, or rice.\n',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
