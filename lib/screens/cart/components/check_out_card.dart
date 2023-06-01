
import 'dart:io';
import 'dart:math';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/screens/cart/components/pdfPreviewscreen.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:pdf/widgets.dart' as pw;
import '../../../models/Product.dart';
import '../../../models/Produit.dart';
import '../../../models/commande_model.dart';
import '../../../models/invoice_pdf.dart';


import '../../../models/Livreur.dart';
import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({Key key}) : super(key: key);
  

  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}


  

class _CheckoutCardState extends State<CheckoutCard> {

   List quotes = [
        "fedox",
        "cpd",
        "vhl",
        "zps",
                ];
int _index = Random().nextInt(4);

  final Stream<QuerySnapshot> cartProducts = ProductDAO().getCartAmount();
  double amount = 0.0;
  List<Cart> carts = [];
  
  final CollectionReference livreurCollection =
      FirebaseFirestore.instance.collection('livreurs');
      
  
  List<Cart> Products = [];

  double Total = 0.0;
  double TotalTVA = 0.0;
  double Totalapayer = 0.0;
  double tva = 20;
  String numFacture;
  
  final PdfInvoiceService service = PdfInvoiceService();


  @override
  initState() {
    super.initState();
    loadData();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51K6WKhIgwaOpAFgPWJ1rpwYWc3Cz8Jpuqalw0ICzHvHmewANDPeZamvQkl1xMYemqlYBJyGweeA7k1ILx5c349Pb00yKzNS48L",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  loadData() async {
    dynamic results = await ProductDAO().getProductForCart();
    setState(() {
      carts = results;
    });
  }

  

  Future<void> openDialog(List<Cart> products) async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        children: [
          Container(
              height: 400,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                        'Votre commande a été validée. vous recevrez la livraison dans les délais'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child : DefaultButton(
                        text: "Ok", press: () => {Navigator.pop(context)}
                        // Navigator.pushNamed(context, HomeScreen.routeName),
                        ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child : DefaultButton(
                        text: "Facture", 
                        press: () async{
                            //Create a new PDF document
                             PdfDocument document = PdfDocument();

                            //Adds page settings
                            document.pageSettings.orientation = PdfPageOrientation.landscape;
                            document.pageSettings.margins.all = 50;

                            //Adds a page to the document
                            PdfPage page = document.pages.add();
                            PdfGraphics graphics = page.graphics;
                                
                            PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
                            Rect bounds = Rect.fromLTWH(0, 0, graphics.clientSize.width, 30);
                            //Rect bounds = Rect.fromLTWH(0, 160, 0, 30);

                            //Draws a rectangle to place the heading in that region
                            graphics.drawRectangle(brush: solidBrush, bounds: bounds);

                            //Creates a font for adding the heading in the page
                            PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);
                            DateTime now = DateTime.now();
                            String date = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                            String time =  DateFormat('kk:mm').format(now);
                            String datte = DateFormat('yyyy-MM-dd').format(now);
                            datte = datte.replaceAll(":", "");
                            datte = datte.replaceAll("-", "");
                            datte = datte.replaceAll(" ", "");
                            time = time.replaceAll(":", ""); 
                            numFacture =  "NF" + Random().nextInt(1000).toString() + datte + time;
                            numFacture = numFacture.replaceAll(" ", "");
                            //Creates a text element to add the invoice number
                            PdfTextElement element =
                                PdfTextElement(text: 'FACTURE : ' + numFacture, font: subHeadingFont);
                            element.brush = PdfBrushes.white;

                            //Draws the heading on the page
                            PdfLayoutResult result = element.draw(
                                page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))/*!*/;
                                  //page: page, bounds: Rect.fromLTWH(10, 0, 0, 0))/*!*/;
                            
                            //Use 'intl' package for date format.
                            String currentDate = 'DATE : ' + date;
                            

                            //Measures the width of the text to place it in the correct location
                            Size textSize = subHeadingFont.measureString(currentDate);
                            Offset textPosition = Offset(
                                graphics.clientSize.width - textSize.width - 10, result.bounds.top);

                            //Draws the date by using drawString method
                            graphics.drawString(currentDate, subHeadingFont,
                                brush: element.brush,
                                bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                                        result.bounds.top) &
                                    Size(textSize.width + 2, 20));

                            //Creates text elements to add the address and draw it to the page
                            element = PdfTextElement(
                                font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
                                    style: PdfFontStyle.bold));
                            element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
                            result = element.draw(
                                page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))/*!*/;

