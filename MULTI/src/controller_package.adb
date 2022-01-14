package body Controller_Package with SPARK_Mode is

   procedure motor_controller is
   begin
      for i in Cabin_Number loop
         if cabins_array(i).motor = On then
            if cabins_array(i).shaft = Up then
               if MustStopGoingUp(cabins_array(i)) then
                  MotorStopsGoingUp(i);
                  Put("Stop motor for cabin ");
                  Put(i);
                  Put_Line(" (while going up)");
               end if;
            else -- moving down
               if MustStopGoingDown(cabins_array(i)) then
                  MotorStopsGoingDown(i);
                  Put("Stop motor for cabin ");
                  Put(i);
                  Put_Line(" (while going down)");
               end if;
            end if;
         else -- motor off
            if cabins_array(i).door = Closed then
               if cabins_array(i).shaft = Up then
                  if not MustStopGoingUp(cabins_array(i)) then
                     MotorStartsGoingUp(i);
                     Put("Start motor for cabin ");
                     Put(i);
                     Put_Line(" (to go up)");
                  end if;
               else -- moving down
                  if not MustStopGoingDown(cabins_array(i)) then
                     MotorStartsGoingDown(i);
                     Put("Start motor for cabin ");
                     Put(i);
                     Put_Line(" (to go down)");
                  end if;
               end if;
            end if;
         end if;
      end loop;
   end motor_controller;

   procedure door_controller is
   begin
      for i in Cabin_Number loop
         case cabins_array(i).door is
            when CLOSED =>
               if cabins_array(i).motor = Off then
                  DoorClosedToHalf(i);
                  door_closing(i) := False;
                  Put("Door from Closed to Half for cabin ");
                  Put(i);
                  Put_Line("");
               end if;
            when Open =>
               DoorOpenToHalf(i);
               door_closing(i) := True;
               Put("Door from Open to Half for cabin ");
               Put(i);
               Put_Line("");
            when Half =>
               if door_closing(i) then
                  DoorHalfToClosed(i);
                  Put("Door from Half to Closed for cabin ");
                  Put(i);
                  Put_Line("");
               else
                  if cabins_array(i).shaft = Up then
                     DoorHalfToOpenGoingUp(i);
                     Put("Door from Half to Open for cabin ");
                     Put(i);
                     Put_Line(" (while going up)");
                  else -- going down
                     DoorHalfToOpenGoingDown(i);
                     Put("Door from Half to Open for cabin ");
                     Put(i);
                     Put_Line(" (while going down)");
                  end if;
               end if;
         end case;
      end loop;
   end door_controller;

end Controller_Package;
