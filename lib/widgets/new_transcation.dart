import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransactionBut;

  NewTransaction(this.addTransactionBut);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitTransaction() {
    final enteredTitle = _titleController.text;
    final enteredAmount = int.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTransactionBut(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop(); //after submitting the modelbar gets closed
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                onSubmitted: (_) => _submitTransaction(),
                decoration: InputDecoration(
                  labelText: 'Title',
                ),

                /* onChanged: (value) {
                          titleInput = value;
                        }, */
              ), //title
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _submitTransaction(), //_ before means we dont use it
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),

                /* onChanged: (value) {
                          amountInput = value;
                        }, */
              ), //amount
              Container(
                height: 70,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMMMMd().format(_selectedDate)),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _datePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton.icon(
                color: Theme.of(context).accentColor,
                onPressed: _submitTransaction,
                icon: Icon(Icons.add),
                label: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
