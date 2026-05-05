program Adicional4;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_PATENTES = 20;
	CANTIDAD_MARCAS = 10;

type
	Fecha = record
		dia, mes, anio: integer;
	end;
	Alquiler = record
		codigo_sucursal: integer;
		fecha_alquiler: Fecha;
		patente: string;
		marca: string;
		modelo: integer;
		dias_alquiler: integer;
		precio_por_dia: real;
	end;
	ListaAlquileres = specialize LinkedList<Alquiler>;
	vectorLista=array[1..10] of ListaAlquileres;
	Resumen=record 
		marca:string;
		cantidad:integer;
		total:real;
	end;
	ListaResumen=specialize LinkedList<Resumen>;
	Patente=record
		patente:string;
		lista:ListaAlquileres;
	end;
	ABBPatentes=specialize ABB<Patente>;
// Use esta función para obtener la lista de alquileres
procedure ObtenerAlquileres(var lista: ListaAlquileres);
var i, j, nValores: integer;
	alq: Alquiler;
	patentes: array [1..CANTIDAD_PATENTES] of string = ('A5', 'B8', 'C3', 'D1', 'E7', 'F9', 'G4', 'H6', 'I2', 'J8',
	                                              'K7', 'L2', 'M1', 'N8', 'O5', 'P0', 'Q3', 'R4', 'S1', 'T7');
	marcas_db: array [1..CANTIDAD_MARCAS] of string = ('Fiat', 'Audi', 'Ford', 'Renault', 'Volkswagen',
	                                              'Peugeot', 'Citroen', 'Nissan', 'Chevrolet', 'Toyota');
	modelos: array [1..CANTIDAD_PATENTES] of integer;
	marcas: array [1..CANTIDAD_PATENTES] of string;

begin
lista:= ListaAlquileres.create();

for i:= 1 to CANTIDAD_PATENTES do
	begin
	marcas[i]:= marcas_db[random(CANTIDAD_MARCAS) + 1];
	modelos[i]:= random(4) + 2020;
	end;
	
nValores:= random(1000) + 200;

// Generamos N alquileres y los almacenamos en la lista
for i:= 1 to nValores do
	begin
	alq.codigo_sucursal:= random(10) + 1;
	alq.fecha_alquiler.anio:= random(5) + 2020;
	alq.fecha_alquiler.mes:= random(12) + 1;
	alq.fecha_alquiler.dia:= random(28) + 1;
	j:= random(CANTIDAD_PATENTES) + 1;
	alq.patente:= patentes[j];
	alq.marca:= marcas[j];
	alq.modelo:= modelos[j];;
	alq.dias_alquiler:= random(15) + 4;
	alq.precio_por_dia:= random(15) + 70;
		
	lista.add(alq);
	end;
end;
//--------------------------------------------------------
//Haga un módulo que procese la lista de alquileres que se dispone 
//y que los almacene agrupados por sucursal y ordenados por marca en una estructura de datos adecuada y que la retorne.
procedure cargarVectorL(var v:vectorLista;l:ListaAlquileres);
var 
	i:integer;
begin
	for i:=1 to 10 do 
		v[i]:=ListaAlquileres.create();
	l.reset();
	while not l.eol() do 
	begin
		v[l.current().codigo_sucursal].reset();
		while((not v[l.current().codigo_sucursal].eol)and(v[l.current().codigo_sucursal].current().marca<=l.current().marca))do 
			v[l.current().codigo_sucursal].next();
		v[l.current().codigo_sucursal].insertCurrent(l.current());
		l.next();
	end;
end;
//Haga un módulo que reciba la estructura de datos devuelta por el módulo anterior 
//y retorne un resumen de alquileres para cada marca, registrando cantidad de alquileres y precio total. 
//Ordenada de manera descendente por cantidad de alquileres.
procedure buscarMinimo(var v:vectorLista;var marcaAct:Alquiler);
var 
	i,posMin:integer;
begin
	marcaAct.marca:='ZZZZ';
	for i:=1 to 10 do 
	begin
		if not v[i].eol()then
		begin
			if v[i].current().marca<=marcaAct.marca then 
			begin
				marcaAct.marca:=v[i].current().marca;
				marcaAct.dias_alquiler:=v[i].current().dias_alquiler;
				marcaAct.precio_por_dia:=v[i].current().precio_por_dia;
				posMin:=i;
			end;
		end;
	end;
	if marcaAct.marca<>'ZZZZ'then 
		v[posMin].next();
end;
procedure mergeAcumulador(v:vectorLista;var lr:ListaResumen);
var 
	act:Resumen;
	marcaAct:Alquiler;
	i:integer;
begin
	lr:=ListaResumen.create();
	for i:=1 to 10 do 
		v[i].reset();
	buscarMinimo(v,marcaAct);
	while(marcaAct.marca<>'ZZZZ')do 
	begin
		act.marca:=marcaAct.marca;
		act.cantidad:=0;
		act.total:=0;
		while(marcaAct.marca=act.marca)do 
		begin
			act.cantidad:=act.cantidad+1;
			act.total:=act.total+(marcaAct.dias_alquiler*marcaAct.precio_por_dia);
			buscarMinimo(v,marcaAct);
		end;
		lr.reset();
		while((not lr.eol())and(lr.current().cantidad>=act.cantidad))do 
			lr.next();
		lr.insertCurrent(act);
	end;
