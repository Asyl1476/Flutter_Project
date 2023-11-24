import 'package:flutter/material.dart';
import 'package:flutter_qr/restaurants-screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Бронирование',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Broni(),
    );
  }
}

class Broni extends StatefulWidget {
  const Broni({Key? key}) : super(key: key);

  @override
  _BroniState createState() => _BroniState();
}

class _BroniState extends State<Broni> {
  int _guestCount = 1;

  Widget _buildGuestButton(int number) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _guestCount = number;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _guestCount == number ? Colors.purple : Colors.purple[700],
          borderRadius: BorderRadius.circular(8),
          border: _guestCount == number
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Text(
          '$number',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Бронирование'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Количество гостей',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<Widget>.generate(6, (index) => _buildGuestButton(index + 1)),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DateSelectionScreen(
                      guestCount: _guestCount,
                    ),
                  ),
                );
              },
              child: const Text('Продолжить', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Text(
            'Позвоните в ресторан, чтобы забронировать стол на большее количество гостей',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withAlpha(150)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DateSelectionScreen extends StatefulWidget {
  final int guestCount;

  const DateSelectionScreen({Key? key, required this.guestCount}) : super(key: key);

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _selectedDate;

  Widget _buildDateButton(DateTime date) {
    bool isSelected = _selectedDate != null && date.day == _selectedDate!.day;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.purple[700],
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Text(
          '${date.day}.${date.month}',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  List<Widget> _buildDateButtons() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List<Widget>.generate(7, (index) {
      DateTime date = startOfWeek.add(Duration(days: index));
      return _buildDateButton(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dateButtons = _buildDateButtons();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Выбор даты'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Количество гостей: ${widget.guestCount}',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dateButtons,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_selectedDate != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ConfirmationScreen(
                        guestCount: widget.guestCount,
                        bookingDate: _selectedDate!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Пожалуйста, выберите дату'),
                    ),
                  );
                }
              },
              child: const Text('Продолжить', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationScreen extends StatefulWidget {
  final int guestCount;
  final DateTime bookingDate;

  const ConfirmationScreen({
    Key? key,
    required this.guestCount,
    required this.bookingDate,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String? comment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтвердить бронирование'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.guestCount} гостя, ${widget.bookingDate.day}.${widget.bookingDate.month}.${widget.bookingDate.year}, Choose Time',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    onPressed: _showCommentDialog,
                    child: const Text(
                      'Добавить комментарий',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.purple, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const RestaurantsScreen()),
                  (Route<dynamic> route) => route.isFirst,
                  );
              },
              child: const Text(
                'Да, подтвердить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController commentController = TextEditingController();
        return AlertDialog(
          title: const Text('Комментарий к бронированию'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: "Введите ваш комментарий"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                setState(() {
                  comment = commentController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
