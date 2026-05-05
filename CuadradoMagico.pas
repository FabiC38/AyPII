program CuadradoMagico;
const 
    N=4;
type 
    mCuadrado=array[1..N,1..N] of integer;
//Implemente un módulo que devuelva la suma de todos los valores de
//una fila F. F es pasado por parámetro
function sumarFilas(m:mCuadrado; F:integer):integer;
var 
    col,sum:integer;
begin
    sum:=0;
    for col:=1 to N do 
        sum:=sum+m[F,col];
    sumarFilas:=sum;
end;
//Implemente un módulo que devuelva la suma de todos los valores de
//una columna C. C es pasado por parámetro
function sumarColumnas(m:mCuadrado; C:integer):integer;
var 
    fil,sum:integer;
begin
    sum:=0;
    for fil:=1 to N do 
        sum:=sum+m[fil,C];
    sumarColumnas:=sum;
end;
//Implemente un módulo que devuelva la suma de todos los valores de
//la diagonal principal.
function sumarDiagonalP(m:mCuadrado):integer;
var 
    i,sum:integer;
begin
    sum:=0;
    for i:=1 to N do 
        sum:=sum+m[i,i];
    sumarDiagonalP:=sum;
end;
//Implemente un módulo que devuelva la suma de todos los valores de
//la diagonal secundaria.
function sumarDiagonalS(m:mCuadrado):integer;
var 
    i,sum:integer;
begin
    sum:=0;
    for i:=N to 1 do 
        sum:=sum+m[i,N-i+1];
    sumarDiagonalS:=sum;
end;
//Implemente un módulo que, dada una matriz cuadrada, determine si la
//misma es un cuadrado mágico. Use los módulos ya implementados.
function esCuadrado(m:mCuadrado):integer;
var
    i,diagonal:integer;
    isM:boolean;
begin
    diagonal:=sumarDiagonalP(m);
    isM:=true;
    for i:=1 to N do
    begin
        if((diagonal<>sumarFilas(m))or(diagonal<>sumarColumnas(m)))then 
            isM:=false;
    end;
    esCuadrado:=isM
end;
var 
    m:mCuadrado;
    fil,col:integer;
begin
    writeln('INGRESAR LOS VALORES A LA MATRIZ');
    for fil:=1 to N do 
    begin
        for col:=1 to N do
        begin
            writeln('INGRESAR VALOR PARA ',fil,'x',col)
            readln(m[fil,col]);
        end;

    end;
    writeln('MATRIZ INGRESADA')
    for fil:=1 to N do 
    begin
        for col:=1 to N do
        begin
            writeln(m[fil,col]:4);
        end;
        writeln;
    end;
    writeln('RESULTADOS');
    writeln(sumarFilas(m));
    writeln(sumarColumnas(m));
    writeln(sumarDiagonalP(m));
    writeln(sumarDiagonalS(m));
    if(esCuadrado(m))then
        writeln('Es un cuadrado magico')
    else 
        writeln('No es un cuadrado magico');
end.