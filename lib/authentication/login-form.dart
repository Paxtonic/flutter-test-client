import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rational_flutter_lib/authentication/login-option.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({Key? key}) : super(key: key);

  @override
  State<AuthenticationForm> createState() {
    return _AuthenticationFormState();
  }
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _loginOptionHasError = false;

  List<LoginOption> loginOptions = [LoginOption.Default, LoginOption.SSO, LoginOption.Social];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Builder Example')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 64,
            ),
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  onChanged: () {
                    _formKey.currentState!.save();
                    debugPrint(_formKey.currentState!.value.toString());
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  initialValue: const {
                    // 'login-option': LoginOption.Default,
                  },
                  skipDisabled: true,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 16),
                      FormBuilderDropdown<LoginOption>(
                        name: 'login-option',
                        decoration: const InputDecoration(
                          labelText: 'Login Option',
                          hintText: 'Select Login',
                        ),
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                        items: loginOptions
                            .map((option) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center,
                                  value: option,
                                  child: Text(option.toString()),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _loginOptionHasError =
                                !(_formKey.currentState?.fields['login-option']?.validate() ?? false);
                          });
                        },
                        valueTransformer: (val) => val?.toString(),
                      ),
                      FormBuilderTextField(
                        name: 'login-username',
                        autocorrect: false,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                        decoration: const InputDecoration(labelText: 'Username'),
                      ),
                      FormBuilderTextField(
                        name: 'login-password',
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                        decoration: const InputDecoration(labelText: 'Password'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
