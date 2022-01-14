package body User_Package with SPARK_Mode is

   procedure user is
      choice : Character := 'x';
      floor : Integer;
      cabin : Integer;

      procedure ControlPanel is
      begin
         Put_Line( "=== Control Panel ===" ) ;
         Put_Line( "(f) Press a Floor button" ) ;
         Put_Line( "(u) Press an Up button" ) ;
         Put_Line( "(d) Press a Down button" ) ;
         Put_Line( "(e) End user input" ) ;
         Put_Line( "======================" ) ;
      end ControlPanel;
   begin
      while choice /= 'e' loop
         pragma Loop_Invariant (Invariants(cabins_array, up_buttons_array, down_buttons_array));
         ControlPanel;
         Put( "Please enter your selection? " ) ;
         Get(choice);
         case choice is
         when 'f' =>
            Put( "    Which cabin? " );
            Get(cabin);
            if 1 <= cabin and cabin <= MAX_CABIN then
               Put( "    Which floor button? " ) ;
               Get(floor);
               if 0 <= floor and floor <= TOP_FLOOR then
                  if cabins_array(cabin).floor_buttons_array(floor) then
                     Put_Line(" Floor button is already pressed ");
                  else
                     UserPressesFloorButton(cabin, floor);
                     Put("=User= Presses FLOOR button ");
                     Put(floor);
                     Put(" for cabin ");
                     Put(cabin);
                     Put_Line("");
                     Show;
                  end if;
               else
                  Put_Line("Invalid floor button");
               end if;
            else
               Put_Line("Invalid cabin");
            end if;
         when 'u' =>
            Put( "    Which up button? " ) ;
            Get(floor);
            if 0 <= floor and floor < TOP_FLOOR then
               if up_buttons_array(floor) then
                  Put_Line(" Up button is already pressed ");
               else
                  UserPressesUpButton(floor);
                  Put("=User= Presses UP button ");
                  Put(floor);
                  Put_Line("");
                  Show;
               end if;
            else
              Put_Line("Invalid up button");
            end if;
         when 'd' =>
            Put( "    Which down button? " ) ;
            Get(floor);
            if 0 < floor and floor <= TOP_FLOOR then
               if down_buttons_array(floor) then
                  Put_Line(" Down button is already pressed ");
               else
                  UserPressesDownButton(floor);
                  Put("=User= Presses DOWN button ");
                  Put(floor);
                  Put_Line("");
                  Show;
               end if;
            else
              Put_Line("Invalid down button");
            end if;
         when others => null;
         end case;
      end loop;
   end user;

end User_Package;
