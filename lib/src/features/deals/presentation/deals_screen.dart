import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndeals/src/common_widgets/error_message_widget.dart';
import 'package:ndeals/src/features/deals/data/deals_repository.dart';
import 'package:ndeals/src/features/deals/domain/deal.dart';

class DealsScreen extends ConsumerStatefulWidget {
  const DealsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DealsScreenState();
}

class _DealsScreenState extends ConsumerState<DealsScreen> {
  Future<void> _refreshDeals() async {
    ref.invalidate(todayDealsFutureProvider);
    ref.invalidate(allDealsFutureProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        title: Text(
          'Deals',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.grey.shade100,
        backgroundColor: Colors.white,
        elevation: 6,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDeals,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSearchTxtField(),
              _buildSectionTitle('Today\'s Deals'),
              _buildTodaysDeals(),
              _buildStickySectionTitle('All Deals'),
              _buildAllDeals(),
            ],
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader _buildStickySectionTitle(String title) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AllDealsStickyHeaderDelegate(
        child: Container(
          color: const Color(0xfff6f6f6),
          padding: EdgeInsets.only(left: 15.w),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Consumer _buildAllDeals() {
    return Consumer(
      builder: (context, ref, child) {
        final value = ref.watch(allDealsFutureProvider);

        return value.when(
          data: (data) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: data.length,
                (context, index) {
                  final deal = data[index];
                  final bool isLastItem = index == (data.length - 1);

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: isLastItem ? 10.h : 0,
                        left: 15.w,
                        right: 15.w,
                        top: 10.h),
                    child: _buildAllDealsCard(deal),
                  );
                },
              ),
            );
          },
          error: (e, st) => SliverToBoxAdapter(
            child: SizedBox(
              height: 150.h,
              child: Center(
                child: ErrorMessageWidget(
                  errorMessage: e.toString(),
                  onRetry: () => ref.invalidate(allDealsFutureProvider),
                ),
              ),
            ),
          ),
          loading: () => SliverToBoxAdapter(
            child: SizedBox(
              height: 150.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildAllDealsCard(Deal deal) {
    return SizedBox(
      height: 250.h,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${deal.price} Nrs Off',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Image.network(
                deal.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 20.sp,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '${deal.views} views',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 20.sp,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '${deal.likes} likes',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTodaysDeals() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 195.h,
        child: Consumer(
          builder: (context, ref, child) {
            final value = ref.watch(todayDealsFutureProvider);

            return value.when(
              data: (data) {
                return ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final deal = data[index];
                    final bool isLastItem = index == (data.length - 1);

                    return Padding(
                      padding: EdgeInsets.only(right: isLastItem ? 0 : 10.w),
                      child: _buildTodayDealsCard(deal),
                    );
                  },
                );
              },
              error: (e, st) => ErrorMessageWidget(
                errorMessage: e.toString(),
                onRetry: () => ref.invalidate(todayDealsFutureProvider),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  SizedBox _buildTodayDealsCard(Deal deal) {
    return SizedBox(
      width: 250.w,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                child: Image.network(
                  deal.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${deal.price} Nrs Off',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchTxtField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 25.sp,
              color: Colors.grey,
            ),
            hintText: 'Pizza',
            hintStyle: TextStyle(
              fontSize: 17.sp,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2.w,
              ),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class AllDealsStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  AllDealsStickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 35.h;

  @override
  double get minExtent => 35.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
