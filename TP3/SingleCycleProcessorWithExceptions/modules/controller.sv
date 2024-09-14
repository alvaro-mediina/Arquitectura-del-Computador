// CONTROLLER

module controller(input logic [10:0] instr,
				  input logic ExtIRQ, reset, ExcAck,
				  output logic reg2loc, regWrite, AluSrc, Branch,
							      memtoReg, memRead, memWrite,
				  output logic [3:0] AluControl, EStatus,						
				  output logic ERet, Exc, ExtlAck);
											
	logic [1:0] AluOp_s;
											
	maindec 	decPpal 	(.Op(instr),
							.ExtIRQ(ExtIRQ), //(new!)
							.Reset(reset),
							.Reg2Loc(reg2loc), 
							.MemtoReg(memtoReg), 
							.RegWrite(regWrite), 
							.MemRead(memRead), 
							.MemWrite(memWrite), 
							.Branch(Branch), 
							.ERet(ERet), //(new!)
							.EStatus(EStatus), //(new!)
							.ALUOp(AluOp_s),
							.ALUSrc(AluSrc),
							.Exc(Exc));
					
								
	aludec 	decAlu 	(.funct(instr), 
							.aluop(AluOp_s), 
							.alucontrol(AluControl));
							
	assign ExtlAck = (ExcAck == 1'b1 && ExtIRQ == 1'b1) ? 1'b1 : 1'b0;
			
endmodule
