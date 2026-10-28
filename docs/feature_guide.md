# Fullup — Feature Implementation Guide

Step-by-step guide for implementing a new feature in any Fullup app.

> **Code samples below predate the current conventions.** They show `@injectable`
> annotations; the apps register dependencies by hand in
> `lib/core/di/injection_container.dart`, use `Equatable` states with a status enum,
> throw plain exceptions, and mock at the data source. The steps and their order
> still apply. For the exact shape, copy `apps/delivery/lib/features/home/` and see
> `.claude/skills/fullup-conventions/SKILL.md`. To run the whole flow with agents:
> `/fullup-feature <app> <feature>` ([agent_workflow_guide.md §13](agent_workflow_guide.md#13-agentic-flow)).

---

## Before You Start

1. Identify which app the feature belongs to (`apps/corp`, `apps/individuals`, etc.)
2. Check if shared logic is needed in `packages/`
3. Check API documentation for endpoints
4. Check if similar features exist — follow the same patterns

---

## Step 1: Create Feature Folder

```
lib/features/[feature_name]/
├── data/
│   ├── datasources/
│   ├── dtos/
│   └── repositories/
├── domain/
│   ├── repositories/
│   └── usecases/
├── logic/
└── presentation/
    ├── pages/
    └── widgets/
```

---

## Step 2: Define DTOs (Data Layer)

```dart
// data/dtos/order_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'order_dto.g.dart';

@JsonSerializable()
class OrderDto {
  final int id;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'total_amount')
  final double totalAmount;

  const OrderDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}
```

---

## Step 3: Create Data Source

```dart
// data/datasources/order_remote_datasource.dart
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderRemoteDataSource {
  final ApiClient _apiClient;

  OrderRemoteDataSource(this._apiClient);

  Future<List<OrderDto>> getOrders() async {
    final response = await _apiClient.get('/orders');
    return (response.data['data'] as List)
        .map((e) => OrderDto.fromJson(e))
        .toList();
  }

  Future<OrderDto> getOrder(int id) async {
    final response = await _apiClient.get('/orders/$id');
    return OrderDto.fromJson(response.data['data']);
  }

  Future<OrderDto> createOrder(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/orders', data: data);
    return OrderDto.fromJson(response.data['data']);
  }
}
```

---

## Step 4: Define Domain Repository Interface

```dart
// domain/repositories/order_repository.dart
abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrder(int id);
  Future<OrderEntity> createOrder(CreateOrderParams params);
}
```

---

## Step 5: Implement Repository

```dart
// data/repositories/order_repository_impl.dart
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<OrderEntity>> getOrders() async {
    final dtos = await _remoteDataSource.getOrders();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<OrderEntity> getOrder(int id) async {
    final dto = await _remoteDataSource.getOrder(id);
    return dto.toEntity();
  }

  @override
  Future<OrderEntity> createOrder(CreateOrderParams params) async {
    final dto = await _remoteDataSource.createOrder(params.toJson());
    return dto.toEntity();
  }
}
```

---

## Step 6: Create Use Cases (Optional)

Use cases are optional for simple CRUD. Use them when business logic is involved.

```dart
// domain/usecases/get_orders.dart
import 'package:injectable/injectable.dart';

@injectable
class GetOrders {
  final OrderRepository _repository;

  GetOrders(this._repository);

  Future<List<OrderEntity>> call() => _repository.getOrders();
}
```

---

## Step 7: Create State

```dart
// logic/order_state.dart
import 'package:equatable/equatable.dart';

enum OrderStatus { initial, loading, loaded, error }

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  OrderState copyWith({
    OrderStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
```

---

## Step 8: Create Cubit/BLoC

```dart
// logic/order_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrderCubit extends Cubit<OrderState> {
  final GetOrders _getOrders;

  OrderCubit(this._getOrders) : super(const OrderState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final orders = await _getOrders();
      emit(state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
```

---

## Step 9: Create UI

```dart
// presentation/pages/orders_page.dart
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderCubit>()..loadOrders(),
      child: Scaffold(
        appBar: AppBar(title: Text('orders'.tr())),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return switch (state.status) {
              OrderStatus.loading => const LoadingWidget(),
              OrderStatus.error => ErrorWidget(
                  message: state.errorMessage!,
                  onRetry: () => context.read<OrderCubit>().loadOrders(),
                ),
              OrderStatus.loaded when state.orders.isEmpty =>
                const EmptyWidget(message: 'No orders yet'),
              OrderStatus.loaded => ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (_, i) => OrderCard(order: state.orders[i]),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
```

---

## Step 10: Register Route

In `lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: '/orders',
  name: 'orders',
  builder: (context, state) => const OrdersPage(),
),
```

---

## Step 11: Register Dependencies

Run build_runner after adding injectable annotations:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 12: Add Translations

In `assets/translations/ar.json`:
```json
{
  "orders": "الطلبات",
  "no_orders": "لا توجد طلبات"
}
```

In `assets/translations/en.json`:
```json
{
  "orders": "Orders",
  "no_orders": "No orders yet"
}
```

---

## Error Handling Pattern

### HTTP Error → App Behavior

| HTTP Code | Meaning | App Behavior |
|-----------|---------|-------------|
| `200` | Success | Parse `data` field, emit success state |
| `201` | Created | Parse `data` field, emit success, navigate forward |
| `401` | Unauthenticated | Clear tokens, redirect to Login |
| `403` | Forbidden | Show error message |
| `404` | Not Found | Show error message, stay on screen |
| `422` | Validation Error | Parse `errors`, show field-level messages |
| `429` | Rate Limited | Show "Try again later" message |

### Failure Classes

| Type | When | UI Action |
|------|------|-----------|
| `NetworkFailure` | Timeout, no internet | Show "No internet" with retry |
| `ServerFailure` | 4xx/5xx response | Show API error message |
| `UnknownFailure` | Unexpected error | Show generic "Something went wrong" |
| `RateLimitFailure` | 429 response | Show "Too many requests" with timer |

### 401 Interceptor (Global)

```
API returns 401 → Dio interceptor catches →
Clear SecureStorage → Navigate to /login → Show "Session expired"
```

Handle globally in Dio interceptor, not per-screen.

---

## Shared vs App-Specific Code

| Code Type | Where |
|-----------|-------|
| API client, interceptors | `packages/core/networking` |
| Shared models (User, Order) | `packages/core/models` |
| Auth logic | `packages/core/auth` |
| Storage helpers | `packages/core/storage` |
| Reusable widgets | `packages/ui_kit` |
| Translations | `packages/localization` |
| Validators, formatters | `packages/utils` |
| App-specific features | `apps/[app]/lib/features/` |
| App-specific routes | `apps/[app]/lib/core/router/` |
| App-specific DI | `apps/[app]/lib/core/di/` |
