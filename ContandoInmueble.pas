program ContandoInmueble;
uses GenericLinkedList;
const 
    HAB=4;
    BAN=3;
type 
    inmueble=record
        tipo:string;
        cantHab:integer;
        cantBanos:integer;
    end;
    matriz=array[0..HAB,1..BAN] of integer;
    listaInmuebles=specialize LinkedList<inmueble>;
procedure leerInmueble(var i:inmueble);
begin
    writeln('INGRESAR CANTIDAD DE BANOS');
    readln(i.cantBanos);
    while(i.cantBanos<>0)do 
    begin
        writeln('INGRESAR TIPO');
        readln(i.tipo);
        writeln('INGRESAR CANTIDAD DE HAB');
        readln(i.cantHab);
        writeln('INGRESAR CANTIDAD DE BANOS');
        readln(i.cantBanos);
    end;

end;
procedure inicializar(var m:matriz);
var
    fil,col:integer;
begin
    for fil:=0 to HAB do 
        for col:=1 to BAN do 
            m[fil,col]:=0;
end;
procedure cargarInmueble(var l:listaInmuebles);
var 
    i:inmueble;
begin
    l:=listaInmuebles.create();
    leerInmueble(i);
    while(i.cantBanos<>0)do 
    begin 
        l.add(i);
        leerInmueble(i);
    end;
end;
procedure contarInmuebles(var m:matriz;l:listaInmuebles);
begin 
    l.reset();
    while not l.eol() do 
    begin 
        m[l.current().cantHab,l.current().cantBanos]:= m[l.current().cantHab,l.current().cantBanos]+1;
        l.next();
    end;
end;
procedure imprimirContabilidad(m:matriz);
var 
    fil,col:integer;
begin
    for fil:=0 to HAB do 
        for col:=1 to BAN do 
            writeln('CONTABILIDAD: ',m[fil,col]);
end;
var 
    m:matriz;
    l:listaInmuebles;
begin
    inicializar(m);
    cargarInmueble(l);
    contarInmuebles(m,l);
    imprimirContabilidad(m);
end.