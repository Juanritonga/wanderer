import 'package:dartz/dartz.dart';
import 'package:wanderer/domain/entities/order.dart';

abstract class OrderRepos {
  Future<Either<String, String>> makeOrder(OrderData order);
  Future<Either<String, List<OrderData>>> getOrderDataByStatus(
      String adminId, String status);
}
