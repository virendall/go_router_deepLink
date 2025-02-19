# Flutter Go Router Demo

A comprehensive demonstration application showcasing the capabilities of the `go_router` package for Flutter navigation, authentication flows, and deep linking.

## Features

- **Advanced Routing**: Implementation of nested routes, dynamic routes with parameters, and query parameters
- **Authentication Flow**: Complete authentication flow with login redirection and protected routes
- **Deep Linking**: Handling of external deep links with appropriate routing
- **URL Scheme Integration**: Custom URL scheme (`carapp://`) handling for both Android and iOS
- **State Management**: Integration with state management for authentication status


## Testing Deep Links

### Android

Use the following ADB commands to test deep links:

```bash
# Basic deep link to the home screen
adb shell am start -a android.intent.action.VIEW -d "carapp://"

# Deep link to specific car details
adb shell am start -a android.intent.action.VIEW -d "carapp://cars/123"

# Deep link with query parameters
adb shell am start -a android.intent.action.VIEW -d "carapp://cars?filter=electric&sort=price"

# Testing a specific path with encoded parameters
adb shell am start -a android.intent.action.VIEW -d "carapp://search?q=Tesla%20Model%203"
```

### iOS

For iOS, you can test deep links using the following methods:

1. **Safari**: Type `carapp://cars/123` in the Safari address bar
2. **Notes App**: Type `carapp://cars/123` in a note, then tap the link
3. **Shortcuts App**: Create a shortcut that opens a URL with your custom scheme

### Universal Link Testing (HTTPS)

```bash
# If you've configured universal links
adb shell am start -a android.intent.action.VIEW -d "https://example.com/cars/123"
```


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
