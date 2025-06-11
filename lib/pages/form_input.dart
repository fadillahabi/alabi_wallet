import 'package:daily_financial_recording/database/db_input.dart';
import 'package:daily_financial_recording/model/model_input.dart';
import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final ModelInput input;
  const FormInput({super.key, required this.input});

  @override
  State<FormInput> createState() => _FormInputState();
}

enum TransactionType { income, outcome }

class _FormInputState extends State<FormInput> {
  TransactionType _selectedType = TransactionType.income;
  late TextEditingController namaProjectController;
  late TextEditingController dateProjectController;
  late TextEditingController labaProjectController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final data = ModelInput(
        id: widget.input.id,
        namaProject: namaProjectController.text.trim(),
        dateProject: dateProjectController.text.trim(),
        labaProject: int.tryParse(labaProjectController.text.trim()) ?? 0,
        type: _selectedType == TransactionType.income ? 'income' : 'outcome',
      );

      if (widget.input.id == null) {
        await DBInput().insertInput(data);
        Navigator.pop(context, true);
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Input data successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await DBInput.updateInput(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Data succesfully")),
        );
      }

      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    namaProjectController = TextEditingController(
      text: widget.input.namaProject,
    );
    dateProjectController = TextEditingController(
      text: widget.input.dateProject,
    );
    labaProjectController = TextEditingController(
      text: widget.input.labaProject.toString(),
    );
    _selectedType =
        widget.input.type == 'outcome'
            ? TransactionType.outcome
            : TransactionType.income;
    super.initState();
  }

  void update() async {
    final updated = ModelInput(
      id: widget.input.id,
      namaProject: namaProjectController.text,
      dateProject: dateProjectController.text,
      labaProject: int.tryParse(labaProjectController.text.trim()) ?? 0,
      type: _selectedType == TransactionType.income ? 'income' : 'outcome',
    );
    await DBInput.updateInput(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300]!,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 72,

        iconTheme: IconThemeData(color: Color(0xff1E88E5)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  "Add Transaction",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Column(
                  children: [
                    SizedBox(height: 28),
                    TextFormField(
                      controller: namaProjectController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x20118EE0),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // validator: (value) {
                      // },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: dateProjectController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x20118EE0),
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: labaProjectController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x20118EE0),
                        labelText: 'Salary',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio<TransactionType>(
                              value: TransactionType.income,
                              groupValue: _selectedType,
                              onChanged:
                                  (v) => setState(() => _selectedType = v!),
                            ),
                            const Text(
                              'Income',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(width: 24),
                        Row(
                          children: [
                            Radio<TransactionType>(
                              value: TransactionType.outcome,
                              groupValue: _selectedType,
                              onChanged:
                                  (v) => setState(() => _selectedType = v!),
                            ),
                            const Text(
                              'Outcome',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF118EE0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child:
                            _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
