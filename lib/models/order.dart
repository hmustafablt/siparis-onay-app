import 'package:get/get.dart'; // GetX kütüphanesi import edildi

class Order {
  // Reaktif özellikler için Rx<Type> kullanıldı
  // .obs ekleyerek bu özelliklerin gözlemlenebilir (observable) olmasını sağlıyoruz.
  final String id;
  final RxString customer;
  final RxDouble totalAmount;
  final RxString status;

  Order({
    required this.id,
    required String customer, // Başlangıç değeri String olarak alınır
    required double totalAmount, // Başlangıç değeri double olarak alınır
    required String status, // Başlangıç değeri String olarak alınır
  }) : customer = customer.obs, // .obs ile reaktif hale getirildi
       totalAmount = totalAmount.obs, // .obs ile reaktif hale getirildi
       status = status.obs; // .obs ile reaktif hale getirildi

  // Eğer Order nesnesini bir Map'ten oluşturmanız gerekiyorsa (örneğin Firebase'den veri çekerken)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customer: json['customer'] as String,
      totalAmount: (json['totalAmount'] as num)
          .toDouble(), // num'dan double'a dönüştür
      status: json['status'] as String,
    );
  }

  // Eğer Order nesnesini bir Map'e dönüştürmeniz gerekiyorsa (örneğin Firebase'e veri kaydederken)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer.value, // Reaktif değerin kendisini alıyoruz
      'totalAmount': totalAmount.value, // Reaktif değerin kendisini alıyoruz
      'status': status.value, // Reaktif değerin kendisini alıyoruz
    };
  }

  // Sipariş durumunu güncellemek için bir örnek metod
  void updateStatus(String newStatus) {
    status.value = newStatus; // Reaktif özelliği güncelliyoruz
  }

  // Müşteri adını güncellemek için bir örnek metod
  void updateCustomer(String newCustomer) {
    customer.value = newCustomer;
  }

  // Toplam tutarı güncellemek için bir örnek metod
  void updateTotalAmount(double newAmount) {
    totalAmount.value = newAmount;
  }
}
