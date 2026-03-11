import 'package:flutter/material.dart';
import 'package:gsd_encryption/gsd_encryption.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GSD Encryption Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EncryptionDemo(),
    );
  }
}

class EncryptionDemo extends StatefulWidget {
  const EncryptionDemo({super.key});

  @override
  State<EncryptionDemo> createState() => _EncryptionDemoState();
}

class _EncryptionDemoState extends State<EncryptionDemo> {
  final _plaintextController = TextEditingController();
  String _encryptedText = '';
  String _decryptedText = '';
  String _status = 'Ready';

  late EncryptionManager _encryptionManager;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeEncryption();
  }

  Future<void> _initializeEncryption() async {
    try {
      setState(() {
        _status = 'Initializing encryption...';
      });

      // Initialize with RSA keys from assets
      final options = EncryptionOptions(
        rsaPublicKeyFilePath: "assets/keys/encryption-pub.pem",
        rsaPrivateKeyFilePath: "assets/keys/encryption.pem",
      );

      _encryptionManager = EncryptionManager.init(options);

      // Initialize AES key
      await _encryptionManager.initializeAESKey();

      setState(() {
        _isInitialized = true;
        _status = 'Encryption ready';
      });
    } catch (e) {
      setState(() {
        _status = 'Initialization failed: $e';
      });
    }
  }

  Future<void> _encryptAES() async {
    if (!_isInitialized || _plaintextController.text.isEmpty) return;

    try {
      setState(() {
        _status = 'Encrypting with AES...';
      });

      final encrypted =
          await _encryptionManager.encryptAES(_plaintextController.text);

      setState(() {
        _encryptedText = encrypted;
        _status = 'AES encryption completed';
      });
    } catch (e) {
      setState(() {
        _status = 'AES encryption failed: $e';
      });
    }
  }

  Future<void> _decryptAES() async {
    if (!_isInitialized || _encryptedText.isEmpty) return;

    try {
      setState(() {
        _status = 'Decrypting with AES...';
      });

      final decrypted = await _encryptionManager.decryptAES(_encryptedText);

      setState(() {
        _decryptedText = decrypted;
        _status = 'AES decryption completed';
      });
    } catch (e) {
      setState(() {
        _status = 'AES decryption failed: $e';
      });
    }
  }

  Future<void> _encryptRSA() async {
    if (!_isInitialized || _plaintextController.text.isEmpty) return;

    try {
      setState(() {
        _status = 'Encrypting with RSA...';
      });

      final encrypted = await _encryptionManager
          .encryptRSAInBlocks(_plaintextController.text);

      setState(() {
        _encryptedText = encrypted;
        _status = 'RSA encryption completed';
      });
    } catch (e) {
      setState(() {
        _status = 'RSA encryption failed: $e';
      });
    }
  }

  Future<void> _decryptRSA() async {
    if (!_isInitialized || _encryptedText.isEmpty) return;

    try {
      setState(() {
        _status = 'Decrypting with RSA...';
      });

      final decrypted =
          await _encryptionManager.decryptRSAInBlocks(_encryptedText);

      setState(() {
        _decryptedText = decrypted;
        _status = 'RSA decryption completed';
      });
    } catch (e) {
      setState(() {
        _status = 'RSA decryption failed: $e';
      });
    }
  }

  void _clear() {
    setState(() {
      _plaintextController.clear();
      _encryptedText = '';
      _decryptedText = '';
      _status = 'Cleared';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GSD Encryption Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_status',
                      style: TextStyle(
                        color: _isInitialized ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!_isInitialized)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Input Text',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _plaintextController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter text to encrypt...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isInitialized ? _encryptAES : null,
                    icon: const Icon(Icons.lock),
                    label: const Text('Encrypt AES'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isInitialized ? _encryptRSA : null,
                    icon: const Icon(Icons.security),
                    label: const Text('Encrypt RSA'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isInitialized && _encryptedText.isNotEmpty
                        ? _decryptAES
                        : null,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Decrypt AES'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isInitialized && _encryptedText.isNotEmpty
                        ? _decryptRSA
                        : null,
                    icon: const Icon(Icons.no_encryption),
                    label: const Text('Decrypt RSA'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.clear),
              label: const Text('Clear All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 16),
            if (_encryptedText.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Encrypted Text',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _encryptedText,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_decryptedText.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Decrypted Text',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          _decryptedText,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _plaintextController.dispose();
    super.dispose();
  }
}
