program Terrenos;
uses sysutils, GenericLinkedList;

const
    CANTIDAD_ESTILOS = 4;   // A, B, C, D
    CANTIDAD_RANGOS = 3;    // 1-1000, 1001-5000, 5001+
    MAX_HABITACIONES = 20;  // máximo razonable de habitaciones

type
    Terreno = record
        propietario: string;
        valor_fiscal: real;
        superficie: real;
        estilo: integer;        // A, B, C o D
        habitaciones: integer;
    end;

    ListaTerrenos = specialize LinkedList<Terreno>;

    // Punto 1 - vector de listas agrupado por estilo
    VectorEstilos = array[1..CANTIDAD_ESTILOS] of ListaTerrenos;

    // Punto 3 - matriz habitaciones x rangos fiscales
    Matriz = array[1..MAX_HABITACIONES, 1..CANTIDAD_RANGOS] of integer;

// Usá esta procedure para simular la carga de terrenos
procedure ObtenerTerrenos(var l: ListaTerrenos);
var
    t: Terreno;
    nombres: array[1..5] of string = ('Garcia', 'Lopez', 'Perez', 'Martinez', 'Sanchez');
begin
    l := ListaTerrenos.create();
    t.superficie := random(500) + 1;
    while t.superficie <> 0 do
    begin
        t.propietario := nombres[random(5) + 1];
        t.valor_fiscal := random(8000) + 1;
        t.superficie := random(500);   // puede salir 0 y termina
        t.estilo := random(4) + 1;
        t.habitaciones := random(MAX_HABITACIONES) + 1;
        if t.superficie <> 0 then
            l.add(t);
    end;
end;

// funcion auxiliar para determinar rango del valor fiscal
function valorARango(v: real): integer;
begin
    if v <= 1000 then
        valorARango := 1
    else if v <= 5000 then
        valorARango := 2
    else
        valorARango := 3;
end;

//--------------------------------------------------------
// PUNTO 1
// Recorre la lista y almacena en vector de listas
// agrupado por estilo arquitectonico (A,B,C,D)
// ordenado por valor fiscal dentro de cada estilo
procedure punto1(l: ListaTerrenos; var v: VectorEstilos);
var 
    i:integer;
begin
    for i:=1 to CANTIDAD_ESTILOS do 
        v[i]:=ListaTerrenos.create();
    l.reset();
    while not l.eol() do 
    begin
        v[l.current().estilo].reset();
        while ((not v[l.current().estilo].eol())and(v[l.current().estilo].current().valor_fiscal<=l.current().valor_fiscal))do 
            v[l.current().estilo].next();
        v[l.current().estilo].insertCurrent(l.current());
        l.next();
    end;
end;
procedure imprimirVectorL(v:VectorEstilos);
var 
    i:integer;
begin
    for i:=1 to CANTIDAD_ESTILOS do 
    begin
        writeln('ESTILO ',i);
        v[i].reset();
        while not v[i].eol() do 
        begin
            writeln('Propietario: ',v[i].current().propietario,'| Valor fiscal: ',v[i].current().valor_fiscal:0:2,'| Superficie en metros cuadrado: ',v[i].current().superficie:0:2,'| Estilo: ',v[i].current().estilo,'| Habitaciones: ',v[i].current().habitaciones);
            v[i].next();
        end;
    end;    
end;
//--------------------------------------------------------
// PUNTO 2
// Recursivo: aumenta 15% el valor fiscal de todos los
// terrenos cuyo valor sea menor al recibido por parametro
procedure punto2(var v: VectorEstilos; valorLimite: real; i:integer);
var
    t:Terreno;
begin
    if i<=CANTIDAD_ESTILOS then 
    begin
        v[i].reset();
        while not v[i].eol()do 
        begin
            if v[i].current().valor_fiscal<valorLimite then 
            begin
                t:=v[i].current();
                t.valor_fiscal:=t.valor_fiscal*1.15;
                v[i].setCurrent(t);
            end;
            v[i].next();
        end;
        punto2(v,valorLimite,i+1)
    end;
end;

//--------------------------------------------------------
// PUNTO 3
// Recibe el vector de listas y retorna una matriz
// filas = cantidad de habitaciones
// columnas = rango del valor fiscal (1, 2 o 3)
// cada celda = cantidad de terrenos
procedure punto3(v: VectorEstilos; var m: Matriz);
var 
    fil,col,i,rango:integer;
begin
    for fil:=1 to MAX_HABITACIONES do 
        for col:=1 to CANTIDAD_RANGOS do 
            m[fil,col]:=0;
    for i:=1 to CANTIDAD_ESTILOS do 
    begin
        v[i].reset();
        while not v[i].eol() do 
        begin
            rango:=valorARango(v[i].current().valor_fiscal);
            m[v[i].current().habitaciones,rango]:=m[v[i].current().habitaciones,rango]+1;
            v[i].next();
        end;
    end;
end;
procedure imprimirMatriz(m:matriz);
var 
    fil,col:integer;
begin
    for fil:=1 to MAX_HABITACIONES do
        for col:=1 to CANTIDAD_RANGOS do 
            writeln(m[fil,col]);
        writeln;
end;
//--------------------------------------------------------
// PUNTO 4
// Recibe la matriz e imprime la cantidad de habitaciones
// y rango con mayor contabilidad
procedure punto4(m: Matriz);
var 
    fil,col:integer;
    maxValor:integer;
    maxHab,maxRango:integer;
begin
    maxValor:=-1;
    for fil:=1 to MAX_HABITACIONES do 
    begin
        for col:=1 to CANTIDAD_RANGOS do 
        begin
            if(m[fil,col]>maxValor)then
            begin
                maxValor:=m[fil,col];
                maxHab:=fil;
                maxRango:=col;
            end;

        end;
    end;
    writeln('Con mayor contabilidad es ',maxHab,' del rango ',maxRango);
end;

//--------------------------------------------------------
var
    lista: ListaTerrenos;
    estilos: VectorEstilos;
    m: Matriz;
    i: integer;
    valor:real;
begin
    randomize;

    writeln('Obteniendo terrenos...');
    ObtenerTerrenos(lista);

    writeln('Ejecutando punto 1...');

    punto1(lista, estilos);
    imprimirVectorL(estilos);
    i:=1;
    writeln('Ejecutando punto 2...');
    writeln('Ingresar valor:');
    readln(valor);
    punto2(estilos, valor,i);
    imprimirVectorL(estilos);
    writeln('Ejecutando punto 3...');
    punto3(estilos, m);
    imprimirMatriz(m);

    writeln('Ejecutando punto 4...');
    punto4(m);
end.