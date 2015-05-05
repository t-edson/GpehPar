unit GPEH_Eri;
{Unidad para el manejo de archivos binarios de GPEH Ericsson}
{$mode objfpc}{$H+}
interface
uses Classes, SysUtils;
var
  posArc: integer;    //puntero global a la posición actual
  MaxBytes: integer;  //cantidad de datos leídos

procedure LeeArchivo(archivo0: string);
Function PedazoByte(dato : Byte; bitINI, bitFIN : Byte) : Byte;
function LeeByte: byte;
function LeeWord: word;
function LeeByte3: longint;
procedure InicLecturaBit;  //Prepara la lectura por bits
Function LeenBits(n: Integer): LongInt;
function LeeCadena(n: integer): string;
function LeeScannerID: string;
function LeeFechaHoraEve: string;
function LeeFechaHoraFot: string;

implementation
var bolsa: array of byte;  //bolsa para leer archivo
    posBit: byte;  //posición de bit (de 1 a 8)

procedure LeeArchivo(archivo0: string);
//Lee todos los datos del archivo y los almacena en la matriz bolsa[].
var Leidos: Word = 0;   //bytes leidos
    ar: file;   //archivo sin tipo
    ibol: PByte;
begin
   AssignFile(ar,archivo0);
   reset(ar,1);  //los bloques son de un byte
   MaxBytes := FileSize(ar);
   SetLength(bolsa, MaxBytes); //Hace espacio
   ibol := @bolsa[0];
   repeat
     BlockRead(ar, ibol^,MaxBytes,Leidos);  //Lectura masiva
     inc(ibol,Leidos);
   until (Leidos = 0);
   CloseFile(ar);
   posArc := 0;  //deja apuntando al primer elemento
end;

function LeeByte: byte;
begin
  if posArc> MaxBytes then exit(0);
  Result:=bolsa[posArc];
  Inc(posArc);
end;
function LeeWord: word;
begin
  if posArc > MaxBytes-1 then exit(0);
  Result:=bolsa[posArc]* 256 + bolsa[posArc+1];
  Inc(posArc,2);
end;
function LeeByte3: longint;
begin
  if posArc > MaxBytes-2 then exit(0);
  Result:=bolsa[posArc]* 65536  + bolsa[posArc+1]* 256 + bolsa[posArc+2];
  Inc(posArc,3);
end;

Function PedazoByte(dato : Byte; bitINI, bitFIN : Byte) : byte;
//Devuelve un intervalo de bits de un dato de tipo byte. El valor devuelto lo manda en decimal
//El orden de los bits se especifican de 1 a 8.
begin
   Result := 0;     //valor por defecto
   //validacióMaxBytes
   if (bitINI < 1) or (bitINI > 8) then exit;
   if (bitFIN < 1) or (bitFIN > 8) then exit;
   //limpìa bits de mayor peso
   dato := dato << (bitINI-1);
   dato := dato >> (bitINI-1);
   //desplaza bits restantes
   Result := dato >> (8-bitFIN);
End;
Function PedazoWord(dato : Word; bitINI, bitFIN : Byte) : Word;
//Devuelve un intervalo de bits de un dato de tipo Word. El valor devuelto lo manda en decimal
//El orden de los bits se especifican de 1 a 8.
begin
   Result := 0;     //valor por defecto
   //validacióMaxBytes
   if (bitINI < 1) or (bitINI > 16) then exit;
   if (bitFIN < 1) or (bitFIN > 16) then exit;
   //limpìa bits de mayor peso
   dato := dato << (bitINI-1);
   dato := dato >> (bitINI-1);
   //desplaza bits restantes
   Result := dato >> (16-bitFIN);
End;

procedure InicLecturaBit;  //Prepara la lectura por bits
begin
  posBit:=1;
end;
Function LeenBits(n: Integer): LongInt;
//Lee un número determinado de bits. Actualiza 'posBit'
var p1,p2,p3: Byte;  //variables auxiliares
    tmp, tmp2: longint;
begin
  if n <= 0 Then exit(-1);
  if posBit+n <= 9 then begin
     //se puede leer en el mismo byte
     p1 := bolsa[posArc];
     Result := PedazoByte(p1, posBit, posBit+n-1);
     posBit := posBit+n;
     if posBit = 9 then begin  //pasa al siguiente byte
        Inc(posArc);
        posBit := 1;
     end;
  end else if posBit+n <= 17 then begin
     //se puede leer en dos bytes
     p1 := bolsa[posArc ];
     inc(posArc);
//write(posArc,')');
     p2 := bolsa[posArc];
     Result := PedazoWord((p1<<8)+p2, posBit, posBit+n-1);
     posBit := posBit + n - 8;
     if posBit = 9 then begin  //pasa al siguiente byte
        Inc(posArc);
        posBit := 1;
     end;
  end else if posBit+n <= 25 then begin
     //se puede leer en 3 bytes bytes !!!!!!!!POR VALIDARRRRRRRR
     p1 := bolsa[posArc];
     inc(posArc);
//write(posArc,')');
     p2 := bolsa[posArc];
     inc(posArc);
//write(posArc,')');
     p3 := bolsa[posArc];
     tmp := PedazoByte(p1, posBit, 8);
     posBit:= posBit+n -8;
     tmp2 := PedazoWord((p2<<8)+p3, 1, posBit-1);
     Result := (tmp << (posBit) ) + tmp2;
     posBit := posBit - 8;
     if posBit = 9 then begin  //pasa al siguiente byte
        Inc(posArc);
        posBit := 1;
     end;
  end else begin
     //no se espera llegar hasta aquí
     exit(-1);
  end;
End;
function LeeCadena(n: integer): string;
//Lee una cadena de un tamaño determinado
var i:integer;
    c: char;
begin
  Result := '';
  for i:=1 to n do begin
    c := Chr(LeeByte);
    Result += c; // Chr(LeeByte);
  end;
//  Result:=StringReplace(Result,#0,' ',[rfReplaceAll]);
  Result:=StringReplace(Result,#0,#13#10,[rfReplaceAll]);
end;
function LeeScannerID: string;
//Lee el campo ScannerID como texto. Se separa para poder darle formato si es necesario
begin
  Result := IntToStr(LeeByte3);
end;
function LeeFechaHoraEve: string;
//Lee fecha-hora en el formato de los registros de tipo EVENTO
var hh, nn, ss, dd : byte;
begin
  hh := LeeNBits(5);
  nn := LeeNBits(6);
  ss := LeeNBits(6);
  dd := LeeNBits(11);
  Result := Format('%2d:%.2d:%.2d',[hh,nn,ss]);
end;
function LeeFechaHoraFot: string;
//Lee fecha-hora en el formato de los registros de tipo FOOTER
var yy: word;
    mm, dd: byte;
    hh, nn, ss: byte;
begin
  yy := LeeWord;
  mm := LeeByte;
  dd := LeeByte;
  hh := LeeByte;
  nn := LeeByte;
  ss := LeeByte;
  Result := Format('%4d/%.2d/%.2d',[yy,mm,dd]) + ' ' + Format('%2d:%.2d:%.2d',[hh,nn,ss]);
end;


initialization
  //inicia variables
  posArc := 0;
  MaxBytes := 0;
  InicLecturaBit;  //Prepara la lectura por bits
end.

