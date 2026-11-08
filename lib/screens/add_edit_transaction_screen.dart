import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/common_widgets.dart';

/// Used for both adding (transaction == null) and editing.
class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  static const List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Health',
    'Education',
    'Entertainment',
    'Salary',
    'Business',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String? _category;
  String? _type;
  DateTime _date = DateTime.now();
  bool _typeError = false;
  bool _saving = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    if (t != null) {
      _titleController.text = t.title;
      _amountController.text = t.amount.toString();
      _category = t.category;
      _type = t.type;
      _date = t.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final formValid = _formKey.currentState!.validate();
    setState(() => _typeError = _type == null);
    if (!formValid || _type == null) return;

    setState(() => _saving = true);
    final t = TransactionModel(
      id: widget.transaction?.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _category!,
      type: _type!,
      date: _date,
    );

    if (_isEditing) {
      await DatabaseHelper.instance.updateTransaction(t);
    } else {
      await DatabaseHelper.instance.insertTransaction(t);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      ..._categories,
      if (_category != null && !_categories.contains(_category)) _category!,
    ];

    return Scaffold(
      appBar: AppBar(
          title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title cannot be empty'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: (v) {
                  final value = double.tryParse((v ?? '').trim());
                  if (value == null ||
                      value <= 0 ||
                      value.isNaN ||
                      value.isInfinite) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v),
                validator: (v) => v == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              const Text('Transaction Type',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _typeChip(TransactionModel.income, incomeColor),
                  const SizedBox(width: 12),
                  _typeChip(TransactionModel.expense, expenseColor),
                ],
              ),
              if (_typeError)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text('Please select a transaction type',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12)),
                ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(formatDate(_date)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String type, Color color) {
    final selected = _type == type;
    return ChoiceChip(
      label: Text(type),
      selected: selected,
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
          color: selected ? color : null, fontWeight: FontWeight.w600),
      avatar: Icon(
          type == TransactionModel.income
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          size: 18,
          color: selected ? color : null),
      onSelected: (_) => setState(() {
        _type = type;
        _typeError = false;
      }),
    );
  }
}
