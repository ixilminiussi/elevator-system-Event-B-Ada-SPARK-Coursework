package body Environment_Package with SPARK_Mode is

   function HasCabinAbove(n : in Cabin_Number) return Boolean is
   begin
      -- Task B3. Provide the implementation for this using FOR loop
      for i in cabins_array'Range loop
         if cabins_array(i).shaft = cabins_array(n).shaft then
            if cabins_array(i).floor = cabins_array(n).floor + 1 then
                   return True;
            end if;
         end if;
      end loop;
      return False;
   end HasCabinAbove;
   
   function HasCabinBelow(n : in Cabin_Number) return Boolean is
   begin
      -- Task B3. Provide the implementation for this using FOR loop
      for i in cabins_array'Range loop
         if cabins_array(i).shaft = cabins_array(n).shaft then
            if cabins_array(i).floor = cabins_array(n).floor - 1 then
                   return True;
            end if;
         end if;
      end loop;
      return False;
   end HasCabinBelow;

   function HasCabinAtBottomUpShaft return Boolean is
      N : Cabin_Number := 1;
   begin
      -- Task B3. Provide the implementation for this using WHILE loop
      -- Remember to have Loop invariant and variant, e.g.,
      -- pragma Loop_Variant (...)
      -- pragma Loop_Invariants (...)
      while N < cabins_array'Length loop
         pragma Loop_Invariant (Invariants(cabins_array, up_buttons_array, down_buttons_array));
         pragma Loop_Variant (Increases => N);
         if (cabins_array(N).shaft = Up and cabins_array(N).floor = 0) then
            return True;
         end if;
         N := N + 1;
      end loop;
      return False;
   end HasCabinAtBottomUpShaft;
   
   function HasCabinAtTopDownShaft return Boolean is
      N : Cabin_Number := 1;
   begin
      -- Task B3. Provide the implementation for this using WHILE loop
      -- Remember to have Loop invariant and variant, e.g.,
      -- pragma Loop_Variant (...)
      -- pragma Loop_Invariants (...)
      while N < cabins_array'Length loop
         pragma Loop_Invariant (Invariants(cabins_array, up_buttons_array, down_buttons_array));
         pragma Loop_Variant (Increases => N);
         if (cabins_array(N).shaft = Down and cabins_array(N).floor = TOP_FLOOR) then
            return True;
         end if;
         N := N + 1;
      end loop;
      return False;               
   end HasCabinAtTopDownShaft;
   
   procedure Environment is
   begin
      for n in Cabin_Number loop
         pragma Loop_Invariant (Invariants(cabins_array, up_buttons_array, down_buttons_array));
         if cabins_array(n).motor = On then
            if cabins_array(n).shaft = Up then
               if cabins_array(n).floor /= TOP_FLOOR then
                  if HasCabinAbove(n) then
                     Put("Cabin ");
                     Put(n);
                     Put_Line("cannot move since there is a cabin above");
                  else
                     MovesUp(n);
                     Put("=Environment= Cabin ");
                     Put(n);
                     Put_Line(" moves up");
                  end if;
               else
                  if HasCabinAtTopDownShaft then
                     Put("Cabin ");
                     Put(n);
                     Put_Line("cannot move since there is a cabin at top down shaft");
                  else
                     CabinUpToDown(n);
                     Put("=Environment= Cabin ");
                     Put(n);
                     Put_Line(" moves from up to down");
                  end if;
               end if;
            else -- Down shaft
               if cabins_array(n).floor /= 0 then
                  if HasCabinBelow(n) then
                     Put("Cabin ");
                     Put(n);
                     Put_Line("cannot move since there is a cabin below");
                  else
                     MovesDown(n);
                     Put("=Environment= Cabin ");
                     Put(n);
                     Put_Line(" moves down");
                  end if;
               else
                  if HasCabinAtBottomUpShaft then
                     Put("Cabin ");
                     Put(n);
                     Put_Line("cannot move since there is a cabin at bottom of up shaft");
                  else
                     CabinDownToUp(n);
                     Put("=Environment= Cabin ");
                     Put(n);
                     Put_Line(" moves from down to up");
                  end if;
               end if;
            end if;
         end if;
      end loop;
   end environment;

end Environment_Package;
