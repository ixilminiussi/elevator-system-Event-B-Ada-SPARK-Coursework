with Ada.Text_IO;use Ada.Text_IO;
with Cabin_Package;use Cabin_Package;
with Ada.Integer_Text_IO;use Ada.Integer_Text_IO;

package body MULTI with SPARK_Mode is

   procedure INITIALISATION(init_cabins_array : in CABINS_ARRAY_Type) is
   begin
      cabins_array := init_cabins_array;
      up_buttons_array := (others => False);
      down_buttons_array := (others => False);
   end INITIALISATION;

   procedure MovesUp(n : in Cabin_Number) is
   begin
      cabins_array(n).floor := cabins_array(n).floor + 1;
   end MovesUp;

   procedure MovesDown(n : in Cabin_Number) is
   begin
      cabins_array(n).floor := cabins_array(n).floor - 1;
   end MovesDown;

   procedure CabinUpToDown(n : in Cabin_Number) is
   begin
      cabins_array(n).shaft := Down;
   end CabinUpToDown;

   procedure CabinDownToUp(n : in Cabin_Number) is
   begin
      cabins_array(n).shaft := Up;
   end CabinDownToUp;

   function MustStopGoingUp(c : CABIN_Type) return Boolean
   is
   begin
      if c.floor_buttons_array(c.floor) then
         return True;
      else
         if c.floor = TOP_FLOOR then
            for j in 1 .. MAX_CABIN loop
               if cabins_array(j).floor = TOP_FLOOR and cabins_array(j).shaft = Down then
                  return True;
               end if;
            end loop;
         else -- c.floor /= TOP_FLOOR
            if up_buttons_array(c.floor) then
               return True;
            end if;
            for j in 1 .. MAX_CABIN loop
               if cabins_array(j).floor = c.floor + 1 and cabins_array(j).shaft = c.shaft then
                  return True;
               end if;
            end loop;
         end if;
      end if;
      return False;
   end MustStopGoingUp;

   function MustStopGoingDown(c : CABIN_Type) return Boolean
   is
   begin
      if c.floor_buttons_array(c.floor) then
         return True;
      else
         if c.floor = 0 then
            for j in 1 .. MAX_CABIN loop
               if cabins_array(j).floor = 0 and cabins_array(j).shaft = Up then
                  return True;
               end if;
            end loop;
         else -- c.floor /= 0
            if down_buttons_array(c.floor) then
               return True;
            end if;
            for j in 1 .. MAX_CABIN loop
               if cabins_array(j).floor = c.floor - 1 and cabins_array(j).shaft = c.shaft then
                  return True;
               end if;
            end loop;
         end if;
      end if;
      return False;
   end MustStopGoingDown;

   procedure MotorStopsGoingUp(n : in Cabin_Number) is
   begin
      cabins_array(n).motor := Off;
   end MotorStopsGoingUp;

   procedure MotorStopsGoingDown(n : in Cabin_Number) is
   begin
      cabins_array(n).motor := Off;
   end MotorStopsGoingDown;

   procedure MotorStartsGoingUp(n : in Cabin_Number) is
   begin
      cabins_array(n).motor := On;
   end MotorStartsGoingUp;

   procedure MotorStartsGoingDown(n : in Cabin_Number) is
   begin
      cabins_array(n).motor := On;
   end MotorStartsGoingDown;

   procedure DoorOpenToHalf(n : in Cabin_Number) is
   begin
      cabins_array(n).door := Half;
   end DoorOpenToHalf;

   procedure DoorHalfToClosed(n : in Cabin_Number) is
   begin
      cabins_array(n).door := Closed;
   end DoorHalfToClosed;

   procedure DoorClosedToHalf(n : in Cabin_Number) is
   begin
      cabins_array(n).door := Half;
   end DoorClosedToHalf;

   procedure DoorHalfToOpenGoingUp(n : in Cabin_Number) is
      floor : Integer := cabins_array(n).floor;
   begin
      cabins_array(n).door := Open;
      cabins_array(n).floor_buttons_array(floor) := False;
      if floor /= TOP_FLOOR then
         up_buttons_array(floor) := False;
      end if;
   end DoorHalfToOpenGoingUp;

   procedure DoorHalfToOpenGoingDown(n : in Cabin_Number) is
      floor : Integer := cabins_array(n).floor;
   begin
      cabins_array(n).door := Open;
      cabins_array(n).floor_buttons_array(floor) := False;
      if floor /= 0 then
         down_buttons_array(floor) := False;
      end if;
   end DoorHalfToOpenGoingDown;

   procedure UserPressesUpButton(f : in Integer) is
   begin
      up_buttons_array(f) := True;
   end UserPressesUpButton;

   procedure UserPressesDownButton(f : in Integer) is
   begin
      down_buttons_array(f) := True;
   end UserPressesDownButton;

   procedure UserPressesFloorButton(n : in Cabin_Number; f : in Integer) is
   begin
      cabins_array(n).floor_buttons_array(f) := True;
   end UserPressesFloorButton;

   procedure Show is
   begin
      for i in cabins_array'Range loop
         Put("Cabin ");
         Put(i);
         Put_Line("");
         Show(cabins_array(i));
      end loop;
      Put_Line("");
      Put("Enabled up buttons -> ");
      for i in up_buttons_array'Range loop
         if up_buttons_array(i) then
            Put(i); Put(",");
         end if;
      end loop;
      Put_Line("");
      Put("Enabled down buttons -> ");
      for i in down_buttons_array'Range loop
         if down_buttons_array(i) then
            Put(i); Put(",");
         end if;
      end loop;
      Put_Line("");
      Put_Line("---------");
   end Show;

end MULTI;
