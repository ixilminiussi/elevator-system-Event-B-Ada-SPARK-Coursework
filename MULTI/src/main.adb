with User_Package; use User_Package;
with Environment_Package; use Environment_Package;
with Controller_Package; use Controller_Package;
with Cabin_Package; use Cabin_Package;
with Multi; use Multi;
with Motor_Package; use Motor_Package;
with Door_Package; use Door_Package;
with Shaft_Package; use Shaft_Package;
with Ada.Text_IO;

procedure Main with SPARK_Mode is
   continue : Character := 'y';
   init_cabins_array : CABINS_ARRAY_Type;
begin

   for n in Cabin_Number loop
      init_cabins_array(n) := (floor => n,
                               motor => Off,
                               door => OPEN,
                               shaft => Up,
                               floor_buttons_array => (others => False));
   end loop;

   -- Initialisation
   INITIALISATION(init_cabins_array);

   -- Print
   Show;

   while continue = 'y' loop
      pragma Loop_Invariant (Invariants(
                        cabins_array,
                        up_buttons_array,
                        down_buttons_array));

      user; -- Get the user input

      motor_controller; -- Control the motor

      door_controller; -- Control the door

      environment; -- Change in the environment (cabins move)

      Show; -- Show the status of the system

      Ada.Text_IO.Put(" Continue? ");

      Ada.Text_IO.Get(continue);
   end loop;

end Main;
