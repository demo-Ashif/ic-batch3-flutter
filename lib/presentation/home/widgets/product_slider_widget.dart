import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product_slider.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/bloc/product_slider_bloc.dart';

class ProductSliderWidget extends StatelessWidget {
  const ProductSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSliderBloc, ProductSliderState>(
      builder: (context, sliderState) {
        if (sliderState.status == ProductSliderStatus.loading) {
          return const _SliderLoadingWidget();
        }

        if (sliderState.status == ProductSliderStatus.failure ||
            sliderState.sliders.isEmpty) {
          return const SizedBox.shrink();
        }

        return _SliderContent(sliders: sliderState.sliders);
      },
    );
  }
}

class _SliderLoadingWidget extends StatelessWidget {
  const _SliderLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _SliderContent extends StatelessWidget {
  const _SliderContent({required this.sliders});

  final List<ProductSlider> sliders;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            itemCount: sliders.length,
            itemBuilder: (context, index) {
              final slider = sliders[index];
              return _SliderItem(slider: slider);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SliderItem extends StatelessWidget {
  const _SliderItem({required this.slider});

  final ProductSlider slider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image
            if (slider.imageUrl.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  slider.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.onSurfaceVariant,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                color: colorScheme.onSurfaceVariant,
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount Badge
                  if (slider.priceLabel != null &&
                      slider.priceLabel!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        slider.priceLabel!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    slider.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  if (slider.shortDescription != null &&
                      slider.shortDescription!.isNotEmpty)
                    Text(
                      slider.shortDescription!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withValues(alpha: 0.9),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
