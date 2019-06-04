import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_store/blocs/cart_bloc/cart.dart';
import 'package:online_store/models_and_repos/cart_model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutDetails extends StatefulWidget {
  const CheckoutDetails({
    Key key,
    this.products,
    this.totalPrice,
    this.isDelivery,
  }) : super(key: key);

  final List<CartModel> products;
  final double totalPrice;
  final bool isDelivery;

  @override
  _CheckoutDetailsState createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<CartModel> get products => widget.products;

  Widget _buildOrderOverviewItem(CartModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            product.productName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 100,
          child: Text(
            '${product.checkoutCount} x ${product.price}',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  void _sendToDb() async {
    if (_formKey.currentState.validate()) {
      final productMaps =
          products.map((product) => CartModel.toMap(product)).toList();
      _showProgressIndicator().then((_) async {
        await FirebaseAuth.instance.signInAnonymously();
        await Firestore.instance.collection('delivery').add({
          'address': addressController.text,
          'city': cityController.text,
          'name': nameController.text,
          'phone': phoneController.text,
          'products': productMaps,
          'isDelivery': widget.isDelivery
        });
      }).then((_) {
        _showFinishAlert();
      }).catchError((onError) {
        _showErrorDialog();
      });
    }
  }

  Future _showProgressIndicator() async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future _showErrorDialog() async {
    Navigator.of(context).pop();
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Error'),
          content: const Text(
            'Order failed.\nPlease try again.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFinishAlert() async {
    Navigator.of(context).pop();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Thank You For Your Order'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Done'),
              onPressed: () {
                BlocProvider.of<CartBloc>(context)
                    .dispatch(CheckoutCompleted());
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _addressAndCity() {
    return widget.isDelivery
        ? [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                prefixIcon: const Icon(Icons.place),
                labelText: 'Address',
              ),
              validator: (address) {
                if (address.isEmpty) return 'Please enter an address';
              },
            ),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                prefixIcon: const Icon(Icons.location_city),
                labelText: 'City',
              ),
              validator: (city) {
                if (city.isEmpty) return 'Please enter a city';
              },
            )
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Checkout Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Name',
                ),
                validator: (name) {
                  if (name.isEmpty) return 'Please enter a name';
                },
              ),
              ..._addressAndCity(),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Phone',
                ),
                validator: (number) {
                  final RegExp phoneExp =
                      RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
                  if (!phoneExp.hasMatch(number))
                    return '(###) ###-#### - Enter a US phone number.';
                },
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  _UsNumberTextInputFormatter(),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('Order Overview'),
              ),
              Expanded(
                child: ListView.builder(
                  itemExtent: 25,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildOrderOverviewItem(product);
                  },
                ),
              ),
              Text(
                'Final Price: \$' + widget.totalPrice.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.done_outline),
        label: const Text('Complete'),
        onPressed: _sendToDb,
      ),
    );
  }
}

// Borrowed from Flutter demo app
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
