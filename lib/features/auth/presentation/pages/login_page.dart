import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hd_images/core/di/injection_container.dart';
import 'package:hd_images/core/navigation/app_router.dart';
import 'package:hd_images/core/responsive_screen/responsive_screen.dart';
import 'package:hd_images/core/utils/app_text.dart';
import 'package:hd_images/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:hd_images/features/auth/presentation/cubit/auth_state.dart';
import 'package:hd_images/features/auth/presentation/widgets/custom_button.dart';
import 'package:hd_images/features/auth/presentation/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _LoginPageView(),
    );
  }
}

class _LoginPageView extends StatefulWidget {
  const _LoginPageView();

  @override
  State<_LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<_LoginPageView> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            Fluttertoast.showToast(msg: state.message);
          } else if (state is AuthAuthenticated) {
            Fluttertoast.showToast(msg: 'Hoşgeldin ${state.user.email}');
            context.go(AppRouter.homeRoute);
          }
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveScreen.w(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: ResponsiveScreen.h(80)),
                  Icon(
                    Icons.image_search_rounded,
                    size: ResponsiveScreen.w(100),
                    color: Colors.white,
                  ),
                  SizedBox(height: ResponsiveScreen.h(20)),
                  Text(
                    AppText.appName.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: ResponsiveScreen.h(60)),
                  
                  // Login Form Container
                  Container(
                    padding: EdgeInsets.all(ResponsiveScreen.w(24)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(ResponsiveScreen.w(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppText.login.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ResponsiveScreen.h(30)),
                        CustomTextField(
                          hintText: AppText.email.tr(),
                          controller: emailCtrl,
                          prefixIcon: Icons.email_outlined,
                        ),
                        SizedBox(height: ResponsiveScreen.h(16)),
                        CustomTextField(
                          hintText: AppText.password.tr(),
                          controller: passwordCtrl,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        SizedBox(height: ResponsiveScreen.h(30)),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: AppText.login.tr(),
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                context.read<AuthCubit>().login(
                                  emailCtrl.text,
                                  passwordCtrl.text,
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveScreen.h(16)),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: AppText.loginWithGoogle.tr(),
                              icon: Icons.g_mobiledata,
                              isOutline: true,
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                context.read<AuthCubit>().googleLogin();
                              },
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveScreen.h(16)),
                        Text(
                          AppText.noAccountYet.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRouter.registerRoute),
                          child: Text(
                            AppText.register.tr(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
