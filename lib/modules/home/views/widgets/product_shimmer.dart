import 'package:flutter/material.dart';

/// ProductGridShimmer renders animated skeleton placeholder cards
/// while products are loading from the remote API.
class ProductGridShimmer extends StatefulWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGridShimmer({
    super.key,
    this.itemCount = 6,
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  @override
  State<ProductGridShimmer> createState() => _ProductGridShimmerState();
}

class _ProductGridShimmerState extends State<ProductGridShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer Image Box
                  Expanded(
                    child: Container(
                      color: baseColor.withValues(alpha: _animation.value),
                    ),
                  ),

                  // Shimmer Content Lines
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 10,
                          decoration: BoxDecoration(
                            color: baseColor.withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                            color: baseColor.withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: baseColor.withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 70,
                          height: 14,
                          decoration: BoxDecoration(
                            color: baseColor.withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
