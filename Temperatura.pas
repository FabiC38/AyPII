program Temperatura;
const 
    MES=12;
    ANIOI=2000;
    ANIOF=2020;
type 
    matriz=array[1..MES,ANIOI..ANIOF] of real;
procedure cargarRandom(var m:matriz);
var 
    i,j:integer;
begin
    randomize;
    for i:=1 to MES do 
        for j:=ANIOI to ANIOF do
            m[i,j]:=(random*56)-15;
end;
procedure imprimirMatriz(m:matriz);
var 
    i,j:integer;
begin
    for j:=ANIOI to ANIOF do
    begin
        writeln('ANIO ',j);
        for i:=1 to MES do
        begin
            writeln(m[i,j]:0:2);
        end;
        writeln;
    end;

end;
procedure imprimirMatriz2(m:matriz);
var 
    i,j:integer;
begin
    for i:=1 to MES do
    begin
        writeln('MES ',i);
        for j:=ANIOI to ANIOF do
        begin
            writeln(m[i,j]:0:2);
        end;
        writeln;
    end;

end;
procedure PromedioAnual(m:matriz);
var 
    i,j:integer;
    suma:real;
begin
    for j:=ANIOI to ANIOF do 
    begin
        suma:=0;
        for i:=1 to MES do 
        begin
            suma:=suma+m[i,j];
        end;
        writeln('EL PROMEDIO DEL ANIO ',j,' ES: ',(suma/MES):0:2);
    end;
end;
procedure temperaturaMax(m:matriz);
var
    i,j,mesMax:integer;
    max:real;
begin
    for i:=1 to MES do 
    begin
        max:=0;
        mesMax:=0;
        for j:=ANIOI to ANIOF do
        begin
            if(m[i,j]>max)then 
            begin
                max:=m[i,j];
                mesMax:=j;
            end;
            
        end;
        writeln('La temperatura maxima de todo',i,' fue de' ,max:0:2,' en el mes ',mesMax);
    end;
end;
procedure temperaturaMasBaja(m:matriz;var anioMin, mesMin:integer);
var 
    i,j:integer;
    min:real;
begin
    min:=9999;
    for i:=1 to MES do 
    begin
        for j:=ANIOI to ANIOF do 
        begin
            if(m[i,j]<min)then 
            begin
                min:=m[i,j];
                anioMin:=j;
                mesMin:=i;
            end;
        end;
    end;
end;
var 
    m:matriz;
    anioMin,mesMin:integer;
begin
    anioMin:=-1;
    mesMin:=-1;
    cargarRandom(m);
    imprimirMatriz(m);
    imprimirMatriz2(m);
    PromedioAnual(m);
    temperaturaMax(m);
    temperaturaMasBaja(m,anioMin,mesMin);
    writeln('Se registro la temperatura mas baja en el anio ',anioMin,' y el mes ',mesMin);
end.