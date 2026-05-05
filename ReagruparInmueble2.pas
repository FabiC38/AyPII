program ReagruparInmueble2;
uses GenericLinkedList;
const 
    MESES=12;
    AINI=2010;
    AFIN=2023;
type 
    inmueble = record
        tipo: string;
        cantHab: integer;
        cantBanos:integer;
        precio: real;
        localidad: string;
    end;
    listaInmuebles=specialize LinkedList<inmueble>;
    listaListas=specialize LinkedList<listaInmuebles>;
    matrizInmuebles=array[1..MESES,AINI..AFIN] of inmueble;
procedure cargarInmueble(var inmu1:inmueble);
var 
    vTipos:array[1..4] of string= ('Casa', 'Departamento', 'Duplex', 'Local Comercial');
    vLocal:array[1..10] of string= ('La Plata', 'Berisso', 'Ensenada', 'Quilmes','Avellaneda','Bernal','Berazategui','Azul','Tandil','Dolores');
begin
             
    inmu1.tipo:= vTipos[random(4)+1];
    inmu1.cantHab:=random(5);
    inmu1.cantBanos:=random(3)+1;
    inmu1.precio:=random(50000)/2+10000;
    inmu1.localidad:= vLocal[random(10)+1];
      
end;
procedure generarInmuebles(var m:matrizInmuebles);
var 
    i:inmueble;
    fil,col:integer;
begin 
    for fil:=1 to MESES do 
        for col:=AINI to AFIN do 
        begin
            cargarInmueble(i);
            m[fil,col]:=i;
        end;
end;
procedure agruparInmuebles(var ll : listaListas; m : matrizInmuebles);
var
    fil, col : integer;
    listaNueva : listaInmuebles;
begin
    ll := listaListas.create(); 
    for fil:=1 to MESES do
        for col:=AINI to AFIN do begin
            ll.reset();
            while ((not ll.eol()) AND (m[fil,col].localidad > ll.current().current().localidad)) do
                ll.next();
            if ((ll.eol()) OR (m[fil,col].localidad <> ll.current().current().localidad)) then begin
                listaNueva := listaInmuebles.create();
                ll.insertCurrent(listaNueva);
            end;
            ll.current().add(m[fil,col]);
        end;
end;
procedure imprimirLista(ll:listaListas);
begin 
    ll.reset();
    while not ll.eol() do 
    begin 
        ll.current().reset();
        while not ll.current().eol()do 
        begin 
            writeln('[',ll.current().current().localidad,'] TIPO: ', ll.current().current().tipo);
            writeln('[',ll.current().current().localidad,'] BANIOS: ', ll.current().current().cantBanos);
            writeln('[',ll.current().current().localidad,'] HABIT.: ', ll.current().current().cantHab);
            writeln('[',ll.current().current().localidad,'] PRECIO: $', (ll.current().current().precio):6:2);
            ll.current().next();
        end;
        ll.next();
    end;
end;
var 
    ll:listaListas;
    m:matrizInmuebles;
begin 
    generarInmuebles(m);
    agruparInmuebles(ll,m);
    imprimirLista(ll);
end.