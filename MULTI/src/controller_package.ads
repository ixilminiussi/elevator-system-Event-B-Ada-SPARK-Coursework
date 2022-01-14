with Button_Package; use Button_Package;
with Door_Package; use Door_Package;
with Multi; use Multi;
with Cabin_Package; use Cabin_Package;
with Shaft_Package; use Shaft_Package;
with Floor_Package; use Floor_Package;
with Motor_Package; use Motor_Package;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package Controller_Package with SPARK_Mode is

   door_closing : array (Integer range 0 .. TOP_FLOOR) of Boolean := (others => False);
   -- The current status of the door

   procedure motor_controller with
     Global => (Input => (Default_Width,
                          Default_Base,
                          up_buttons_array,
                          down_buttons_array),
                In_Out => (File_System,
                           cabins_array)
               ),
     Pre => Invariants(cabins_array,
                       up_buttons_array,
                       down_buttons_array),
     Post => Invariants(cabins_array,
                           up_buttons_array,
                           down_buttons_array);

   procedure door_controller with
     Global => (Input => (Default_Width,
                          Default_Base),
                In_Out => (File_System,
                           cabins_array,
                           door_closing,
                           up_buttons_array,
                           down_buttons_array)
               ),
     Pre => Invariants(cabins_array,
                       up_buttons_array,
                       down_buttons_array),
     Post => Invariants(cabins_array,
                        up_buttons_array,
                        down_buttons_array);

end Controller_Package;
