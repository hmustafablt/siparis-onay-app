import 'package:flutter/material.dart'; // Material Design widget'ları için
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../controllers/order_detail_controller.dart'; // OrderDetailController'ı import et

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // OrderDetailController'ı bul veya oluştur.
    // Binding kullanıldığı için Get.find() de kullanılabilir, ancak Get.put() daha geneldir.
    // Eğer binding'i main.dart'ta tanımladıysak Get.find() daha uygun olur.
    // Bu örnekte binding'i kullandığımız için Get.find() kullanacağız.
    final OrderDetailController controller = Get.find<OrderDetailController>();

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
              child: Obx(
                () => Column(
                  // Obx ile tüm Column'u sarmalayarak reaktif güncellemeleri sağlarız
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle('Müşteri'),
                    _buildValue(
                      controller.order.customer.value,
                    ), // Reaktif değere erişim
                    const SizedBox(height: 16),

                    _buildTitle('Sipariş No'),
                    _buildValue(controller.order.id), // ID zaten reaktif değil
                    const SizedBox(height: 16),

                    _buildTitle('Toplam Tutar'),
                    _buildValue(
                      '${controller.order.totalAmount.value} ₺',
                    ), // Reaktif değere erişim
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
                ),
              ),
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
