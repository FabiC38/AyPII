program Precipitaciones;
const
    MES=12;
    ANIOI=2000;
    ANIOF=2020;
type
    matrizP=array[1..MES,ANIOI..ANIOF] of integer;
procedure cargarMatriz(var m:matrizP);
var 
    i,j:integer;
    anioAct,mesAct,valAct:integer;
begin
    for i:=1 to MES do 
        for j:=ANIOI to ANIOF do 
            m[i,j]:=0;
    writeln('Ingresar anio');
    readln(anioAct);
    while ((anioAct>=2000)and(anioAct<=2020))do 
    begin
        writeln('Ingresar mes');
        readln(mesAct);
        writeln('Ingresar valor');
        readln(valAct);
        m[mesAct,anioAct]:=valAct;
        writeln('Ingresar anio');
        readln(anioAct);

    end;
end;
procedure imprimirMatriz(m:matrizP);
var 
    i,j:integer;
begin
    for j:=ANIOI to ANIOF do 
    begin
        for i:=1 to MES do 
        begin
            writeln('ANIO: ',j,' / MES: ',i);
            writeln(m[i,j]);
        end;
    end;
end;
function sumatoria(m:matrizP;anioIni,anioFin,mesIni,mesFin:integer):integer;
var 
    i,j,sum:integer;
begin
    sum:=0;
    for i:=mesIni to mesFin do 
        for j:=anioIni to anioFin do 
            sum:=sum+m[i,j];
    sumatoria:=sum;
end;
procedure acumuladoMes(m:matrizP);
var 
    i,j,acu:integer;
begin
    for i:=1 to MES do 
    begin
        acu:=0;
        for j:=ANIOI to ANIOF do 
        begin
            acu:=acu+m[i,j];
        end;
        writeln('MES ',i,' ACUMULO UN TOTAL DE ',acu);
    end;
end;
procedure acumuladoAnio(m:matrizP);
var 
    i,j,acu:integer;
begin
    for j:=ANIOI to ANIOF do 
    begin
        acu:=0;
        for i:=1 to MES do 
        begin
            acu:=acu+m[i,j];
        end;
        writeln('ANIO ',j,' ACUMULO UN TOTAL DE ',acu);
    end;
end;
var 
    m:matrizP;
    anioIni,anioFin,mesIni,mesFin:integer;
begin
    cargarMatriz(m);
    imprimirMatriz(m);
    writeln('INGRESAR ANIO DE INICIO');
    readln(anioIni);
    writeln('INGRESAR ANIO DE FIN');
    readln(anioFin);
    writeln('INGRESAR MES DE INICIO');
    readln(mesIni);
    writeln('INGRESAR MES DE FIN');
    readln(mesFin);
    writeln('LA SUMATORIA ENTRE LOS AÑOS Y MESES ES ',sumatoria(m,anioIni,anioFin,mesIni,mesFin));
    acumuladoMes(m);
    acumuladoAnio(m);
end.