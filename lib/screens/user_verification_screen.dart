import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/blocs/form_verification_bloc/form_verification_bloc.dart';

class UserVerificationScreen extends StatelessWidget {
  UserVerificationScreen({super.key});
  final _verificationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _headerText(),
      ),
      body: _verificationForm(),
    );
  }

  Widget _verificationForm() {
    return BlocListener<FormVerificationBloc, FormVerificationState>(
      listener: (context, state) {
        if(state.formStatus == FormStatus.submitFailure) {
          _showSnackBar(context, "User verification Failed");
        }
      },
      child: Form(
        key: _verificationFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconHolder(),
              _emailField(),
              const SizedBox(height: 28),
              _submitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText() => Text(
    'Verify Employee',
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        color: Colors.grey[800],
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
        fontFamily: 'Open Sans',
        fontSize: 32),
  );

  Widget _iconHolder() => Image.asset(
    "assets/icons/icon_rooster.png",
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  );

  Widget _emailField() => BlocBuilder<FormVerificationBloc, FormVerificationState>(
    builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: Icon(
              CupertinoIcons.envelope_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            labelText: "Employee Email",
            filled: true,
            fillColor: Theme.of(context).colorScheme.background
        ),
        validator: (value) => state.user.isValidEmail ? null : "Enter valid email",
        onChanged: (value) => context.read<FormVerificationBloc>()
            .add(UserEmailChangedEvent(email: value)
        ),
      );
    },
);

  Widget _submitButton() => BlocBuilder<FormVerificationBloc, FormVerificationState>(
  builder: (context, state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Theme.of(context).colorScheme.background,
          fixedSize: const Size(200.0, 50.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(50),
          )
      ),
      onPressed: () {
        if(_verificationFormKey.currentState!.validate()) {
          context.read<FormVerificationBloc>().add(
            UserEmailSubmittedEvent(user: state.user)
          );
        }
      },
      child: FormStatus.formSubmitting == state.formStatus? SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,),
      ): const Text(
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

  void _showSnackBar (BuildContext context, String message) {
    final snackBar = SnackBar(content: Text (message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}



