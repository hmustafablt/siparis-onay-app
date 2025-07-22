import 'package:flutter/material.dart'; // Material Design widget'ları için
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../models/order.dart'; // Order modelini import et
import '../controllers/order_detail_controller.dart'; // OrderDetailController'ı import et

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // OrderDetailController'ı bul. Binding kullanıldığı için Get.find() daha uygundur.
    final OrderDetailsController controller =
        Get.find<OrderDetailsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Detayı'),
        backgroundColor: Colors.indigo, // AppBar rengi
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Obx(() {
                // Controller'daki reaktif order nesnesini dinliyoruz
                if (controller.order.value == null) {
                  // Sipariş yüklenirken veya bulunamazsa bir yüklenme göstergesi veya hata mesajı
                  return const Center(child: CircularProgressIndicator());
                }
                final order = controller
                    .order
                    .value!; // Nullable olduğu için ! ile erişim

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle('Müşteri'),
                    _buildValue(
                      order.customer.value,
                    ), // Düzeltme: .value eklendi
                    const SizedBox(height: 16),

                    _buildTitle('Sipariş No'),
                    _buildValue(order.id), // ID zaten reaktif değil, doğru
                    const SizedBox(height: 16),

                    _buildTitle('Toplam Tutar'),
                    _buildValue(
                      '${order.totalAmount.value} ₺',
                    ), // Düzeltme: .value eklendi
                    const SizedBox(height: 40),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller
                                .approveOrder, // Controller metodunu çağır
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Material renk
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Onayla',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller
                                .cancelOrder, // Controller metodunu çağır
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Material renk
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'İptal Et',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Yardımcı widget metotları (UI katmanında kalabilir)
  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey, // Material renk
      ),
    );
  }

  Widget _buildValue(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Material renk
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(value, style: const TextStyle(fontSize: 18)),
    );
  }
}
