`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  Midatana Jeevan Kumar 
// Design Name:  scalable and optimized elevator controller using verilog for 8 floors
// Module Name: elevator_design
// Project Name:  scalable and optimized elevator controller using verilog
//////////////////////////////////////////////////////////////////////////////////


module test_bench_elevatorcontroller();
reg clock , reset , emergency , over_weight , IR_sensor ;
reg [2:0] req_floor ;
wire up,down,idle,door,emergency_stop ;
wire [2:0] min_request , max_request ;
wire [2:0] current_floor ;
wire [7:0] requests ;

// module instantiating 
elevator_design DUT(clock,reset,req_floor,emergency,over_weight,IR_sensor,up,down,idle,door,max_request,min_request,emergency_stop,current_floor,requests);

initial 
     begin
      clock=1'b0 ;
      $dumpfile("elevator.vcd") ;
      $dumpvars(0,test_bench_elevatorcontroller) ;
     end
always #5 clock=~clock ;
initial 
     begin
     over_weight=0 ;
     IR_sensor=0 ;
     emergency=0 ;
     reset=1 ;
     #10 ;
     reset=0 ;
     req_floor=1 ;
     #30 ;
     req_floor=4 ;
     #10 ; 
     req_floor = 3; // Request floor 3
    #20;
    req_floor = 7; // Request floor 5
    #20;
    emergency = 1; // Activate emergency stop
    #20;
    emergency = 0; // Deactivate emergency stop
    #10;
    req_floor = 2; // Request floor 2
    #40;
    req_floor = 6; // Request floor 6
    #40 ;
    req_floor = 1;
    #80 ;
    req_floor=5 ;
     end 
   //  testing the working of the over_weight
   initial 
        begin
           #170 over_weight=1 ;
           #20 over_weight= 0 ;
        end
    //  testing the working of IR_sensor 
   initial 
         begin
         #327 IR_sensor=1 ;
         #30 IR_sensor=0 ;
         end 
    // Displaying the simulation results 
   initial  
         begin
          $display(" SIMULATION RESULTS OBTAINED : ") ;
          $monitor(" time=%t , clock=%b , reset=%b , req_floor=%h , emergency=%b , IR_sensor=%b , overweight = %b , up=%b , down=%b, idle=%b , door=%b , Emergency_stop=%b , current_floor=%h , min_request=%h , max_request=%h , requests=%h ",$time,clock,reset,req_floor,emergency,IR_sensor,over_weight,up,down,idle,door,emergency_stop,current_floor,min_request,max_request,requests) ;
          #500 ;
          $display("SIMULATION COMPLETED ! ") ;
          $finish ; 
         end   
      
endmodule