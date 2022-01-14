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

--  This package defines the cabin record type.
--
--  @author: htson
--  @version: 1.0
with Button_Package; use Button_Package;
with Door_Package; use Door_Package;
with Floor_Package; use Floor_Package;
with Motor_Package; use Motor_Package;
with Shaft_Package; use Shaft_Package;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package Cabin_Package with SPARK_Mode is
   -- The maximum number of cabins in the system
   MAX_CABIN : constant Positive := 2;

   subtype Cabin_Number is Integer range 1 .. MAX_CABIN;

   type CABIN_Type is record
      floor : Integer; -- The current floor of the cabin
      motor : MOTOR_Type; -- The current status of the cabin motor
      door : DOOR_Type;   -- The current status of the door
      shaft : SHAFT_Type; -- The current shaft of the cabin
      -- The current floor buttons status inside the cabin
      floor_buttons_array : FLOOR_BUTTONS_ARRAY_Type;
   end record;

   -- The type for arrays of MAX_CABIN cabins
   type CABINS_ARRAY_Type is array (Cabin_Number) of CABIN_Type;

   procedure Show(c : CABIN_Type) with
     Global => (Input => (Default_Width, Default_Base),
                In_Out => File_System
               );

end Cabin_Package;
