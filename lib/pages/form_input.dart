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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaProjectController;
  late TextEditingController dateProjectController;
  late TextEditingController labaProjectController;

  TransactionType _selectedType = TransactionType.income;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    namaProjectController = TextEditingController(
      text: widget.input.namaProject,
    );
    dateProjectController = TextEditingController(
      text: widget.input.dateProject,
    );
    labaProjectController = TextEditingController(
      text:
          widget.input.labaProject != null
              ? widget.input.labaProject.toString()
              : '',
    );
    _selectedType =
        widget.input.type == 'outcome'
            ? TransactionType.outcome
            : TransactionType.income;
  }

  Future<void> _input() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final data = ModelInput(
        id: widget.input.id,
        namaProject: namaProjectController.text.trim(),
        dateProject: dateProjectController.text.trim(),
        labaProject:
            labaProjectController.text.trim().isEmpty
                ? null
                : int.tryParse(
                  labaProjectController.text.trim().replaceAll('.', ''),
                ),

        type: _selectedType == TransactionType.income ? 'income' : 'outcome',
      );

      if (widget.input.id == null) {
        await DBInput().insertInput(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Input data successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await DBInput.updateInput(data);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Edit data successfully")));
      }

      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 72,
        iconTheme: const IconThemeData(color: Color(0xff1E88E5)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Transaction",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                _buildTextField(
                  controller: namaProjectController,
                  label: 'Name',
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: dateProjectController,
                  label: 'Date',
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      setState(() {
                        dateProjectController.text = formattedDate;
                      });
                    }
                  },
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: labaProjectController,
                  label: 'Salary',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRadio(TransactionType.income, 'Income'),
                    const SizedBox(width: 24),
                    _buildRadio(TransactionType.outcome, 'Outcome'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _input,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF118EE0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
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
          ),
        ),
      ),
    );
  }

  // Widget Helper TextFormField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0x20118EE0),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black38),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Widget Helper Radio Button
  Widget _buildRadio(TransactionType type, String title) {
    return Row(
      children: [
        Radio<TransactionType>(
          value: type,
          groupValue: _selectedType,
          onChanged: (value) => setState(() => _selectedType = value!),
        ),
        Text(title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
