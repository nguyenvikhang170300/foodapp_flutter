import 'package:foodapp/pages/admin/home_admin.dart';
import 'package:foodapp/services/database/databasemethod.dart';
import 'package:foodapp/widgets/widget_support.dart';
import 'package:foodapp/widgets/notificationbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Stream? hoaDonStream;

  ontheload() async {
    hoaDonStream = await DatabaseMethods().getAllHoaDonStream();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tất cả hóa đơn người dùng",
          style: AppWidget.boldTextFeildStyle(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => HomeAdmin(),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: hoaDonStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return snapshot.hasData
              ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                print(ds);
                //chuyển đổi giá trị tiền tệ
                final locale = 'vi_VN';
                final formatter =
                NumberFormat.currency(name: "đ", locale: locale);
                formatter.maximumFractionDigits = 0;
                String price = formatter.format(ds["totalAmount"]);
                //ngày giờ
                Timestamp timestamp =
                ds["createdAt"]; // Lấy từ Firebase hoặc nguồn khác
                int timestamps = timestamp.seconds;
                final dateTime =
                DateTime.fromMillisecondsSinceEpoch(timestamps * 1000);
                final formatters = DateFormat('dd/MM/yyyy HH:mm:ss');
                final formattedDate = formatters.format(dateTime);

                //liên kết nhiều tên sản phẩm
                StringBuffer productName = StringBuffer();
                String productDes = "";
                String productCategory = "";
                List<dynamic> products = ds['products'] as List<dynamic>;
                for (var product in products) {
                  productName.write('${product['productName']}, ');
                  productDes = product['productDescription'];
                  productCategory = product['productCategory'];
                  // Hiển thị thông tin sản phẩm lên giao diện
                  print('Tên sản phẩm: $productName');
                  print('Mô tả sản phẩm: $productDes');
                  print('Danh mục: $productCategory');
                }
                String allProductNames = productName.toString();
                // Loại bỏ dấu phẩy thừa ở cuối chuỗi
                allProductNames = allProductNames.substring(
                    0, allProductNames.length - 2);
                print('Các sản phẩm: $allProductNames');

                return Container(
                  margin: EdgeInsets.all(10),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bill header (optional)
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hóa đơn",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Add a logo or store name here (optional)
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text("Mã Hóa đơn:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(ds["maHD"],
                                  style: TextStyle(fontSize: 14.0)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Product details
                          Row(
                            children: [
                              Text("Các sản phẩm:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(allProductNames,
                                  style: TextStyle(fontSize: 14.0)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("Danh mục:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(productCategory,
                                  style: TextStyle(fontSize: 14.0)),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text("Giá:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(price,
                                  style: AppWidget.billTextFeildStyle()),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text("Số lượng:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(ds["soluongdadat"].toString(),
                                  style: AppWidget.billTextFeildStyle()),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text("Thời gian đặt hàng:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(formattedDate.toString(),
                                  style: AppWidget.billTextFeildStyle()),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          // Customer details
                          Text("Thông tin khách hàng:",
                              style: AppWidget.boldTextFeildStyle()),
                          Text("Người mua: " + ds["nameNM"].toString(),
                              style: AppWidget.userTextFeildStyle()),
                          Text("Email: " + ds["emailNM"].toString(),
                              style: AppWidget.userTextFeildStyle()),
                          Text("SĐT: " + ds["sdtNM"].toString(),
                              style: AppWidget.userTextFeildStyle()),
                          Text("Địa chỉ: " + ds["addressNM"].toString(),
                              style: AppWidget.userTextFeildStyle()),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text("Trạng thái:",
                                  style: AppWidget.boldTextFeildStyle()),
                              Text(
                                ds["status"],
                                style: TextStyle(
                                  color: ds['status'] == 'chưa thanh toán'
                                      ? Colors.black
                                      : ds['status'] == 'đã thanh toán'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          // Order status
                        ],
                      ),
                    ),
                  ),
                );
              })
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
