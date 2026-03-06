import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/form_cubit.dart';
import 'form_cubit.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Form'),
        backgroundColor: Colors.blue,
      ),
      body: BlocListener<FormCubit, FormViewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormSubmissionStatus.success) {
            _nameController
              ..text = ''
              ..selection = const TextSelection.collapsed(offset: 0);
            _emailController
              ..text = ''
              ..selection = const TextSelection.collapsed(offset: 0);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully!')),
            );
            context.read<FormCubit>().resetStatus();
          } else if (state.status == FormSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Something went wrong. Please try again.',
                ),
              ),
            );
          }
        },
        child: BlocBuilder<FormCubit, FormViewState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tell us about yourself',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This example shows how to manage a simple form with a Cubit using flutter_bloc.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Jane Doe',
                      errorText: state.status == FormSubmissionStatus.failure &&
                          state.name.trim().isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: context.read<FormCubit>().nameChanged,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'jane.doe@example.com',
                      errorText: state.status == FormSubmissionStatus.failure &&
                          state.email.trim().isEmpty
                          ? 'Email is required'
                          : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onChanged: context.read<FormCubit>().emailChanged,
                    onSubmitted: (_) => context.read<FormCubit>().submitForm(),
                  ),
                  const SizedBox(height: 24),
                  if (state.status == FormSubmissionStatus.failure &&
                      state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: state.status == FormSubmissionStatus.submitting
                        ? null
                        : () => context.read<FormCubit>().submitForm(),
                    child: state.status == FormSubmissionStatus.submitting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}