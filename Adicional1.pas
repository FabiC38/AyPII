program Adicional1;
uses sysutils, GenericABB, GenericLinkedList;

const
	CANTIDAD_VENDEDORAS = 7;
	CANTIDAD_VENTAS = 50;

type 	
	Venta = record
		numero_vendedora: integer;
		numero_venta: integer;
		codigo_producto: integer;
		precio_unitario: real;
		cantidad_unidades_vendidas: integer;
		fecha_de_venta: string;
	end;
	ListaVentas = specialize LinkedList<Venta>;
	matrizVenta=array[1..CANTIDAD_VENDEDORAS,1..CANTIDAD_VENTAS] of Venta;
	CantVenta=record
		fecha:string;
		cantidad:integer;
	end;
	ABBCantVenta=specialize ABB<CantVenta>;
	Resumen=record 
		codigo:integer;
		totalVendidos:integer;
		montoTotal:real;
	end;
	listaResumen=specialize LinkedList<Resumen>;
	vecPosiciones=array[1..CANTIDAD_VENDEDORAS] of integer;


// Use esta función para obtener la lista de ventas
procedure ObtenerVentas(var lista: ListaVentas);
var i, nValores: integer;
    fecha: TDateTime;
	ven: Venta;
	cVentas: array [1..CANTIDAD_VENDEDORAS] of integer;
	fechas: array [1..CANTIDAD_VENDEDORAS] of TDateTime;

begin
lista:= ListaVentas.create();
	
nValores:= CANTIDAD_VENDEDORAS * CANTIDAD_VENTAS;
for i := 1 to CANTIDAD_VENDEDORAS do
	begin
	cVentas[i]:= 0;
	fechas[i]:= Date - random(120) - 60;
	end;

// Generamos N ventas y las almacenamos en la lista
i:= 1;
while i <= nValores do
	begin
	ven.numero_vendedora:= random(CANTIDAD_VENDEDORAS) + 1;
	if cVentas[ven.numero_vendedora] < CANTIDAD_VENTAS then
		begin
		cVentas[ven.numero_vendedora]:= cVentas[ven.numero_vendedora] + 1;
		ven.numero_venta:= cVentas[ven.numero_vendedora];
		ven.codigo_producto:= random(1000) + 200;
		ven.precio_unitario:= random(100) + 10;
		ven.cantidad_unidades_vendidas:= random(15) + 1;
		fecha:= fechas[ven.numero_vendedora];
		fechas[ven.numero_vendedora]:= fechas[ven.numero_vendedora] + random(3) + 1;
		ven.fecha_de_venta:= FormatDateTime('YYYY/MM/DD',fecha);
		
		i:= i + 1;
		lista.add(ven);
		end;
	end;
end;
//--------------------------------------------------------
//Haga un módulo que recorra la lista de ventas que se dispone 
//y arme una matriz con todas las ventas de cada una de las vendedoras. 
//En cada fila se deben almacenar todas las ventas de cada vendedora.
procedure cargarMatriz(var m:matrizVenta; l:ListaVentas);
begin
	l.reset();
	while not l.eol do 
	begin
		m[l.current().numero_vendedora,l.current().numero_venta]:=l.current();
		l.next();
	end;
end;
procedure imprimirMatriz(m:matrizVenta);
var 
	fil,col:integer;
begin
	for fil:=1 to CANTIDAD_VENDEDORAS do
	begin
		for col:=1 to CANTIDAD_VENTAS do 
		begin
			writeln(m[fil,col].codigo_producto);
			writeln(m[fil,col].precio_unitario:0:2);
			writeln(m[fil,col].cantidad_unidades_vendidas);
			writeln(m[fil,col].fecha_de_venta);
		end;
	end;
end;
//Haga un módulo que reciba la matriz y retorne un árbol de cantidades de ventas ordenada por fecha de venta. 
//Para cada fecha solo se desea almacenar la cantidad de ventas.
procedure agregarVenta(a:ABBCantVenta;v:Venta);
var 
	cantAct:CantVenta;
begin
	if a.isEmpty()then 
	begin
		cantAct.fecha:=v.fecha_de_venta;
		cantAct.cantidad:=v.cantidad_unidades_vendidas;
		a.insertCurrent(cantAct);	
	end
	else
	if a.current().fecha=v.fecha_de_venta then
	begin
		cantAct.fecha:=v.fecha_de_venta;
		cantAct.cantidad:=cantAct.cantidad+v.cantidad_unidades_vendidas;
		a.setCurrent(cantAct);
	end 
	else if v.fecha_de_venta<a.current().fecha then 
		agregarVenta(a.getLeftChild(),v)
	else 
		agregarVenta(a.getRightChild(),v);
end;
procedure cargarArbol(a:ABBCantVenta;m:matrizVenta);
var 
	fil,col:integer;
begin
	for fil:=1 to CANTIDAD_VENDEDORAS do 
		for col:=1 to CANTIDAD_VENTAS do 
			agregarVenta(a,m[fil,col]);
end;
//Haga un módulo que reciba la matriz y la retorne ordenada. 
//Para cada vendedora ordene todas sus ventas por código de producto.
procedure ordenarMatriz(m:matrizVenta);
var 
	fil,col,i,p:integer;
	elemento:Venta;
