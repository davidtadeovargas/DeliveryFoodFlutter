import 'UserRepository.dart';
import 'AddressRepository.dart';
import 'CartRepository.dart';
import 'CategoryRepository.dart';
import 'ComandaRepository.dart';
import 'CreditCardRepository.dart';
import 'CuisineRepository.dart';
import 'FaqRepository.dart';
import 'FilterRepository.dart';
import 'FoodRepository.dart';
import 'GalleryRepository.dart';
import 'NotificationRepository.dart';
import 'OrderRepository.dart';
import 'RestaurantRepository.dart';
import 'SearchRepository.dart';
import 'SettingsRepository.dart';
import 'PaymentMethodRepository.dart';

class RepositoryManager{

  static UserRepository UserRepository_ = UserRepository();
  static SettingsRepository SettingsRepository_ = SettingsRepository();
  static FoodRepository FoodRepository_ = FoodRepository();
  static CartRepository CartRepository_ = CartRepository();
  static OrderRepository OrderRepository_ = OrderRepository();
  static CategoryRepository CategoryRepository_ = CategoryRepository();
  static NotificationRepository NotificationRepository_ = NotificationRepository();
  static RestaurantRepository RestaurantRepository_ = RestaurantRepository();
  static CuisineRepository CuisineRepository_ = CuisineRepository();
  static FaqRepository FaqRepository_ = FaqRepository();
  static SearchRepository SearchRepository_ = SearchRepository();
  static GalleryRepository GalleryRepository_ = GalleryRepository();
  static ComandaRepository ComandaRepository_ = ComandaRepository();
  static FilterRepository FilterRepository_ = FilterRepository();
  static PaymentMethodRepository PaymentMethodRepository_ = PaymentMethodRepository();
  static AddressRepository AddressRepository_ = AddressRepository();
  static CreditCardRepository CreditCardRepository_ = CreditCardRepository();
}