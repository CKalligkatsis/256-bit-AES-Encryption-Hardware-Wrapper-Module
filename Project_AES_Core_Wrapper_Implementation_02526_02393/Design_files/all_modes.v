module aes_all_mode_180 (
    input wire clk,
    input wire reset,
    input wire [179:0] plaintext,      // 512-bit plaintext input
    input wire [255:0] key,            // 256-bit AES key
    input wire [127:0] iv,             // Initialization vector
	input wire [1:0] mode,
	input wire [127:0] nonce,
    output wire [179:0] ciphertext      // 512-bit ciphertext output
);
    wire [127:0] plaintext_blocks [3:0]; // 4 plaintext blocks of 128 bits each
    reg [127:0] ciphertext_blocks [3:0]; // 4 ciphertext blocks of 128 bits each
	wire [127:0] bc_buses_out [3:0];
	wire [3:0] done_flag ;
	reg fix_r5_flag ;


	reg [127:0] feedback;

	reg [127:0] counter;

    // AES-256 encryption instance
    aes_256 aes_inst0 (
        .clk(clk),
		.reset(reset),
        .state(feedback),              // Feedback as input to AES
        .key(key),                     // AES encryption key
        .out(bc_buses_out[0]),                 // Encrypted output
		.done_flag(done_flag),
		.r5_flag(fix_r5_flag),
		.i(i)
    );


    reg[1:0] i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
			feedback <= iv;
			i <= 0;
			counter <= 0;
			fix_r5_flag <= 0;
        end 	
    end
	
	assign plaintext_blocks[0] = plaintext[179:52]; // First 128 bits
    assign plaintext_blocks[1] = {76'b0, plaintext[51:0]}; // Pad 76 zeros to 52 bits
	
	always @(posedge done_flag[i]) begin
            ciphertext_blocks[i] <= plaintext_blocks[i] ^ bc_buses_out[0];
			if (mode == 0) begin
				feedback <= plaintext_blocks[i] ^ bc_buses_out[i];
			end else if (mode == 1) begin
				feedback <= bc_buses_out[i];
			end else if (mode == 2) begin 
				feedback <= {nonce[127:64], counter[63:0]};
			end
			
            if (i < 1) begin
				i <= i + 1;
				counter <= counter + 1;
			end
		if (i == 3) begin
			fix_r5_flag <= 1;
		end
	end	
	
	
	assign ciphertext = {ciphertext_blocks[1][51:0], ciphertext_blocks[0]};
	
	
endmodule

