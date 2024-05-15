import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/add_employee_verification_bloc/add_employee_verification_bloc.dart';
import 'package:rooster/screens/models/block_form_item.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class AddNewUserScreen extends StatelessWidget {
  final _verificationFormKey = GlobalKey<FormState>();

  AddNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
            text: 'Add New User',
            textSize: 32,
            textColor: Colors.grey[800],
            maxLines: null),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: _verificationForm()),
    );
  }

  Widget _verificationForm() {
    return BlocListener<AddEmployeeVerificationBloc,
        AddEmployeeVerificationState>(
      listener: (context, state) {
        if (state.formStatus == FormStatus.submitFailure) {
          _showSnackBar(context, "User verification Failed");
        }

        if (state.formStatus == FormStatus.submitSuccess) {
          if (!context.mounted) return;
          context.pushReplacementNamed(RoosterScreenPath.addNewUserScreen.name);
        }
      },
      child: Form(
        key: _verificationFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _nameField(),
              const SizedBox(height: 28),
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
      BlocBuilder<AddEmployeeVerificationBloc, AddEmployeeVerificationState>(
        builder: (context, state) {
          return TextFormField(
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.mail_solid,
                  color: Theme.of(context).colorScheme.primary,
                ),
                labelText: "Employee Email",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => state.emailFormItem.error,
            onChanged: (value) => context
                .read<AddEmployeeVerificationBloc>()
                .add(EmailChangedEvent(
                    emailFormItem: BlocFormItem(value: value))),
          );
        },
      );

  Widget _nameField() =>
      BlocBuilder<AddEmployeeVerificationBloc, AddEmployeeVerificationState>(
        builder: (context, state) {
          return TextFormField(
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.person_add_solid,
                  color: Theme.of(context).colorScheme.primary,
                ),
                labelText: "Employee Name",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => state.nameFormItem.error,
            onChanged: (value) => context
                .read<AddEmployeeVerificationBloc>()
                .add(
                    NameChangedEvent(nameFormItem: BlocFormItem(value: value))),
          );
        },
      );

  Widget _platformDropdown() =>
      BlocBuilder<AddEmployeeVerificationBloc, AddEmployeeVerificationState>(
        builder: (context, state) {
          return DropdownButtonFormField<String>(
            value: state.platformFormItem.value,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              prefixIcon: Icon(
                CupertinoIcons.device_phone_portrait,
                color: Colors.deepPurple,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              labelText: 'Platform',
            ),
            validator: (value) => state.platformFormItem.error,
            onChanged: (value) => context
                .read<AddEmployeeVerificationBloc>()
                .add(PlatformChangedEvent(
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
            ],
          );
        },
      );

  Widget _submitButton() =>
      BlocBuilder<AddEmployeeVerificationBloc, AddEmployeeVerificationState>(
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Theme.of(context).colorScheme.surface,
              fixedSize: const Size(220.0, 50.0),
            ),
            onPressed: state.isFromValidationSuccess()
                ? () {
                    if (_verificationFormKey.currentState!.validate()) {
                      context
                          .read<AddEmployeeVerificationBloc>()
                          .add(FormSubmitEvent());
                    }
                  }
                : null,
            child: FormStatus.formSubmitting == state.formStatus
                ? SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : const Text(
                    'Add Employee',
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
