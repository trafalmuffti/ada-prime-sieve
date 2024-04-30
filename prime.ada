with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   -- Define the number of primes to find
   Number_Of_Primes : constant Integer := 10;

   -- A protected type for channel communication
   protected type Channel is
      entry Send(Item : Integer);
      entry Receive(Item : out Integer);
   private
      Value : Integer;
      Available : Boolean := False;
   end Channel;

   protected body Channel is
      entry Send(Item : Integer) when not Available is
      begin
         Value := Item;
         Available := True;
      end Send;

      entry Receive(Item : out Integer) when Available is
      begin
         Item := Value;
         Available := False;
      end Receive;
   end Channel;

   -- Task to generate numbers
   task type Generate is
      entry Start(C : access Channel);
   end Generate;

   task body Generate is
      Ch : access Channel;
   begin
      accept Start(C : access Channel) do
         Ch := C;
      end Start;
      
      loop
         for I in 2 .. Integer'Last loop
            Ch.Send(I);
         end loop;
      end loop;
   end Generate;

   -- Task to filter numbers
   task type Filter is
      entry Start(In_C, Out_C : access Channel; Prime : Integer);
   end Filter;

   task body Filter is
      In_Ch, Out_Ch : access Channel;
      Prime : Integer;
      Num : Integer;
   begin
      accept Start(In_C, Out_C : access Channel; Prime : Integer) do
         In_Ch := In_C;
         Out_Ch := Out_C;
         Prime := Prime;
      end Start;

      loop
         In_Ch.Receive(Num);
         if Num mod Prime /= 0 then
            Out_Ch.Send(Num);
         end if;
      end loop;
   end Filter;

   Main_Channel : aliased Channel;
   Prime : Integer;
begin
   -- Initial generator
   declare
      G : Generate;
   begin
      G.Start(Main_Channel'Access);

      for I in 1 .. Number_Of_Primes loop
         Main_Channel.Receive(Prime);
         Put_Line("Prime: " & Integer'Image(Prime));

         -- Setup new filter for each new prime
         declare
            New_Channel : aliased Channel;
            F : Filter;
         begin
            F.Start(Main_Channel'Access, New_Channel'Access, Prime);
            Main_Channel := New_Channel;
         end;
      end loop;
   end;
end Main;
