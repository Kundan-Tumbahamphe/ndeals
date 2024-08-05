import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndeals/src/constants/api_endpoints.dart';
import 'package:ndeals/src/exceptions/network_exception.dart';
import 'package:ndeals/src/features/deals/domain/deal.dart';
import 'package:ndeals/src/network/dio_config.dart';

class DealsRepository {
  final Dio _dio;

  const DealsRepository(this._dio);

  Future<List<Deal>> fetchAllDeals() async {
    try {
      final response = await _dio.get(ApiEndpoints.allDeals);

      final data = response.data as List<dynamic>;

      return data.map((e) => Deal.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch all deals: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  Future<List<Deal>> fetchTodaysDeals() async {
    try {
      final response = await _dio.get(ApiEndpoints.todayDeals);

      final data = response.data as List<dynamic>;

      return data.map((e) => Deal.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch today deals: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }
}

final dealsRepositoryProvider = Provider<DealsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DealsRepository(dio);
});

final allDealsFutureProvider = FutureProvider.autoDispose<List<Deal>>((ref) {
  final dealsRepository = ref.watch(dealsRepositoryProvider);
  return dealsRepository.fetchAllDeals();
});

final todayDealsFutureProvider = FutureProvider.autoDispose<List<Deal>>((ref) {
  final dealsRepository = ref.watch(dealsRepositoryProvider);
  return dealsRepository.fetchTodaysDeals();
});