                            PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);

                            element = PdfTextElement(text: 'Adresse de facturation : 4 Avenue Laurent Cély 28AB Berlin', font: timesRoman);
                            element.brush = PdfBrushes.black;
                            result = element.draw(
                                page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))/*!*/;

                            element = PdfTextElement(
                                text: 'Adresse de livraison : 4 Avenue Laurent Cély 28AB Berlin', font: timesRoman);
                            element.brush = PdfBrushes.black;
                            result = element.draw(
                                page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))/*!*/;

                            element = PdfTextElement(
                                text: 'RCS : 3332955', font: timesRoman);
                            element.brush = PdfBrushes.black;
                            result = element.draw(
                                page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))/*!*/;

                            element = PdfTextElement(
                                text: 'Siret : 12345678900012', font: timesRoman);
                            element.brush = PdfBrushes.black;
                            result = element.draw(
                                page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))/*!*/;

                            //Draws a line at the bottom of the address
                            graphics.drawLine(
                                PdfPen(PdfColor(126, 151, 173), width: 0.7),
                                Offset(0, result.bounds.bottom + 3),
                                Offset(graphics.clientSize.width, result.bounds.bottom + 3));

                            //Creates a PDF grid
                            PdfGrid grid = PdfGrid();

                            //Add the columns to the grid
                            grid.columns.add(count: 4);

                            //Add header to the grid
                            grid.headers.add(1);

                            //Set values to the header cells
                            PdfGridRow header = grid.headers[0];
                            header.cells[0].value = 'Designation';
                            header.cells[1].value = 'Prix en euros';
                            header.cells[2].value = 'Quantité';
                            header.cells[3].value = 'Total en euros';

                            //Creates the header style
                            PdfGridCellStyle headerStyle = PdfGridCellStyle();
                            headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
                            headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
                            headerStyle.textBrush = PdfBrushes.white;
                            headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
                                style: PdfFontStyle.regular);

                            //Adds cell customizations
                            for (int i = 0; i < header.cells.count; i++) {
                              if (i == 0 || i == 1) {
                                header.cells[i].stringFormat = PdfStringFormat(
                                    alignment: PdfTextAlignment.left,
                                    lineAlignment: PdfVerticalAlignment.middle);
                              } else {
                                header.cells[i].stringFormat = PdfStringFormat(
                                    alignment: PdfTextAlignment.right,
                                    lineAlignment: PdfVerticalAlignment.middle);
                              }
                              header.cells[i].style = headerStyle;
                            }

                            //Add rows to grid
                            PdfGridRow row = grid.rows.add();
                            Total = 0.0;
                            TotalTVA = 0.0;
                            Totalapayer = 0.0;
                            for (int i = 0; i < products.length; i++) {
                                Product p = await ProductDAO().getProductById(products[i].productId);
                                row.cells[0].value = p.title;
                                row.cells[1].value = products[i].price.toString();
                                row.cells[2].value = products[i].quantity.toString();
                                row.cells[3].value = (products[i].quantity * products[i].price).toString();
                                Total = Total + products[i].quantity * products[i].price;
                                row = grid.rows.add();
                              }

                            TotalTVA = (Total*tva)/100;
                            Totalapayer = Total + TotalTVA; 

                           
                            //Set padding for grid cells
                            grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

                            //Creates the grid cell styles
                            PdfGridCellStyle cellStyle = PdfGridCellStyle();
                            cellStyle.borders.all = PdfPens.white;
                            cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
                            cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
                            cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
                            //Adds cell customizations
                            for (int i = 0; i < grid.rows.count; i++) {
                              PdfGridRow row = grid.rows[i];
                              for (int j = 0; j < row.cells.count; j++) {
                                row.cells[j].style = cellStyle;
                                if (j == 0 || j == 1) {
                                  row.cells[j].stringFormat = PdfStringFormat(
                                      alignment: PdfTextAlignment.left,
                                      lineAlignment: PdfVerticalAlignment.middle);
                                } else {
                                  row.cells[j].stringFormat = PdfStringFormat(
                                      alignment: PdfTextAlignment.right,
                                      lineAlignment: PdfVerticalAlignment.middle);
                                }
                              }
                            }

                            //Creates layout format settings to allow the table pagination
                            PdfLayoutFormat layoutFormat =
                                PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

                            //Draws the grid to the PDF page
                            PdfLayoutResult gridResult = grid.draw(
                                page: page,
                                bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
                                    graphics.clientSize.width, graphics.clientSize.height - 100),
                                format: layoutFormat)/*!*/;

                            gridResult.page.graphics.drawString(
                                'Grand Total en euros :                         $Total', subHeadingFont,
                                brush: PdfSolidBrush(PdfColor(126, 155, 203)),
                                bounds: Rect.fromLTWH(400, gridResult.bounds.bottom + 30, 0, 0));

                            gridResult.page.graphics.drawString(
                                'TVA 20% en euros :                            $TotalTVA', subHeadingFont,
                                brush: PdfSolidBrush(PdfColor(126, 155, 203)),
                                bounds: Rect.fromLTWH(400, gridResult.bounds.bottom + 60, 0, 0));

                            gridResult.page.graphics.drawString(
                                'Montant à Payer  en euros :                 $Totalapayer', subHeadingFont,
                                brush: PdfSolidBrush(PdfColor(126, 155, 203)),
                                bounds: Rect.fromLTWH(400, gridResult.bounds.bottom + 90, 0, 0));

                            
                            //Save the document
                            List<int> bytes = await document.save();

                            //Dispose the document
                            document.dispose();

                            //Get external storage directory
                            final directory = await getApplicationSupportDirectory();

                            //Get directory path
                            final path = directory.path;

                            //Create an empty file to write PDF data
                            File file = File('$path/Facture_'+ numFacture+'.pdf');

                            //Write PDF data
                            await file.writeAsBytes(bytes, flush: true);

                            //Open the PDF document in mobile
                            OpenFile.open('$path/Facture_'+ numFacture+'.pdf');
                        },
                        //press: () => {Navigator.pop(context)}
                        // Navigator.pushNamed(context, HomeScreen.routeName),
                        ),
                  )
                ]),
              ))
        ],
      ),
    )) {
      
    }
  }

  Future<void> checkout() async {
    // await ProductDAO().addToCommande();
    /// retrieve data from the backend
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) async {
        await ProductDAO().addToCommande(numFacture);
        
      carts.forEach((element)  {
        Products.add(element);
        ProductDAO().deletedFromCard(element.id);
      });
      openDialog(Products);
    }).catchError((error) => {print('$error')});
  }

  List<DropdownMenuItem<String>> list = [];
  String def;

  void menu() {
    print("herererererer");
    list.clear();
    livreurCollection.get().then((QuerySnapshot querySnapshot) => {
          if (querySnapshot != null)
            {
              querySnapshot.docs?.forEach((doc) {
                Livreur livreur = Livreur(id: doc.id, nom: doc['nom']);
                list.add(livreur as DropdownMenuItem<String>);
                print("data $livreur");
              })
            }
        });
    // print("data $list");
  }

  @override
  Widget build(BuildContext context) {
    // ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: true);
    return StreamBuilder<QuerySnapshot>(
        stream: cartProducts,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            amount = 0.0;
            snapshot.data.docs.forEach((element) {
              amount = element['price'] * element['quantity'] + amount;
            });
          }
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(30),
            ),
            // height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: getProportionateScreenWidth(40),
                        width: getProportionateScreenWidth(40),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      Spacer(),

                      Text.rich(
                        TextSpan(text: "Livreur:\n", children: [
                          TextSpan(
                            // onPressed: _showFate(),
                            text: quotes[_index],
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ]),
                      ),
                     
                      //   SizedBox(
                      //   width: getProportionateScreenWidth(100),
                      //   height: getProportionateScreenWidth(40),
                      //   child: DefaultButton(
                      //       text: "data ${livreurCollection.doc()}",
                            
                      //       press: () {
                      //         if (amount == 0.0) {
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //               SnackBar(
                      //                   content:
                      //                       Text('votre panier est vide')));
                      //         } else {
                      //           print("data ${livreurCollection.doc()}");
                      //         }
                      //       },
                      //       ),
                      // ),






                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(text: "Total:\n", children: [
                          TextSpan(
                            text: '\€ ${amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                            text: "Valider",
                            press: () {
                              if (amount == 0.0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('votre panier est vide')));
                              } else {
                                print("data ${livreurCollection.doc()}");
                                checkout();

                                //                           showDialog(context: context,
                                //                           builder: (context)=>AlertDialog(
                                //                             title: Text('Choisissez votre livreur'),
                                //                             content: SingleChildScrollView(
                                //                               scrollDirection: Axis.horizontal,
                                //                               child: DropdownButton(
                                //                               elevation: 10,
                                //                               items: list,
                                //                               hint : Text("Livreur"),
                                //                               //underline: SizedBox(),
                                //                               //iconSize: 0.0,
                                //                               onChanged: (value){

                                //                               },
                                // ),
                                //                             ),
                                //                             actions: [
                                //                               ElevatedButton(onPressed: (){
                                //                                 Navigator.pop(context, 'Annuler');
                                //                               }, child: Text('Annuler'))
                                //                             ],
                                //                           ));
                              }
                            },
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
