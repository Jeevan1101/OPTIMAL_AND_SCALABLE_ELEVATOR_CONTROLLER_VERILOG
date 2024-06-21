`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  Midatana Jeevan Kumar 
// Design Name:  scalable and optimized elevator controller using verilog for 8 floors
// Module Name: elevator_design
// Project Name:  scalable and optimized elevator controller using verilog
//////////////////////////////////////////////////////////////////////////////////


module elevator_design(clock,reset,req_floor,emergency,over_weight,IR_sensor,up,down,idle,door,max_request,min_request,emergency_stop,current_floor,requests);
input clock , reset , emergency ;
input over_weight ; // if weight exceeds particular value then door will remain open 
input IR_sensor ; // if the lift door is open and if ir sensor which detects the obstacles gives 1 output then lift door will remain open
input [2:0] req_floor ;
output reg up ; // up=1 moving in the upward direction up=0 not moving in the upward direction
output reg down ;  // down=1 moving in the downward direction up=0 not moving in the downward direction
output reg idle ; // idle= 1 means not moving it is in idle state at some floor
output reg door ; // door= 1 means the lift door is open door=0 lift door is closed
output reg emergency_stop ; // emergency_stop=1 indicates that there is emeregncy condition
output reg [2:0] max_request ; // max_request - highest floor number in the requests obtained
output reg [2:0] min_request ;  //min_request- lowest floor number in the requests obtained 
output reg [2:0] current_floor ; // indicates current floor of the elevator 
output reg [7:0] requests ;  //  8 bit number indicating the 8 floors and their requests . each bit correspond to the each floor if the particualr bits value is that indicate request is there on that floor

// internal variable declarations 
reg door_timing_control ; // it will control the amount of the time that the door will open
reg flag=0  ; // it is used to take the system out from the emergency state ;

// IMPLEMENTING THE STATE MACHINE OF THE REQUEST_HANDLING BASED ON INPUT REQ_FLOOR 
 always @ (req_floor) 
begin

    requests[req_floor]=1 ;
    // based on the req_floor updating the max_request 
    if(max_request < req_floor ) 
                 begin
                      max_request=req_floor ;
                 end
      // based on the req_floor updating the min_request 
    if(min_request > req_floor ) 
                begin
                      min_request=req_floor ;
                end
    // if requests[max_request]==0 means the lift reached that floor now lift goes down if now higher floor is entered we needed to modify the max_request and similar we need to update the min_request
    // updating max_request and min_request for the above case 
    if(requests[max_request]==0 && (req_floor > current_floor) )
                begin
                     max_request=req_floor ;
                end
    if(requests[min_request]==0 && (req_floor < current_floor) ) 
                begin
                     min_request=req_floor ;
                end
                
end
// ckecking if  req_floor = current_floor and updating all the reqired parameters 
always @ (current_floor) 
begin

  if (requests[current_floor]==1) 
            begin
             door=1 ;
             door_timing_control=1 ;
             idle=1 ;
             requests[current_floor]=0 ;
            end

end

//  DESIGN OF FSM FOR LIFT OPERATION IN NORMAL MODE , OVER_WEIGHT , EMERGENCY , IR_SENSOR MODES

always @ (posedge clock) 
begin

      // checking for reset state 
      if(reset) 
               begin
                       up<=1 ;
                       down<=0 ;
                       door<=0 ;
                       idle<=1 ;
                       current_floor<=0 ;
                       requests<=0 ;
                       max_request<=0 ;
                       min_request<=7 ;
                       emergency_stop<=0 ;
                       flag<=0 ;
               end
      // if there are no request and no emergency stay idle at the recent floor
     else if(requests==0 && ! reset  && !emergency && !IR_sensor) 
                begin
                         current_floor<=current_floor ;
                         door<=0 ;
                         idle=1 ;
                         emergency_stop<=0 ;
                         door_timing_control<=0 ;
                end
      // staying for oneclock pulse when req_floor = current_floor and opeing the door and controlling the ir_sensor and overweight
    else if(door_timing_control==1) 
               begin
                         if(over_weight==1) door_timing_control<=1 ;
                         else if(IR_sensor==1) door_timing_control<=1 ;
                         else 
                              begin
                                     door<=0 ;
                                     idle<=0 ;
                                     door_timing_control<=0 ;
                              end
               end     
       //  controlling the emergency options    
      else if(emergency) 
              begin
                     emergency_stop<=1 ;
                     flag<=1 ;
                     idle<=1 ;
                     door<=1 ;
              end
      else if (!emergency && flag==1) 
              begin
                  emergency_stop<=0 ;
                  flag<=0 ;
                  idle<=0 ;
                  door<=0 ;
              end
        // normal operation of the lift 
       else 
              begin
              //  updating the upward motion of the elevator 
              if(max_request>current_floor && up==1) 
                           begin
                                   current_floor<=current_floor+1 ;
                                   door<=0 ;
                                   idle<=0 ;
                           end
               //  updating the downward motion of the elevator 
              else if(min_request<current_floor && down==1) 
                           begin
                                   current_floor<=current_floor-1 ;
                                   door<=0 ;
                                   idle<=0 ;
                           end
              else if (max_request==current_floor)
                          begin
                             up<=0 ;
                             down<=1 ;
                          end 
              else if (min_request==current_floor)
                          begin
                             down<=0 ;
                             up<=1 ;
                          end 
              end     
              
end
