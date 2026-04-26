import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hd_images/core/di/injection_container.dart';
import 'package:hd_images/core/responsive_screen/responsive_screen.dart';
import 'package:hd_images/core/utils/app_text.dart';
import 'package:hd_images/features/auth/presentation/widgets/custom_button.dart';
import 'package:hd_images/features/upscale/presentation/cubit/upscale_cubit.dart';
import 'package:hd_images/features/upscale/presentation/cubit/upscale_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UpscaleCubit>(), // DI'ye eklenecek
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.appName.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings');
            },
          )
        ],
      ),
      body: BlocListener<UpscaleCubit, UpscaleState>(
        listener: (context, state) {
          if (state is UpscaleError) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveScreen.w(24)),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppText.selectPhoto.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveScreen.h(8)),
              Text(
                AppText.selectPhotoPrompt.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: ResponsiveScreen.h(32)),

              // Selection Banner veya Seçilen Resim Göstericisi
              Expanded(
                child: BlocBuilder<UpscaleCubit, UpscaleState>(
                  builder: (context, state) {
                    if (state is UpscaleImageSelected ||
                        state is UpscaleProcessing ||
                        state is UpscaleSuccess ||
                        (state is UpscaleError && state.imagePath != null)) {
                      final imagePath = (state is UpscaleImageSelected) 
                          ? state.imagePath 
                          : (state is UpscaleProcessing)
                              ? state.imagePath
                              : (state is UpscaleSuccess)
                                  ? state.upscaledImagePath
                                  : (state as UpscaleError).imagePath!;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(ResponsiveScreen.w(24)),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (state is UpscaleProcessing)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(ResponsiveScreen.w(24)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(color: Colors.white),
                                  SizedBox(height: ResponsiveScreen.h(16)),
                                  Text(AppText.aiProcessing.tr(), style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          else if (state is UpscaleSuccess)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(AppText.photoUpscaled.tr(), style: const TextStyle(color: Colors.white)),
                              )
                            )
                          else if (state is UpscaleError)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          if (state is! UpscaleProcessing)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                style: IconButton.styleFrom(backgroundColor: Colors.black54),
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  context.read<UpscaleCubit>().removeSelectedImage();
                                },
                              ),
                            ),
                        ],
                      );
                    }

                    // Henüz Fotoğraf Seçilmemiş Hali
                    return InkWell(
                      onTap: () => context.read<UpscaleCubit>().pickImage(),
                      borderRadius: BorderRadius.circular(ResponsiveScreen.w(24)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(ResponsiveScreen.w(24)),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: ResponsiveScreen.w(64),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: ResponsiveScreen.h(16)),
                            Text(AppText.browseGallery.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: ResponsiveScreen.h(32)),

              // Çözünürlüğü Arttır Butonu
              BlocBuilder<UpscaleCubit, UpscaleState>(
                builder: (context, state) {
                  return CustomButton(
                    text: AppText.startMagic.tr(),
                    icon: Icons.auto_awesome,
                    isLoading: state is UpscaleProcessing,
                    isOutline: state is! UpscaleImageSelected && state is! UpscaleProcessing,
                    onPressed: () {
                      if (state is UpscaleImageSelected) {
                        context.read<UpscaleCubit>().processImage(state.imagePath);
                      } else if (state is UpscaleInitial) {
                        context.read<UpscaleCubit>().pickImage();
                      }
                    },
                  );
                },
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
