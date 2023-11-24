import 'package:flutter/material.dart';
import 'Broni.dart'; // Замените на ваш экран деталей ресторана
import 'Map.dart'; // Импорт GoogleMapsMarkerExample
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Улица Медерова, 116/4'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildRestaurantContainer(context, 'KAYNAR'),
            _buildRestaurantContainer(context, 'ZERNO'),
            _buildRestaurantContainer(context, 'Барашек'),
            _buildRestaurantContainer(context, 'FRUNZE'),
            _buildRestaurantContainer(context, 'Наша карта'),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantContainer(BuildContext context, String restaurantName) {
    return GestureDetector(
      onTap: () {
        if (restaurantName == 'Наша карта') {
          // Создаем маркеры для демонстрации
          List<Marker> markers = [
            const Marker(
              markerId: MarkerId('marker1'),
              position: LatLng(55.7558, 37.6173), // Координаты местоположения
              infoWindow: InfoWindow(
                title: 'Местоположение 1',
                snippet: 'Описание местоположения',
              ),
            ),
            // Добавьте дополнительные маркеры здесь
          ];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleMapsMarkerExample(markers: markers),
            ),
          );
        } else {
          // Обработка нажатия на другие элементы списка
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Broni()), // Ваш экран деталей ресторана
          );
        }
      },
      child: Container(
        width: 386,
        height: 100,
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: const Color.fromARGB(255, 135, 135, 135),
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurantName,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
