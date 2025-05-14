AES-256 Encryption Wrapper Design Files

Overview
	This subfolder contains the design files for the AES-256 encryption wrapper module with support for Cipher Feedback Mode (CFB), Output Feedback Mode (OFB), and Counter Mode (CTR). 	The design includes both the wrapper and supporting modules, along with a testbench for functional validation.

Files Included

all_modes.v:

	The main wrapper module for the AES-256 encryption.
	Implements 180-bit encryption by processing the input data in two stages using a single AES core.
	Includes mode selection for CFB, OFB, and CTR operations.

testbench_all_modes.v:

	The testbench used to validate the wrapper module.
	Provides test vectors for key, initialization vector (IV), plaintext, and mode.
	Simulates encryption for all three modes and validates the ciphertext output.
	
aes_256.v:

	The modified AES-256 core module.
	Handles iterative encryption for the wrapper.
	Includes control signals (done_flag) for synchronization with the wrapper.

one_round.v:

	Module implementing a single round of AES encryption.
	Performs substitution, permutation, and mixing operations on the state.
	Processes input data over multiple clock cycles for efficiency.

table_lookup.v:

	Supporting module for S-box and T-box lookups.
	Implements substitution logic required for the AES algorithm.

Usage
	Place all files in the same working directory in your FPGA design environment.
	Run the testbench (test_aes_cfb.v) to simulate the functionality of the wrapper module.
	Modify the test vectors in the testbench to validate custom use cases, and the mode signal to choose the mode of operation.
	Use the wrapper module (aes_all_mode_180.v) as a top-level module in your design for 180-bit encryption.