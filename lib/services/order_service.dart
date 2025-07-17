import 'package:get/get.dart'; // GetX kütüphanesini import et
import '../models/order.dart'; // Order modelini import et

// OrderRepository'yi bir GetxService olarak tanımlıyoruz.
// Bu, uygulamanız boyunca tek bir instance'ı olmasını ve GetX'in bağımlılık enjeksiyonu ile erişilebilmesini sağlar.
class OrderRepository extends GetxService {
  // Tüm siparişleri tutan ana reaktif liste.
  // Başlangıçta boş olacak ve asenkron olarak yüklenecek.
  final RxList<Order> _allOrders =
      <Order>[].obs; // .obs ile bu listeyi reaktif hale getiriyoruz.

  // Durumlarına göre filtrelenmiş reaktif sipariş listeleri.
  final RxList<Order> pendingOrders = <Order>[].obs;
  final RxList<Order> approvedOrders = <Order>[].obs;
  final RxList<Order> canceledOrders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    // _allOrders listesindeki değişiklikleri dinle ve filtrelenmiş listeleri güncelle.
    // _allOrders listesine bir eleman eklendiğinde veya çıkarıldığında _filterOrders çağrılır.
    // Ancak, _allOrders içindeki bir Order nesnesinin status'u değiştiğinde
    // _allOrders listesi kendisi değişmediği için bu dinleyici tetiklenmez.
    // Bu yüzden approve/cancel/revert metotlarında _filterOrders'ı manuel olarak çağıracağız.
    ever(_allOrders, (_) => _filterOrders());

    // Başlangıçta siparişleri yükle
    _loadInitialOrders();
  }

  // Simüle edilmiş asenkron sipariş yükleme metodu
  Future<void> _loadInitialOrders() async {
    print('OrderRepository: Siparişler yükleniyor...');
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simülasyon için gecikme

    // Simüle edilmiş verilerle _allOrders'ı doldur
    final List<Order> fetchedOrders = [
      Order(
        id: 'S001',
        customer: 'Ahmet Tekstil',
        totalAmount: 12500,
        status: 'pending',
      ),
      Order(
        id: 'S002',
        customer: 'Bora Giyim',
        totalAmount: 8200,
        status: 'approved',
      ),
      Order(
        id: 'S003',
        customer: 'Mavi Moda',
        totalAmount: 9700,
        status: 'pending',
      ),
      Order(
        id: 'S004',
        customer: 'Yeşil Ticaret',
        totalAmount: 5000,
        status: 'canceled',
      ),
      Order(
        id: 'S005',
        customer: 'Kırmızı Sanayi',
        totalAmount: 15000,
        status: 'pending',
      ),
    ];
    _allOrders.assignAll(fetchedOrders); // _allOrders listesini güncelledik
    print('OrderRepository: Siparişler yüklendi. Toplam: ${_allOrders.length}');
    // _filterOrders() onInit'te otomatik çağrılacak veya _allOrders değişince ever ile tetiklenecek.
  }

  // Siparişleri durumlarına göre filtreleyen ve ilgili RxList'leri güncelleyen metod.
  void _filterOrders() {
    pendingOrders.assignAll(
      _allOrders.where((o) => o.status.value == 'pending').toList(),
    );
    approvedOrders.assignAll(
      _allOrders.where((o) => o.status.value == 'approved').toList(),
    );
    canceledOrders.assignAll(
      _allOrders.where((o) => o.status.value == 'canceled').toList(),
    );
    print(
      'Siparişler filtrelendi. Bekleyen: ${pendingOrders.length}, Onaylı: ${approvedOrders.length}, İptal Edilen: ${canceledOrders.length}',
    );
  }

  // Siparişi onaylama
  void approveOrder(Order order) {
    // _allOrders içindeki ilgili siparişin durumunu güncelle.
    // Order modelindeki status zaten reaktif olduğu için, .value ile güncelliyoruz.
    final index = _allOrders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _allOrders[index].status.value = 'approved';
      _filterOrders(); // Filtrelenmiş listeleri güncelle
    }
  }

  // Siparişi iptal etme
  void cancelOrder(Order order) {
    final index = _allOrders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      // Orijinal mantığınızda sipariş _orders'dan kaldırılıp canceledOrders'a ekleniyordu.
      // GetX ile daha tutarlı bir yaklaşım, siparişi _allOrders'dan silmek yerine
      // sadece durumunu 'canceled' olarak işaretlemektir.
      // Böylece _allOrders her zaman tüm siparişleri içerir ve filtrelenmiş listeler doğru çalışır.
      _allOrders[index].status.value = 'canceled';
      _filterOrders(); // Filtrelenmiş listeleri güncelle
    }
  }

  // Siparişi bekleyen duruma geri alma
  void revertOrderToPending(Order order) {
    final index = _allOrders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _allOrders[index].status.value = 'pending';
      _filterOrders(); // Filtrelenmiş listeleri güncelle
    } else {
      // Eğer sipariş _allOrders içinde yoksa (örneğin tamamen silinmişse),
      // yeni bir Order nesnesi oluşturup _allOrders'a ekle.
      // Bu, `cancelOrder` metodunuzun `_allOrders`'dan silme yapmadığı varsayımına dayanır.
      // Eğer `cancelOrder` _allOrders'dan siliyorsa, bu kısım doğru.
      final newOrder = Order(
        id: order.id,
        customer: order.customer.value,
        totalAmount: order.totalAmount.value,
        status: 'pending',
      );
      _allOrders.add(newOrder);
      _filterOrders(); // Filtrelenmiş listeleri güncelle
    }
  }

  // Yeni sipariş ekleme (örnek bir metod)
  void addOrder(Order newOrder) {
    _allOrders.add(newOrder); // _allOrders'a ekle
    _filterOrders(); // Filtrelenmiş listeleri güncelle
  }

  // Siparişi ID'ye göre bulma metodu
  Order? findOrderById(String id) {
    return _allOrders.firstWhereOrNull((order) => order.id == id);
  }
}
