program ejercicioDos;
uses
    GenericLinkedList;
const
    CANT = 5;
type
    paquete = record
        codigo : integer;
        lugar : integer;
        domicilio : string;
        peso : integer;
    end;
    listaPaquetes = specialize LinkedList<paquete>;
    vCentros = array [1..CANT] of listaPaquetes;
    dupla = record
        peso : integer;
        cant : integer;
    end;
    matrizDuplas = array [1..20, 1..2] of integer;
    listaDuplas = specialize LinkedList<dupla>;

{ -------------- IGUAL AL EJERCICIO DOS DE LA CLASE 3 -------------------

Un módulo llamado LeerPaquete() que lea los datos de paquetes aleatoriamente 
(de manera similar a como se generaban los inmuebles) y los almacene ordenados 
por peso y agrupados por código de lugar, en una estructura de datos adecuada. La 
lectura finaliza cuando se lee el código de paquete -1.}
procedure leerPaquete(var cen : vCentros);
var
    vDomicilios : array [1..4] of string = ('7 y 48', '50 y 120', '113 y 64', '5 y 61');
    paq : paquete;
begin
    paq.codigo := random(2000)-1;
    while (paq.codigo <> -1) do begin
        paq.codigo := random (2000)-1;
        paq.lugar := random(CANT)+1;
        paq.domicilio := vDomicilios[random(4)+1];
        paq.peso := (random(20)+1);
        cen[paq.lugar].reset();
        while ((not cen[paq.lugar].eol()) AND (cen[paq.lugar].current().peso <= paq.peso)) do
            cen[paq.lugar].next();
        cen[paq.lugar].insertCurrent(paq);
        paq.codigo := random (2000)-1;
    end;
end;

procedure iniciarVector(var v : vCentros);
var
    i : integer;
begin
    for i:=1 to CANT do
        v[i] := listaPaquetes.create();
    leerPaquete(v);
end;

procedure buscarMinimo(var min : paquete; v : vCentros);
var
    i : integer;
    posMin : integer;
begin
    min.peso := 32767;
    posMin := -1;
    for i:=1 to CANT do begin
        if (not v[i].eol()) then begin
            if (v[i].current().peso <= min.peso) then begin
                min := v[i].current();
                posMin := i;
            end;
        end;
    end;
    if (posMin <> -1) then
        v[posMin].next();
end;

{Un módulo que reciba la estructura generada en el punto a y retorne una estructura 
de datos donde se almacenen las duplas (peso, cantidad) de ese peso, ordenadas 
por peso.

----------- ACLARACIÓN ---------------
Está hecho tanto como matriz, como en forma de lista, ante la ambiguedad de ambas posibilidades}
procedure mergeDuplas(v : vCentros; var m : matrizDuplas; var l : listaDuplas);
var
    min : paquete;
    i : integer;
    paqAcc : dupla;
begin   
    l := listaDuplas.create();
    for i:=1 to CANT do
        v[i].reset();
    buscarMinimo(min, v);
    while (min.peso <> 32767) do begin
        paqAcc.peso := min.peso;
        paqAcc.cant := 0;
        while (min.peso = paqAcc.peso) do begin
            paqAcc.cant := paqAcc.cant + 1;
            buscarMinimo(min, v);
        end;
        m[(paqAcc.peso),1] := (paqAcc.peso)*500;
        m[(paqAcc.peso),2] := paqAcc.cant; 
        l.add(paqAcc);
    end;
end;

procedure printMatriz(m : matrizDuplas);
var
	fil : integer;
begin
	for fil:=1 to 20 do begin
		writeln(m[fil,1],'g : ',m[fil,2]);
	end;
end;

procedure printLista(l : listaDuplas);
begin
    l.reset();
    while (not l.eol()) do begin
        writeln((l.current().peso)*500,'g : ',l.current().cant);
        l.next();
    end;
end;

var
    centros : vCentros;
    matriz : matrizDuplas;
    lista : listaDuplas;
begin
    iniciarVector(centros);
    mergeDuplas(centros, matriz, lista);
    printMatriz(matriz);
    printLista(lista);
end.

