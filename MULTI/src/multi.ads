--  Copyright (c) 2020 University of Southampton.
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.

--  This package defines the specification for MULTI elevator system.
--
--  @author: htson
--  @version: 1.0
with Cabin_Package; use Cabin_Package;
with Button_Package; use Button_Package;
with Floor_Package; use Floor_Package;
with Door_Package; use Door_Package;
with Motor_Package; use Motor_Package;
with Shaft_Package; use Shaft_Package;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package Multi with SPARK_Mode is

   -- The state
   cabins_array : CABINS_ARRAY_Type;
   up_buttons_array : UP_BUTTONS_ARRAY_Type;
   down_buttons_array : DOWN_BUTTONS_ARRAY_Type;

   -- The invariants
   function Invariants(cabins_array : CABINS_ARRAY_Type;
                       up_buttons_array : UP_BUTTONS_ARRAY_Type;
                       down_buttons_array : DOWN_BUTTONS_ARRAY_Type) return Boolean is
     (
      cabins_array in CABINS_ARRAY_Type
      and then (for all n in Cabin_Number => cabins_array(n).floor in 0 .. TOP_FLOOR)
      and then (for all n1 in Cabin_Number =>
                     (for all n2 in Cabin_Number =>
                     (if n1 /= n2 and cabins_array(n1).shaft = cabins_array(n2).shaft
                      then cabins_array(n1).floor /= cabins_array(n2).floor)))
      and then (for all n in Cabin_Number =>
                    (if cabins_array(n).motor = On then cabins_array(n).door = CLOSED))
      and then (for all n in Cabin_Number =>
                     cabins_array(n).floor_buttons_array in FLOOR_BUTTONS_ARRAY_Type)
      and then up_buttons_array in UP_BUTTONS_ARRAY_Type
      and then down_buttons_array in DOWN_BUTTONS_ARRAY_Type
     );


   -- Initialisation to initialise the cabins array to the input array.
   -- Global: variable cabins_array will be changed (Output)
   -- Depends: The final value of cabins_array only depend on the input array
   -- Post-condition: The cabins_array is the same as the input array
   procedure INITIALISATION(init_cabins_array : in CABINS_ARRAY_Type) with
     Global => (Output => (cabins_array, up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => init_cabins_array,
                 up_buttons_array => null,
                 down_buttons_array => null),
     Pre => init_cabins_array in CABINS_ARRAY_Type
     and then (for all n in Cabin_Number => init_cabins_array(n).floor in 0 .. TOP_FLOOR)
     and then (for all n1 in Cabin_Number =>
                     (for all n2 in Cabin_Number =>
                     (if n1 /= n2 and init_cabins_array(n1).shaft = init_cabins_array(n2).shaft
                      then init_cabins_array(n1).floor /= init_cabins_array(n2).floor)))
     and then (for all n in Cabin_Number =>
                    (if init_cabins_array(n).motor = On then init_cabins_array(n).door = CLOSED))
     and then (for all n in Cabin_Number =>
                     init_cabins_array(n).floor_buttons_array in FLOOR_BUTTONS_ARRAY_Type),
     Post => (cabins_array = init_cabins_array
              and (for all i in up_buttons_array'Range => not(up_buttons_array(i)))
              and (for all i in down_buttons_array'Range => not(down_buttons_array(i)))
              and Invariants(cabins_array, up_buttons_array, down_buttons_array)
     );


   -- Events
   procedure MovesUp(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (cabins_array, n)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).shaft = Up
     and then cabins_array(n).floor /= TOP_FLOOR
     and then (for all n2 in Cabin_Number =>
                 (if cabins_array(n2).shaft = UP then
                   cabins_array(n2).floor /= cabins_array(n).floor + 1))
     and then cabins_array(n).motor = On,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).floor = cabins_array'Old(n).floor + 1
     and then (for all i in Cabin_Number =>
        (if i /= n then cabins_array(i).floor = cabins_array'Old(i).floor));

   procedure MovesDown(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (cabins_array, n)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).shaft = Down
     and then cabins_array(n).floor /= 0
     and then (for all n2 in Cabin_Number =>
                 (if cabins_array(n2).shaft = Down then
                   cabins_array(n2).floor /= cabins_array(n).floor - 1))
     and then cabins_array(n).motor = On,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).floor = cabins_array'Old(n).floor - 1
     and then (for all i in Cabin_Number =>
        (if i /= n then cabins_array(i).floor = cabins_array'Old(i).floor));

   procedure CabinUpToDown(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (cabins_array, n)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).shaft = Up
     and then cabins_array(n).floor = TOP_FLOOR
     and then (for all n2 in Cabin_Number =>
                 (if cabins_array(n2).shaft = Down then
                   cabins_array(n2).floor /= TOP_FLOOR))
     and then cabins_array(n).motor = On,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).shaft = Down
     and then (for all i in Cabin_Number =>
        (if i /= n then cabins_array(i).floor = cabins_array'Old(i).floor));

   procedure CabinDownToUp(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (cabins_array, n)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).shaft = Down
     and then cabins_array(n).floor = 0
     and then (for all n2 in Cabin_Number =>
                 (if cabins_array(n2).shaft = Up then
                   cabins_array(n2).floor /= 0))
     and then cabins_array(n).motor = On,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).shaft = Up
     and then (for all i in Cabin_Number =>
        (if i /= n then cabins_array(i).floor = cabins_array'Old(i).floor));

   -- Specification for a function for computing whether or not a cabin should
   -- stop while going up.
   -- Global: refer to cabins_array and up_buttons_array as input (Input)
   -- Depends: The result of the function depends on the input c, the cabins array and
   -- the up buttons array
   -- The postcondition specifies that the result is the same as the expression
   -- function MustStopGoingUpFunc
   function MustStopGoingUp(c : CABIN_Type) return Boolean with
     Global => (Input => (cabins_array, up_buttons_array),
                Proof_In => down_buttons_array),
     Depends => (MustStopGoingUp'Result => (c, cabins_array, up_buttons_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then (for some n in Cabin_Number => c = cabins_array(n)),
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then MustStopGoingUp'Result =
       (c.floor_buttons_array(c.floor)
        or (c.floor /= TOP_FLOOR and then up_buttons_array(c.floor))
        or (c.floor = TOP_FLOOR and
            (for some j in Cabin_Number =>
                cabins_array(j).floor = TOP_FLOOR
              and
                cabins_array(j).shaft = Down))
        or (c.floor /= TOP_FLOOR and
             (for some j in Cabin_Number =>
                cabins_array(j).floor = c.floor + 1
              and
                cabins_array(j).shaft = c.shaft)
         )
       );

   -- Specification for a function for computing whether or not a cabin should
   -- stop while going up.
   -- Global: refer to cabins_array and up_buttons_array as input (Input)
   -- Depends: The result of the function depends on the input c, the cabins array and
   -- the up buttons array
   -- The postcondition specifies that the result is the same as the expression
   -- function MustStopGoingUpFunc
   function MustStopGoingDown(c : CABIN_Type) return Boolean with
     Global => (Input => (cabins_array, down_buttons_array),
                Proof_In => up_buttons_array),
     Depends => (MustStopGoingDown'Result => (c, cabins_array, down_buttons_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then (for some n in Cabin_Number => c = cabins_array(n)),
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then MustStopGoingDown'Result =
       (c.floor_buttons_array(c.floor)
        or (c.floor /= 0 and then down_buttons_array(c.floor))
        or (c.floor = 0 and
            (for some j in Cabin_Number =>
                cabins_array(j).floor = 0
              and
               cabins_array(j).shaft = Up))
        or (c.floor /= 0 and
             (for some j in Cabin_Number =>
                cabins_array(j).floor = c.floor - 1
              and
                cabins_array(j).shaft = c.shaft)
         )
       );

   -- Procedure to stop the motor while going up
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: the motor is on and moving in Up shaft and the condition
   -- for stopping holds
   -- Postcondition the motor is off
   procedure MotorStopsGoingUp(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = On
     and then cabins_array(n).shaft = Up
     and then MustStopGoingUp(cabins_array(n)),
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = Off;

   -- Procedure to stop the motor while going down
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: the motor is on and moving in Down shaft and the condition
   -- for stopping holds
   -- Postcondition the motor is off
   procedure MotorStopsGoingDown(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = On
     and then cabins_array(n).shaft = Down
     and then MustStopGoingDown(cabins_array(n)),
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = Off;

   -- Procedure to start the motor while going up
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: the motor is off and moving in Up shaft, door is closed and the condition
   -- for stopping does not hold
   -- Postcondition the motor is on
   procedure MotorStartsGoingUp(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = Off
     and then cabins_array(n).shaft = Up
     and then cabins_array(n).door = CLOSED
     and then not MustStopGoingUp(cabins_array(n)),
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = On;

   -- Procedure to start the motor while going down
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: the motor is off and moving in Down shaft, door is closed and the condition
   -- for stopping does not hold
   -- Postcondition the motor is on
   procedure MotorStartsGoingDown(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = Off
     and then cabins_array(n).shaft = Down
     and then cabins_array(n).door = CLOSED
     and then not MustStopGoingDown(cabins_array(n)),
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).motor = On;

   -- Procedure to move the door from Open to Half
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: door is open
   -- Postcondition the door is Half
   procedure DoorOpenToHalf(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = OPEN,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Half;

   -- Procedure to move the door from half to closed
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: door is half
   -- Postcondition the door is closed
   procedure DoorHalfToClosed(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Half,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Closed;

   -- Procedure to move the door from Closed to Half
   -- Global: This procedure refers to cabins_array and up/down_buttons_array in the
   -- Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: door is closed and motor is off
   -- Postcondition the door is half
   procedure DoorClosedToHalf(n : in Cabin_Number) with
     Global => (In_Out => cabins_array,
                Proof_In => (up_buttons_array, down_buttons_array)),
     Depends => (cabins_array => (n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Closed
     and then cabins_array(n).motor = Off,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Half;

   -- Procedure to move the door from Half to Open while going up
   -- Global: This procedure refers to cabins_array and up_buttons_array,
   -- down_buttons_array is in the Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: door is Half
   -- Postcondition the door is Open, up button and floor button is cleared
   procedure DoorHalfToOpenGoingUp(n : in Cabin_Number) with
     Global => (In_Out => (cabins_array, up_buttons_array),
                Proof_In => down_buttons_array),
     Depends => (cabins_array => (n, cabins_array),
                 up_buttons_array => (n, cabins_array, up_buttons_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Half,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Open
     and then cabins_array(n).floor_buttons_array(cabins_array(n).floor) = False
     and then (if cabins_array(n).floor /= TOP_FLOOR
                   then up_buttons_array(cabins_array(n).floor) = False);

   -- Procedure to move the door from Half to Open while going down
   -- Global: This procedure refers to cabins_array and down_buttons_array,
   -- up_buttons_array is in the Precondition only (Proof_In)
   -- Depends: This procedure updates cabin number n
   -- Precondition: door is Half
   -- Postcondition the door is Open, down button and floor button is cleared
   procedure DoorHalfToOpenGoingDown(n : in Cabin_Number) with
     Global => (In_Out => (cabins_array, down_buttons_array),
                Proof_In => up_buttons_array),
     Depends => (cabins_array => (n, cabins_array),
                 down_buttons_array => (n, cabins_array, down_buttons_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Half,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).door = Open
     and then cabins_array(n).floor_buttons_array(cabins_array(n).floor) = False
     and then (if cabins_array(n).floor /= 0
                   then down_buttons_array(cabins_array(n).floor) = False);

   -- Procedure to press up button
   -- Global: This procedure refers to up_buttons_array. cabins_array and
   -- down_buttons_array is in the Precondition only (Proof_In)
   -- Depends: This procedure updates up buttons array
   -- Precondition: f is between 0 and TOP_FLOOR - 1, up button is not pressed
   -- Postcondition up button is pressed
   procedure UserPressesUpButton(f : in Integer) with
     Global => (In_Out => (up_buttons_array),
                Proof_In => (cabins_array, down_buttons_array)),
     Depends => (up_buttons_array => (f, up_buttons_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then f in 0 .. TOP_FLOOR - 1
     and then up_buttons_array(f) = False,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then up_buttons_array(f) = True;

   -- Procedure to press down button
   -- Global: This procedure refers to down_buttons_array. cabins_array and
   -- up_buttons_array is in the Precondition only (Proof_In)
   -- Depends: This procedure updates down_buttons_array
   -- Precondition: f is between 1 and TOP_FLOOR, down button is not pressed
   -- Postcondition down button is pressed
   procedure UserPressesDownButton(f : in Integer) with
     Global => (In_Out => (down_buttons_array),
                Proof_In => (cabins_array, up_buttons_array)),
     Depends => (down_buttons_array => (f, down_buttons_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then f in 1 .. TOP_FLOOR
     and then down_buttons_array(f) = False,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then down_buttons_array(f) = True;

   -- Procedure to press floor button
   -- Global: This procedure refers to cabins_array. down_buttons_array and
   -- up_buttons_array is in the Precondition only (Proof_In)
   -- Depends: This procedure updates down_buttons_array
   -- Precondition: f is between 0 and TOP_FLOOR
   -- Postcondition down button is pressed
   procedure UserPressesFloorButton(n : in CABIN_Number; f : in Integer) with
     Global => (In_Out => (cabins_array),
                Proof_In => (down_buttons_array, up_buttons_array)),
     Depends => (cabins_array => (f, n, cabins_array)),
     Pre => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then f in 0 .. TOP_FLOOR
     and then cabins_array(n).floor_buttons_array(f) = False,
     Post => Invariants(cabins_array, up_buttons_array, down_buttons_array)
     and then cabins_array(n).floor_buttons_array(f) = True;

   procedure Show with
     Global => (Input => (Default_Width,
                          Default_Base,
                          cabins_array,
                          up_buttons_array,
                          down_buttons_array),
                In_Out => File_System
               );

end Multi;