end;
//Haga un módulo que reciba la estructura de datos devuelta por el módulo 
//implementado en el punto 2 e imprima la marca con mayor cantidad de 
//alquileres a nivel nacional.
procedure mayorMarca(lr:ListaResumen);
begin
	lr.reset();
	if not lr.eol()then
	begin
		writeln('La marca con mayor cantidad es ',lr.current().marca,'[',lr.current().cantidad,']');
	end;
end;
//Haga un módulo que procese la lista de alquileres que se dispone, 
//almacene en una estructura de datos eficiente para la búsqueda de alquileres por patente y que la retorne. 
//Para cada patente se desea almacenar todos sus alquileres.
procedure agregarPatente(a:ABBPatentes;alq:Alquiler);
var 
	p:Patente;
begin
	if a.isEmpty()then 
	begin
		p.patente:=alq.patente;
		p.lista:=ListaAlquileres.create();
		p.lista.add(alq);
		a.insertCurrent(p)
	end
	else if(a.current().patente=alq.patente)then 
		a.current().lista.add(alq)
	else if(a.current().patente>alq.patente) then 
		agregarPatente(a.getLeftChild(),alq)
	else
		agregarPatente(a.getRightChild(),alq);

end;
procedure crearArbol(a:ABBPatentes;l:ListaAlquileres);
begin
	l.reset();
	while not l.eol() do 
	begin
		agregarPatente(a,l.current());
		l.next();
	end;	
end;
//Haga un módulo que reciba la estructura de datos retornada en el punto 4, 
//una patente y una fecha y devuelva si ese auto se alquiló en la fecha 
//recibida.
function buscarPatente(a:ABBPatentes;patente:string;fec:Fecha):boolean;
var 
	encontrado:boolean;
begin
	if a.isEmpty()then
		buscarPatente:=false
	else
	if(a.current().patente=patente)then 
	begin
		a.current().lista.reset();
		encontrado:=false;
		while((not a.current().lista.eol())and(not encontrado))do
		begin
			if((a.current().lista.current().fecha_alquiler.dia=fec.dia)and(a.current().lista.current().fecha_alquiler.mes=fec.mes)and(a.current().lista.current().fecha_alquiler.anio=fec.anio))then 
				encontrado:=true;
			a.current().lista.next();
		end;
		buscarPatente:=encontrado;
	end
	else if(a.current().patente>patente)then 
		buscarPatente:=buscarPatente(a.getLeftChild(),patente,fec)
	else 
		buscarPatente:=buscarPatente(a.getRightChild(),patente,fec);

end;
//Haga un módulo que reciba la estructura de datos retornada en el punto 4 
//y una fecha y devuelva la cantidad de alquileres que se 
//realizaron en esa fecha.
procedure cantAlquileres(a:ABBPatentes;fec:Fecha;var contar:integer);
begin
	if not a.isEmpty()then 
	begin
		cantAlquileres(a.getLeftChild(),fec,contar);
		a.current().lista.reset();
		while not a.current().lista.eol() do 
		begin
			if((a.current().lista.current().fecha_alquiler.dia=fec.dia)and(a.current().lista.current().fecha_alquiler.mes=fec.mes)and(a.current().lista.current().fecha_alquiler.anio=fec.anio))then 
				contar:=contar+1;
			a.current().lista.next();
		end;
		cantAlquileres(a.getRightChild(),fec,contar);
	end;
end;
var 
	l: ListaAlquileres;
	v:vectorLista;
	lr:ListaResumen;
	a:ABBPatentes;
	patBuscar:string;
	fecBuscar:Fecha;
	contar:integer;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerAlquileres(l);

	l.reset();
	while not l.eol do
	begin
  		if l.current.patente = 'S1' then 
		begin
  			writeln(l.current.codigo_sucursal);
			writeln(l.current.fecha_alquiler.anio);
			writeln(l.current.fecha_alquiler.mes);
			writeln(l.current.fecha_alquiler.dia);
			writeln(l.current.patente);
			writeln(l.current.marca);
			writeln(l.current.modelo);
			writeln(l.current.dias_alquiler);
			writeln(l.current.precio_por_dia);
	
  			writeln('-----------------');
		end;
  		l.next;
	end;
  	cargarVectorL(v,l);
	mergeAcumulador(v,lr);
	mayorMarca(lr);
	a:=ABBPatentes.create();
	writeln('Ingresa una patente para buscar:');
	readln(patBuscar);
	writeln('Ingresa un dia para buscar una fecha:');
	readln(fecBuscar.dia);
	writeln('Ingresa un mes para buscar una fecha:');
	readln(fecBuscar.mes);
	writeln('Ingresa un anio para buscar una fecha:');
	readln(fecBuscar.anio);
	if(buscarPatente(a,patBuscar,fecBuscar))then 
		writeln('La patente ',patBuscar,' existe en la fecha indicada')
	else 
		write('La patente no existe');
	writeln('Ingresa un dia para buscar una fecha:');
	readln(fecBuscar.dia);
	writeln('Ingresa un mes para buscar una fecha:');
	readln(fecBuscar.mes);
	writeln('Ingresa un anio para buscar una fecha:');
	readln(fecBuscar.anio);
	contar:=0;
	cantAlquileres(a,fecBuscar,contar);
	writeln('En esa fecha se alquilaron ',contar,' autos');
end.

