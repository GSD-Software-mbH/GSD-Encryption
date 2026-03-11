# GSD-Encryption Example

This example demonstrates how to use the `gsd_encryption` package in a Flutter application.

## Features Demonstrated

- **AES Encryption/Decryption**: Symmetric encryption using AES-256 in CBC mode
- **RSA Encryption/Decryption**: Asymmetric encryption using RSA with OAEP padding
- **Key Management**: Loading RSA keys from assets and automatic AES key generation
- **Cross-platform**: Works on all Flutter platforms (iOS, Android, Web, Desktop)

## What This Example Shows

### 1. Package Initialization
```dart
// Initialize with RSA keys from assets
final options = EncryptionOptions(
  rsaPublicKeyFilePath: "assets/keys/public_key.pem",
  rsaPrivateKeyFilePath: "assets/keys/private_key.pem",
);

_encryptionManager = EncryptionManager.init(options);
await _encryptionManager.initializeAESKey();
```

### 2. AES Encryption (Symmetric)
```dart
// Encrypt text with AES
String encrypted = await _encryptionManager.encryptAES(plaintext);

// Decrypt text with AES
String decrypted = await _encryptionManager.decryptAES(encrypted);
```

### 3. RSA Encryption (Asymmetric)
```dart
// Encrypt text with RSA (supports large text via block processing)
String encrypted = await _encryptionManager.encryptRSAInBlocks(plaintext);

// Decrypt text with RSA
String decrypted = await _encryptionManager.decryptRSAInBlocks(encrypted);
```

## RSA Key Files

The example includes demo RSA key files:
- `assets/keys/public_key.pem` - RSA public key (2048-bit)
- `assets/keys/private_key.pem` - RSA private key (2048-bit)

**⚠️ Important**: These are demo keys for testing only. In production:
- Generate your own RSA key pairs
- Keep private keys secure
- Never commit real private keys to version control
- Consider using key management services

## Generating Your Own RSA Keys

You can generate your own RSA key pair using OpenSSL:

```bash
# Generate private key
openssl genpkey -algorithm RSA -out private_key.pem -pkcs8 -numbits 2048

# Generate public key
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

## Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage Instructions

1. **Enter Text**: Type any text in the input field
2. **Choose Encryption**: Click either "Encrypt AES" or "Encrypt RSA"
3. **View Results**: The encrypted text appears in the encrypted text section
4. **Decrypt**: Click the corresponding decrypt button to recover the original text
5. **Clear**: Use "Clear All" to reset all fields

## Key Differences Between AES and RSA

### AES (Advanced Encryption Standard)
- **Type**: Symmetric encryption
- **Speed**: Very fast
- **Key**: Same key for encryption and decryption
- **Use Case**: Bulk data encryption
- **Security**: 256-bit key provides excellent security

### RSA (Rivest-Shamir-Adleman)
- **Type**: Asymmetric encryption
- **Speed**: Slower than AES
- **Keys**: Public key for encryption, private key for decryption
- **Use Case**: Key exchange, digital signatures, small data
- **Security**: 2048-bit key provides strong security

## Best Practices Demonstrated

1. **Error Handling**: Proper try-catch blocks for all encryption operations
2. **User Feedback**: Status messages and loading indicators
3. **Input Validation**: Checking for empty inputs and initialization state
4. **Resource Management**: Proper disposal of controllers
5. **Responsive UI**: Disabled buttons when operations are not available

## Platform Considerations

- **Web**: Uses Web Crypto API for optimal performance
- **Mobile/Desktop**: Uses pointycastle library for cryptographic operations
- **Assets**: RSA keys are loaded from Flutter assets on all platforms
- **Storage**: AES keys are stored securely using FlutterSecureStorage
