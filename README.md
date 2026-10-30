# MediDonate - Medicine Donation App

A Flutter application that connects medicine donors with receivers, making healthcare more accessible to those in need.

## Features

- **Splash Screen**: Vibrant animated splash screen with app branding
- **Login Screen**: User authentication with email and password
- **Register Screen**: New user registration with form validation
- **Role Selection**: Choose between Donor, Receiver, or Admin roles
- **Donor Dashboard**: 
  - View donation statistics
  - Submit medicine donations
  - Track donation history
  - Logout functionality
- **Receiver Dashboard**:
  - Register as a receiver
  - Request medicines
  - View available medicines
  - Logout functionality
- **Admin Dashboard**:
  - Manage donations and requests
  - View statistics and recent activities
  - Logout functionality
- **Medicine Donation Form**: Submit medicine details for donation
- **Receiver Registration Form**: Register to receive medicines
- **Medicine Request**: Request specific medicines with priority levels
- **My Donations**: View and track donation history
- **Delivery Details**: Track delivery status of donated medicines
- **Medicine Results**: View available medicines matching requests

## Design

The app features vibrant colors throughout:
- **Orange** (#FF6B35): Primary color for donor-related features
- **Blue** (#4A90E2): Primary color for receiver-related features
- **Yellow** (#FFD93D): Accent color for highlights and admin features

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (IDE)

### Installation

1. Clone the repository or navigate to the project directory:
```bash
cd medidonate
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point and theme configuration
└── screens/
    ├── splash_screen.dart       # Animated splash screen
    ├── login_screen.dart        # User login screen
    ├── register_screen.dart     # User registration screen
    ├── role_selection_screen.dart # Role selection (Donor/Receiver/Admin)
    ├── donor_dashboard.dart     # Donor home and navigation
    ├── receiver_dashboard.dart   # Receiver home and navigation
    ├── admin_dashboard.dart     # Admin panel
    ├── medicine_donation_form.dart # Medicine donation form
    ├── receiver_form.dart       # Receiver registration form
    ├── medicine_request.dart    # Medicine request form
    ├── my_donations.dart        # Donation history
    ├── delivery_details.dart    # Delivery tracking
    └── medicine_result.dart     # Available medicines list
```

## Usage

1. **Launch the app**: The splash screen will display for 3 seconds
2. **Login or Register**: 
   - New users can register with name, email, phone, and password
   - Existing users can login with email and password
   - Social login options (Google, Facebook, Apple) are available (UI only)
3. **Select a role**: Choose Donor, Receiver, or Admin after login
4. **Donor Flow**:
   - Navigate to "Donate" to submit medicine donations
   - View "My Donations" to track donation history
   - Click on a donation to view delivery details
   - Logout from the dashboard
5. **Receiver Flow**:
   - Register as a receiver first
   - Request medicines with priority levels
   - View available medicines in "Results"
   - Logout from the dashboard
6. **Admin Flow**:
   - View overall statistics
   - Monitor donations and requests
   - Manage approval processes
   - Logout from the dashboard

## Dependencies

- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `shared_preferences`: Local data persistence
- `intl`: Internationalization and date formatting

## Future Enhancements

- Backend integration for real data storage
- User authentication
- Push notifications for donation updates
- Image upload for medicine verification
- Geolocation for delivery tracking
- Chat system between donors and receivers
- Rating and review system

## License

This project is created for educational purposes.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
