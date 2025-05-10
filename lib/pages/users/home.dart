import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/model/categories.dart';
import 'package:movieapp/pages/users/details_ui.dart';
import 'package:movieapp/services/firebase/database.dart';
import 'package:movieapp/services/locals/shared_preference.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, id, image, email;

  getTheSharedpreference() async {
    name = await SharedPrefercenceHelper().getUserName();
    id = await SharedPrefercenceHelper().getUserId();
    image = await SharedPrefercenceHelper().getUserImage();
    email = await SharedPrefercenceHelper().getUserEmail();
    setState(() {});
  }

  int _currentIndex = 0;
  int _selectedCategoryIndex = 0; // Default to first category selected
  Stream? moviesItemStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Define colors
  static const grey = Color(0xFF373741);
  static const buttonColor = Color(0xFFffb43b);

  // Method to update the movies stream based on selected category
  void updateMoviesStream(String category) async {
    moviesItemStream = await DatabaseService().getMoviesItem(category);
    setState(() {});
  }

  // Method to filter movies based on search query
  List<DocumentSnapshot> filterMovies(List<DocumentSnapshot> movies) {
    if (_searchQuery.isEmpty) return movies;

    return movies.where((movie) {
      final name = movie['name'].toString().toLowerCase();
      final category = movie['category'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getTheSharedpreference();
    updateMoviesStream(categories[0].name);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget allMovies() {
    return StreamBuilder(
      stream: moviesItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        // Handle loading and error states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
            child: Text(
              'No movies found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Filter movies based on search query
        final filteredMovies = filterMovies(snapshot.data.docs);

        if (filteredMovies.isEmpty) {
          return const Center(
            child: Text(
              'No movies found matching your search',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: filteredMovies.length,
              options: CarouselOptions(
                height: 300,
                viewportFraction: 0.6,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 3),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                DocumentSnapshot ds = filteredMovies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreenUi(
                          name: ds['name'],
                          image: ds['Image'],
                          category: ds['category'],
                          details: ds['details'],
                          price: ds['price'],
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'movie_${ds['name']}',
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.network(
                              ds['Image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      ds['category'],
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                filteredMovies.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 15),
                  width: _currentIndex == index ? 30 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color:
                        _currentIndex == index ? buttonColor : Colors.white24,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title:Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name == null ? 'Loading...' : 'Welcome, $name', // ✅ Safe
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.white54,
                ),
              ),
              if (name != null) // Only show wave if name is loaded
                Image.asset('assets/images/wave.png',
                    height: 20, width: 20, fit: BoxFit.cover),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Time to relax and reserve for Movie night!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      if (image != null) // Only show image if loaded
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.network(
            image!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
    ],
  ),
),
      ),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white10.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search movies...',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Category',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120, // Increased from 100 to 120
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                              updateMoviesStream(categories[index].name);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Added this line
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: _selectedCategoryIndex == index
                                        ? buttonColor
                                        : Colors.white10.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: _selectedCategoryIndex == index
                                        ? Border.all(
                                            color: buttonColor, width: 2)
                                        : null,
                                  ),
                                  child: Image.asset(
                                    categories[index].emoji,
                                    fit: BoxFit.cover,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                const SizedBox(
                                    height: 5), // Reduced from 10 to 5
                                Text(
                                  categories[index].name,
                                  style: TextStyle(
                                    fontSize: 12, // Reduced from 14 to 12
                                    color: _selectedCategoryIndex == index
                                        ? buttonColor
                                        : Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: 350,
                    child: allMovies(),
                  ),
                ],
              ),
            ),
    );
  }
}
