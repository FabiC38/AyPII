program ReagruparInmueble;
uses GenericLinkedList;
const 
    HAB=4;
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
    vectorInmuebles=array[0..HAB] of listaInmuebles;
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
    fil,col:integer;
    i:inmueble;
begin 
    for fil:=1 to MESES do 
    begin 
        for col:=AINI to AFIN do 
        begin
            cargarInmueble(i);
            m[fil,col]:=i;
        end;
    end;
end;
procedure inicializarListas(var v:vectorInmuebles);
var 
    i:integer;
begin 
    for i:=0 to 4 do 
        v[i]:=listaInmuebles.create();
end;
procedure ReagruparInmueble(m:matrizInmuebles;var v:vectorInmuebles);
var 
    fil,col:integer;
begin
    inicializarListas(v);
    for fil:=1 to MESES do 
        for col:=AINI to AFIN do 
            v[m[fil,col].cantHab].add(m[fil,col]);
end;
procedure imprimirInmuebles(v:vectorInmuebles);
var 
    i:integer;
    inmu:inmueble;
begin 
    for i:=0 to HAB do 
    begin 
        v[i].reset();
        while not v[i].eol()do 
        begin 
            inmu:=v[i].current();
            writeln('Tipo Inmueble: ' , inmu.tipo);
	        writeln('Cantidad de Habitaciones: ' , inmu.cantHab);
	        writeln('Cantidad de BaÃ±os: ' , inmu.cantBanos);
	        writeln('Precio: ' , inmu.precio:10:2);  
	        writeln('Localidad: ' , inmu.localidad);
	        writeln();
            v[i].next();
        end;
    end;
end;
var 
    m:matrizInmuebles;
    v:vectorInmuebles;
begin 
    generarInmuebles(m);
    ReagruparInmueble(m,v);
    imprimirInmuebles(v);
end.