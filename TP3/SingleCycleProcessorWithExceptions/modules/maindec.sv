module maindec (
				input logic [10:0] Op,
				input logic ExtIRQ,//Agrego señal (new!) 
				input logic Reset, //Agrego la señal reset. (new!)
				output logic Reg2Loc, MemtoReg, RegWrite,
							 MemRead, MemWrite, Branch, ERet, //(new!)
				output logic [3:0] EStatus, //(new!)
				output logic [1:0] ALUOp, ALUSrc,
				output logic Exc); //Agrego la señal (new!)
	
	logic NotAnInstr;
	
	always_comb begin 
		//Inicializo en 1 -> OPCODE invalido
		NotAnInstr = 0; //(!new)
		{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {'0, '0, '0, '0, '0, '0, '0, '0, '0, '0};
		
		if(Reset == 0) begin
			casez (Op) 
				// LDUR
				11'b111_1100_0010:
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b?, 2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 4'b0000};
				//STUR
				11'b111_1100_0000:  
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b1, 2'b01, 1'b?, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0, 4'b0000};
				// CBZ
				11'b101_1010_0???: 
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b1, 2'b00, 1'b?, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 4'b0000};
				// R-format
				11'b100_0101_1000,//ADD
				11'b110_0101_1000,//SUB
				11'b100_0101_0000,//AND
				11'b101_0101_0000://ORR
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b0, 2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 4'b0000};
				//ERET (R type)
				11'b1101011_0100:
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b0, 2'b00, 1'b?, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01, 1'b1, 4'b0000};
				//MRS (S type)
				11'b1101010_1001: 
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b1, 2'b1?, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b01, 1'b0, 4'b0000};
				//Invalid Opcode
				default: begin
					{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {1'b?, 2'b??, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b??, 1'b0, 4'b0010};
					NotAnInstr = 1; //(new!)
				end
			endcase
		end else
			{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, EStatus} = {'0, '0, '0, '0, '0, '0, '0, '0, '0, '0};
		
		//Seteo salida
		Exc = ExtIRQ || NotAnInstr;
	end
endmodule
