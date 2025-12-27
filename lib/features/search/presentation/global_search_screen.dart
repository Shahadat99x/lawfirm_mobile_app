import 'package:flutter/material.dart';
import 'package:lexnova/shared/widgets/search_field.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(
                hintText: 'Search services, insights, team...',
                initialValue: _query,
                onChanged: (val) {
                  setState(() {
                    _query = val;
                  });
                },
                onClear: () {
                   setState(() {
                    _query = '';
                  });
                },
              ),
              const SizedBox(height: 24),
              // Filter options Placeholder
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    const SizedBox(width: 8),
                    _buildFilterChip('Services', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Insights', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Team', false),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              if (_query.isEmpty) ...[
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                 const SizedBox(height: 16),
                 const Text('No recent searches', style: TextStyle(color: Colors.grey)),
              ] else ...[
                 Expanded(
                   child: Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                          Icon(Icons.search, size: 48, color: Theme.of(context).colorScheme.outline),
                          const SizedBox(height: 16),
                          Text('Searching for "$_query"...', style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 8),
                          const Text('(Global search logic to be implemented)', style: TextStyle(color: Colors.grey)),
                       ],
                     ),
                   ),
                 ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {}, // No-op for now
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
      ),
      side: BorderSide(
        color: isSelected ? Colors.transparent : Theme.of(context).dividerColor.withOpacity(0.1),
      ),
    );
  }
}
