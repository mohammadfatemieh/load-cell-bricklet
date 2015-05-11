program ExampleThreshold;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletLoadCell;

type
  TExample = class
  private
    ipcon: TIPConnection;
    lc: TBrickletLoadCell;
  public
    procedure ReachedCB(sender: TBrickletLoadCell; const weight: LongInt);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'XYZ'; { Change to your UID }

var
  e: TExample;

{ Callback for weight greater than 200 g }
procedure TExample.ReachedCB(sender: TBrickletLoadCell; const weight: LongInt);
begin
  WriteLn(Format('Weight %f kg.', [weight/1000.0]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  lc := TBrickletLoadCell.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Get threshold callbacks with a debounce time of 10 seconds (10000ms) }
  lc.SetDebouncePeriod(10000);

  { Register threshold reached callback to procedure ReachedCB }
  lc.OnWeightReached := {$ifdef FPC}@{$endif}ReachedCB;

  { Configure threshold for "greater than 200 g" }
  lc.SetWeightCallbackThreshold('>', 200, 0);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
