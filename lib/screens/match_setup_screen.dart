import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/match_state.dart';
import '../widgets/app_drawer.dart';
import 'toss_screen.dart';

class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  final _team1Controller = TextEditingController();
  final _team2Controller = TextEditingController();
  late final TextEditingController _oversController;
  int _selectedPlayers = 11;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with a temporary value - we'll update it in didChangeDependencies
    _oversController = TextEditingController(text: '20');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final defaultOvers = Provider.of<MatchState>(context).defaultOvers;
      // Update the controller text with the actual default overs
      _oversController.text = defaultOvers.toString();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    _oversController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Koto?'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF181818),
              Color(0xFF121212),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Setup A New Cricket Match',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.sports_cricket,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Team Details',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _team1Controller,
                      decoration: InputDecoration(
                        labelText: 'Team 1 Name',
                        prefixIcon: Icon(
                          Icons.group,
                          color: Colors.grey[500],
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _team2Controller,
                      decoration: InputDecoration(
                        labelText: 'Team 2 Name',
                        prefixIcon: Icon(
                          Icons.group,
                          color: Colors.grey[500],
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Match Format',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _oversController,
                      decoration: InputDecoration(
                        labelText: 'Number of Overs',
                        hintText: 'Enter number of overs (1-50)',
                        prefixIcon: Icon(
                          Icons.timer,
                          color: Colors.grey[500],
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedPlayers,
                      dropdownColor: Color(0xFF333333),
                      decoration: InputDecoration(
                        labelText: 'Players per Team',
                        prefixIcon: Icon(
                          Icons.people,
                          color: Colors.grey[500],
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
                          .map((players) => DropdownMenuItem(
                                value: players,
                                child: Text('$players Players'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPlayers = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 12.0), // Increased vertical padding
          decoration: BoxDecoration(
            color: Color(0xFF212121),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              if (_team1Controller.text.isEmpty ||
                  _team2Controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter both team names'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              final overs = int.tryParse(_oversController.text);
              if (overs == null || overs < 1 || overs > 50) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Please enter a valid number of overs (1-50)'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              final matchState = context.read<MatchState>();

              // Reset any previous match data
              matchState.resetMatch();

              matchState.setTeamNames(
                _team1Controller.text,
                _team2Controller.text,
              );
              matchState.setMatchConfig(overs, _selectedPlayers);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TossScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 20), // Increased padding
              minimumSize: Size(double.infinity, 60), // Set minimum height
              textStyle: TextStyle(
                fontSize: 18, // Increased font size
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('START MATCH'),
                SizedBox(width: 12), // Increased spacing
                Icon(
                  Icons.play_circle_filled,
                  size: 28, // Increased icon size
                  color: Colors
                      .white, // Make icon explicitly white for better visibility
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
