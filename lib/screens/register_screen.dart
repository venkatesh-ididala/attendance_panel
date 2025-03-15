// import 'package:attendance_panel/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   String _role = 'employee';

//   // **Email Validator**
//   String? _validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Enter a valid email';
//     }
//     // Ensure email is in lowercase
//     if (value != value.toLowerCase()) {
//       return 'Email must be in lowercase';
//     }
//     // Regex for a valid email format
//     String emailPattern = r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';
//     if (!RegExp(emailPattern).hasMatch(value)) {
//       return 'Enter a valid email';
//     }
//     return null;
//   }

//   // **Password Validator**
//   String? _validatePassword(String? value) {
//     if (value == null || value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }

//   // **Name Validator**
//   String? _validateName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Enter your name';
//     }
//     return null;
//   }

//   void _register() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       String email = _emailController.text.trim();
//       String password = _passwordController.text.trim();
//       String name = _nameController.text.trim();

//       AuthService authService =
//           Provider.of<AuthService>(context, listen: false);

//       try {
//         await authService.register(name, email, password, _role);

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Registration Successful!')),
//           );

//           Future.microtask(() {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => LoginScreen()),
//             );
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(e.toString())),
//           );
//         }
//       }

//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Register')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: _validateName,
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: _validateEmail,
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: _validatePassword,
//               ),
//               DropdownButtonFormField(
//                 value: _role,
//                 items: [
//                   DropdownMenuItem(value: 'employee', child: Text('Employee')),
//                   DropdownMenuItem(value: 'admin', child: Text('Admin')),
//                 ],
//                 onChanged: (value) => setState(() => _role = value.toString()),
//                 decoration: InputDecoration(labelText: 'Role'),
//               ),
//               SizedBox(height: 20),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _register,
//                       child: Text('Register'),
//                     ),
//               TextButton(
//                 onPressed: () => Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 ),
//                 child: Text('Already have an account? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:attendance_panel/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordVisible = false; // For toggling password visibility
  String _role = 'employee';

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter a valid email';
    if (value != value.toLowerCase()) return 'Email must be in lowercase';
    String emailPattern = r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your name';
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String name = _nameController.text.trim();

      AuthService authService =
          Provider.of<AuthService>(context, listen: false);

      try {
        await authService.register(name, email, password, _role);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successful!')),
          );

          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }

      if (mounted) setState(() => _isLoading = false);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: _validateName,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: _validatePassword,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _role,
                items: [
                  DropdownMenuItem(value: 'employee', child: Text('Employee')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) => setState(() => _role = value.toString()),
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: Text('Register'),
                    ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
