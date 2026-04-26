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

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const _RegisterPageView(),
    );
  }
}

class _RegisterPageView extends StatefulWidget {
  const _RegisterPageView();

  @override
  State<_RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<_RegisterPageView> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
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
            Fluttertoast.showToast(msg: 'Kayıt başarılı');
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
                  SizedBox(height: ResponsiveScreen.h(60)),
                  Icon(
                    Icons.person_add_alt_1_rounded,
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
                  SizedBox(height: ResponsiveScreen.h(40)),
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
                          AppText.register.tr(),
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
                        SizedBox(height: ResponsiveScreen.h(16)),
                        CustomTextField(
                          hintText: AppText.confirmPassword.tr(),
                          controller: confirmPasswordCtrl,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        SizedBox(height: ResponsiveScreen.h(30)),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: AppText.register.tr(),
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                final email = emailCtrl.text.trim();
                                final password = passwordCtrl.text;
                                final confirmPassword = confirmPasswordCtrl.text;

                                if (email.isEmpty) {
                                  Fluttertoast.showToast(msg: AppText.email.tr());
                                  return;
                                }
                                if (password.isEmpty) {
                                  Fluttertoast.showToast(msg: AppText.password.tr());
                                  return;
                                }
                                if (confirmPassword != password) {
                                  Fluttertoast.showToast(
                                    msg: AppText.passwordsDoNotMatch.tr(),
                                  );
                                  return;
                                }

                                context.read<AuthCubit>().register(
                                      email,
                                      password,
                                    );
                              },
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveScreen.h(16)),
                        Text(
                          AppText.alreadyHaveAccount.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRouter.loginRoute),
                          child: Text(
                            AppText.login.tr(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveScreen.h(24)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

