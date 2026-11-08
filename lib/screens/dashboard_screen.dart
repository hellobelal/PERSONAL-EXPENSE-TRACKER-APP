import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/common_widgets.dart';
import 'about_screen.dart';
import 'add_edit_transaction_screen.dart';
import 'transaction_details_screen.dart';
import 'transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> _transactions = [];
  bool _loading = true;

  double get _totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _balance => _totalIncome - _totalExpense;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getAllTransactions();
    if (!mounted) return;
    setState(() {
      _transactions = data;
      _loading = false;
    });
  }

  Future<void> _openAdd() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()),
    );
    if (changed == true) _load();
  }

  Future<void> _openDetails(TransactionModel t) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => TransactionDetailsScreen(transactionId: t.id!)),
    );
    _load(); // always refresh so summaries stay accurate
  }

  Future<void> _openAll() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionListScreen()),
    );
    _load();
  }

  Future<void> _delete(TransactionModel t) async {
    if (!await confirmDelete(context, t.title)) return;
    await DatabaseHelper.instance.deleteTransaction(t.id!);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Transaction deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final recent = _transactions.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/icon/app_logo.png',
                  width: 30, height: 30),
            ),
            const SizedBox(width: 10),
            const Text('Expense Tracker'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About App',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        tooltip: 'Add transaction',
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              label: 'Total Income',
                              amount: _totalIncome,
                              color: incomeColor,
                              icon: Icons.trending_up,
                            ),
                          ),
                          Expanded(
                            child: SummaryCard(
                              label: 'Total Expense',
                              amount: _totalExpense,
                              color: expenseColor,
                              icon: Icons.trending_down,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SummaryCard(
                          label: 'Current Balance',
                          amount: _balance,
                          color: _balance >= 0
                              ? Colors.indigo
                              : Colors.deepOrange,
                          icon: Icons.account_balance_wallet,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Transactions',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: _openAll, child: const Text('See all')),
                    ],
                  ),
                ),
                Expanded(
                  child: recent.isEmpty
                      ? const Center(
                          child: Text('No transactions yet.\nTap + to add one.',
                              textAlign: TextAlign.center))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: recent.length,
                          itemBuilder: (context, i) => TransactionTile(
                            transaction: recent[i],
                            onTap: () => _openDetails(recent[i]),
                            onDelete: () => _delete(recent[i]),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
