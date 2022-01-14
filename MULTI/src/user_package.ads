with Button_Package; use Button_Package;
with Door_Package; use Door_Package;
with Cabin_Package; use Cabin_Package;
with Multi; use Multi;
with Floor_Package; use Floor_Package;
with Motor_Package; use Motor_Package;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package User_Package with SPARK_Mode is

   procedure user with
     Global => (Input => (Default_Width,
                          Default_Base),
                In_Out => (File_System,
                          cabins_array,
                          up_buttons_array,
                          down_buttons_array)
               ),
     Pre => Invariants(cabins_array,
                       up_buttons_array,
                       down_buttons_array),
     Post => Invariants(cabins_array,
                          up_buttons_array,
                          down_buttons_array);
end User_Package;
