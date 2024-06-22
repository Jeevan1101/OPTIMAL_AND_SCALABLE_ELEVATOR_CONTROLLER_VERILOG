`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  Midatana Jeevan Kumar 
// Design Name:  scalable and optimized elevator controller using verilog for 8 floors
// Module Name: elevator_design
// Project Name:  scalable and optimized elevator controller using verilog
//////////////////////////////////////////////////////////////////////////////////


module testbench2_elevator_controller();
reg clock , reset , emergency , over_weight , IR_sensor ;
reg [2:0] req_floor ;
wire up,down,idle,door,emergency_stop ;
wire [2:0] min_request , max_request ;
wire [2:0] current_floor ;
wire [7:0] requests ;

// module instantiating 
elevator_design DUT2(clock,reset,req_floor,emergency,over_weight,IR_sensor,up,down,idle,door,max_request,min_request,emergency_stop,current_floor,requests);

initial 
     begin
      clock=1'b0 ;
      $dumpfile("elevator2.vcd") ;
      $dumpvars(0,testbench2_elevator_controller) ;
     end
always #5 clock=~clock ;
initial 
      begin
        over_weight=0 ;
        IR_sensor=0 ;
        reset=1 ;
        #10 reset=0 ;
         req_floor=6 ;
      end
initial 
      begin
      #30 req_floor=7 ;
      #20 req_floor=5 ;
      #20 req_floor=1 ;
      #30 req_floor=6 ;
      #25 req_floor=3 ;
      #30 req_floor=4 ;
      #50 req_floor=6 ;
      end
   initial  
         begin
          $display(" SIMULATION RESULTS OBTAINED : ") ;
          $monitor(" time=%t , clock=%b , reset=%b , req_floor=%h , emergency=%b , IR_sensor=%b , overweight = %b , up=%b , down=%b, idle=%b , door=%b , Emergency_stop=%b , current_floor=%h , min_request=%h , max_request=%h , requests=%h ",$time,clock,reset,req_floor,emergency,IR_sensor,over_weight,up,down,idle,door,emergency_stop,current_floor,min_request,max_request,requests) ;
          #500 ;
          $display("SIMULATION COMPLETED ! ") ;
          $finish ; 
         end   
        
endmodule
