# Mini-AES Encrypted Cache

This project implements a simplified **16-bit Mini-AES** encryption core and a **16-line Direct-Mapped Cache** in VHDL.

* **Part 1:** Mini-AES with two encryption rounds using SubBytes, ShiftRows, MixColumns, and AddRoundKey.
* **Part 2:** A Direct-Mapped Cache where all data is **encrypted before being written** and **decrypted when read**, ensuring only encrypted data is stored internally.

The project includes complete testbenches and waveform verification for both the Mini-AES core and the encrypted cache.
