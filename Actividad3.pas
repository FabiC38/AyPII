program Actividad3;
uses GenericLinkedList;
const
    CANT=4;
type 
    venta=record
        fecha:string;
        producto:integer;
        sucursal:integer;
        cantidad:integer;
    end;
    listaVentas=specialize LinkedList<venta>;
    vSucursales=array[1..CANT] of listaVentas;
    vectaAct=record 
        producto:integer;
        cantidad:integer;
    end;
    listaAct=specialize LinkedList<ventaAct>;
procedure leerLibros(var v:vSucursales);
var 
    i:integer;
    lib:venta;
begin 
    for i:=1 to CANT do 
        v[i]:=listaVentas.create();
    writeln('Ingresar el codigo de sucursal:');
    readln(lib.sucursal);
    while(lib.sucursal<>0)do
    begin 
        writeln('Ingresar la fecha de la venta');
        readln(lib.fecha);
        writeln('Ingresa el codigo del producto vendido');
        readln(lib.producto);
        writeln('Ingresar la cantidad vendida');
        readln(lib.cantidad);
        v[lib.sucursal].reset();
        while (not v[lib.sucursal].eol()and(v[lib.sucursal].current().producto<=lib.producto))do 
            v[lib.sucursal].next();
        v[lib.sucursal].add(lib);
        writeln('Ingresar el codigo de sucursal:');
        readln(lib.sucursal);
    end;
end;
procedure buscarMinimo(v:vSucursales;var min:venta);
var 
    i,posMin:integer;
begin 
    min.producto:=-1;
    posMin:=-1;
    for i:=1 to CANT do 
    begin 
        if(not v[i].eol())then 
        begin 
            if(v[i].current().producto<=min.producto)then 
            begin 
                min:=v[i].current();
                posMin:=i;
            end;
        end;
    end;
    if(posMin<>-1)then 
        v[posMin].next();
end;
procedure mergeAcc(var l:listaAct;v:vSucursales);
var 
    i:integer;
    act:vectaAct;
    min:venta;
begin
    l:=listaAct.create();
    for i:=1 to CANT do 
        v[i].reset();
    buscarMinimo(v,min);
    while(min.producto<>-1)do 
    begin
        act.producto:=min.producto;
        act.cantidad:=0;
        while(act.procedure=min.producto)do 
        begin 
            act.cantidad:=act.cantidad+min.cantidad;
            buscarMinimo(v,min);
        end;
        l.add(act);
    end;
end;
var 
    v:vSucursales;
    l:listaAct;
begin 
    leerLibros(v);
    mergeAcc(l,v);
end.