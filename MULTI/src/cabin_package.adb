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

--  This package implement the print function for Cabin.
--
--  @author: htson
--  @version: 1.0
package body Cabin_Package with SPARK_Mode is
   procedure Show(c : CABIN_Type) is
   begin
      Put("Floor -> ");Put(Integer'Image(c.floor)); Put(", ");
      Put("Shaft -> ");Put(SHAFT_Type'Image(c.shaft)); Put(", ");
      Put("Motor -> "); Put(MOTOR_Type'Image(c.motor)); Put(", ");
      Put("Door -> "); Put(DOOR_Type'Image(c.door)); Put_Line("");
      Put("Enabled floor buttons -> ");
      for i in c.floor_buttons_array'Range loop
         if c.floor_buttons_array(i) then
            Put(i); Put(",");
         end if;
      end loop;
      Put_Line("");
      Put_Line("---------");
   end Show;
end Cabin_Package;
