`timescale 1ns / 1ps

module test_aes_cfb;

    // Inputs to the DUT
    reg clk;
    reg reset;
    reg [255:0] key;
    reg [127:0] iv;
    reg [179:0] plaintext_large;  // Large input (512 bits)

	reg [127:0] nonce;
	reg [1:0] mode;  //0<-cfm, 1<-ofb, 2<-ctr

    // Outputs from the DUT
    wire [179:0] ciphertext_large; // Large output (180 bits)

    

	aes_all_mode_180 uut (
		.clk(clk),
        .reset(reset),
        .key(key),
        .iv(iv),
        .plaintext(plaintext_large),
		.mode(mode),
		.nonce(nonce),
        .ciphertext(ciphertext_large)
	);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test vectors
    initial begin
        // Initialize inputs
        reset = 1;
        key = 256'h2b7e151628aed2a6abf7158809cf4f3c_762e7160f38b4da56a784d9045190cfe;
        iv = 128'h000102030405060708090a0b0c0d0e0f;
        plaintext_large = 180'hf590f3d9a7eb96e1e97061adacd472e10d084b41ce403;

		mode = 0;  //0<-cfb, 1<-ofb, 2<-ctr
		nonce = 128'h1234567890abcdef1122334455667788;

        // Release reset after some time
        #10 reset = 0;

        // Wait and observe ciphertext output
        #2500;
        $display("Ciphertext: %h", ciphertext_large);
        $stop;
    end
endmodule
