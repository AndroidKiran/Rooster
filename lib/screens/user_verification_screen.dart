import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/blocs/form_verification_bloc/form_verification_bloc.dart';
import 'package:rooster/screens/models/block_form_item.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class UserVerificationScreen extends StatelessWidget {
  final _verificationFormKey = GlobalKey<FormState>();

  UserVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
            text: 'Verify Employee',
            textSize: 32,
            textColor: Colors.grey[800],
            maxLines: 1),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: _verificationForm()),
    );
  }

  Widget _verificationForm() {
    return BlocListener<FormVerificationBloc, FormVerificationState>(
      listener: (context, state) {
        if (state.formStatus == FormStatus.submitFailure) {
          _showSnackBar(context, "User verification Failed");
        }
      },
      child: Form(
        key: _verificationFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _emailField(),
              const SizedBox(height: 28),
              _platformDropdown(),
              const SizedBox(height: 40),
              _submitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() =>
      BlocBuilder<FormVerificationBloc, FormVerificationState>(
        builder: (context, state) {
          return TextFormField(
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.mail,
                  color: Theme.of(context).colorScheme.primary,
                ),
                labelText: "Employee Email",
                filled: true,
                fillColor: Theme.of(context).colorScheme.background),
            validator: (value) => state.emailFormItem.error,
            onChanged: (value) => context.read<FormVerificationBloc>().add(
                UserEmailChangedEvent(
                    emailFormItem: BlocFormItem(value: value))),
          );
        },
      );

  Widget _platformDropdown() =>
      BlocBuilder<FormVerificationBloc, FormVerificationState>(
        builder: (context, state) {
          return DropdownButtonFormField<String>(
            value: state.platformFormItem.value,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              prefixIcon: Icon(
                CupertinoIcons.bag,
                color: Colors.deepPurple,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              labelText: 'Platform',
            ),
            validator: (value) => state.platformFormItem.error,
            onChanged: (value) => context.read<FormVerificationBloc>().add(
                PlatformChangedEvent(
                    platformItem: BlocFormItem(value: value!))),
            items: const [
              DropdownMenuItem(
                value: 'android',
                child: Text('Android'),
              ),
              DropdownMenuItem(
                value: 'ios',
                child: Text('Ios'),
              ),
              DropdownMenuItem(
                value: 'web',
                child: Text('Web'),
              ),
            ],
          );
        },
      );

  Widget _submitButton() =>
      BlocBuilder<FormVerificationBloc, FormVerificationState>(
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Theme.of(context).colorScheme.background,
              fixedSize: const Size(220.0, 50.0),
            ),
            onPressed: () {
              if (_verificationFormKey.currentState!.validate()) {
                context.read<FormVerificationBloc>().add(FormSubmitEvent());
              }
            },
            child: FormStatus.formSubmitting == state.formStatus
                ? SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                  ),
          );
        },
      );

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
