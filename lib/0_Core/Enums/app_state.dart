enum AppState {
  idle, // App running normally
  loading, // App is loading something
  loaded, // App has loaded something
  error, // App has an error
  storingSuccess, // App has successfully stored something
  storingFailed, // App has failed to store something
}