begin
	for fil:=1 to CANTIDAD_VENDEDORAS do
	begin
		for col:=1 to CANTIDAD_VENTAS-1 do 
		begin
			p:=col;
			for i:=col+1 to CANTIDAD_VENTAS do 
			begin
				if(m[fil,i].codigo_producto<m[fil,p].codigo_producto)then 
					p:=i;
				elemento:=m[fil,p];
				m[fil,p]:=m[fil,col];
				m[fil,col]:=elemento;
			end;
		end;
	end;
end;

//Haga un módulo que reciba las ventas ordenadas 
//y genere un resumen por cada producto distinto vendido. 
//Por cada producto se desea saber: cantidad total de unidades vendidas y monto total acumulado.
procedure buscarCodigo(m:matrizVenta;v:vecPosiciones;var min:integer);
var 
	fil:integer;
begin
	min:=9999;
	for fil:=1 to CANTIDAD_VENDEDORAS do 
	begin
		if(v[fil]<=CANTIDAD_VENTAS)then 
		begin
			if(m[fil,v[fil]].codigo_producto<=min)then 
			begin
				min:=m[fil,v[fil]].codigo_producto;
			end;
		end;
	end;
end;
procedure acumularVentas(m:matrizVenta;var l:listaResumen);
var 
	actual:Resumen;
	fil,codMin:integer;
	v:vecPosiciones;
begin
	l:=listaResumen.create();
	for fil:=1 to CANTIDAD_VENDEDORAS do 
		v[fil]:=1;
	buscarCodigo(m,v,codMin);
	while(codMin<>9999)do 
	begin
		actual.codigo:=codMin;
		actual.totalVendidos:=0;
		actual.montoTotal:=0;
		while codMin=actual.codigo do 
		begin
			for fil:=1 to CANTIDAD_VENDEDORAS do 
			begin
				if((v[fil]<=CANTIDAD_VENTAS)and(m[fil,v[fil]].codigo_producto=actual.codigo))then 
				begin
					actual.totalVendidos:=actual.totalVendidos+m[fil,v[fil]].cantidad_unidades_vendidas;
					actual.montoTotal:=actual.montoTotal+(m[fil,v[fil]].precio_unitario*m[fil,v[fil]].cantidad_unidades_vendidas);
					v[fil]:=v[fil]+1;
				end;
			end;
			buscarCodigo(m,v,codMin);
		end;
		l.add(actual);
	end;
end;
procedure mostrarMatriz(m:matrizVenta);
var 
	fil,col:integer;
begin
	write('MATRIZ ORDENADA');
	for fil:=1 to CANTIDAD_VENDEDORAS do
	begin
		writeln('Vendedora ',fil);
		for col:=1 to CANTIDAD_VENTAS do 
		begin
			writeln(m[fil,col].codigo_producto);
		end;
	end;
end;
procedure mostrarResumen(l:listaResumen);
var 
	act:Resumen;
begin
	writeln('RESUMEN POR PRODUCTO');
	l.reset();
	while not l.eol() do 
	begin
		act:=l.current();
		writeln('Producto ',act.codigo,', total vendido: ',act.totalVendidos,', con un monto total de $',act.montoTotal:0:2);
		l.next();
	end;
end;
//Haga un módulo recursivo que reciba los resúmenes de ventas 
//y devuelva el producto con mayor monto acumulado.
procedure buscarMayor(l:listaResumen;var max:Resumen);
begin
	if not l.eol() then 
	begin
		if(l.current().montoTotal>max.montoTotal)then 
			max:=l.current();
		l.next();
		buscarMayor(l,max);
	end;
end;
//Haga un módulo que reciba el árbol 
//y devuelva la fecha con mayor cantidad de ventas 
//(suponga que solo hay una fecha que cumple esa condición).
procedure buscarMayorFecha(a:ABBCantVenta;var max:integer;var fec:string);
begin
	if not a.isEmpty() then 
	begin
		buscarMayorFecha(a.getLeftChild(),max,fec);
		if(a.current().cantidad>max)then 
		begin
			max:=a.current().cantidad;
			fec:=a.current().fecha;
		end;
		buscarMayorFecha(a.getRightChild(),max,fec);
	end;
end;
//Haga un módulo que reciba el árbol 
//y devuelva la fecha en que comenzaron las ventas.
function inicioActividad(a:ABBCantVenta):string;
begin
	if a.hasLeftChild()then 
		inicioActividad:=inicioActividad(a.getLeftChild())
	else 
		inicioActividad:=a.current().fecha;
end;
var 
	l: ListaVentas;
	m:matrizVenta;
	a:ABBCantVenta;
	lr:listaResumen;
	productoMaximo:Resumen;
	cantMax:integer;
	fechaMax:string;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerVentas(l);
	cargarMatriz(m,l);
	imprimirMatriz(m);
	a:=ABBCantVenta.create();
	cargarArbol(a,m);
	ordenarMatriz(m);
	writeln('MATRIZ ORDENADA');
	mostrarMatriz(m);
	acumularVentas(m,lr);
	mostrarResumen(lr);
	lr.reset();
	productoMaximo:=lr.current();
	buscarMayor(lr,productoMaximo);
	writeln('PRODUCTO MAYOR MONTO: ',productoMaximo.codigo,' CON $',productoMaximo.montoTotal:0:2);
	cantMax:=0;
	fechaMax:='';
	buscarMayorFecha(a,cantMax,fechaMax);
	writeln('FECHA CON MAYOR CANTIDAD: ',fechaMax);
	writeln('FECHA DE INICIO DE ACTIVIDADES: ',inicioActividad(a));


end.
