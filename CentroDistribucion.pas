program CentroDistribucion;
uses GenericLinkedList;
const 
    CANT=6;
type 
    paquete=record
        codigo:integer;
        lugar:integer;
        domicilio:string;
        peso:integer;
    end;
    listaPaquetes=specialize LinkedList<paquete>;
    vCentros=array[1..6] of listaPaquetes;
procedure iniciarVector(var v:vCentros);
var 
    i:integer;
begin 
    for i:=1 to CANT do 
        v[i]:=listaPaquetes.create();
end;
procedure leerPaquete(var cen : vCentros);
var
    vDomicilios : array [1..4] of string = ('7 y 48', '50 y 120', '113 y 64', '5 y 61');
    paq : paquete;
begin
    paq.codigo := random(2000)-1;
    while (paq.codigo <> -1) do 
    begin
        paq.codigo := random (2000)-1;
        paq.lugar := random(CANT)+1;
        paq.domicilio := vDomicilios[random(4)+1];
        paq.peso := (random(20)+1)*500;
        cen[paq.lugar].reset();
        while ((not cen[paq.lugar].eol()) AND (cen[paq.lugar].current().peso <= paq.peso)) do
            cen[paq.lugar].next();
        cen[paq.lugar].insertCurrent(paq);
        paq.codigo := random (2000)-1;
    end;
end;
procedure buscarMinimo(var min:paquete;v:vCentros);
var 
    i,posMin:integer;
begin
    min.peso:=32767;
    for i:=1 to CANT do 
    begin 
        if(not v[i].eol())then 
            if(v[i].current().peso<=min.peso)then 
            begin
                min:=v[i].current();
                posMin:=i;
            end;
    end;
    if(min.peso<>32767)then 
        v[posMin].next();
end;
procedure ordenarCentros(var l:listaPaquetes;v:vCentros);
var 
    i:integer;
    min:paquete;
begin 
    l:=listaPaquetes.create();
    for i:=1 to CANT do 
    begin 
        v[i].reset();
    end;
    buscarMinimo(min,v);
    while(min.peso<>32767)do 
    begin 
        l.add(min);
        buscarMinimo(min,v);
    end;
end;
procedure imprimirOrdenado(l:listaPaquetes);
begin 
    l.reset();
    while not l.eol()do 
    begin 
        writeln(l.current().peso);
        l.next();
    end;
end;
var 
    ord:listaPaquetes;
    v:vCentros;
begin 
    iniciarVector(v);
    leerPaquete(v);
    ordenarCentros(ord,v);
    imprimirOrdenado(ord);
end.