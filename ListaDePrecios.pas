program ListaDePrecios;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_PRODUCTOS = 30;

type 	
    // Tipos de datos a usar en la activdad 3, 4, 5 y 6
	Producto = record
		descripcion: string;
		codigo: integer;
		precio: real;
	end;
	ListaProducto = specialize LinkedList<Producto>;
	//------------------------------------------------------------------
	ABBProducto=specialize ABB<Producto>;
	// Registro a usar en la activdad 4 y 6
	ProductoAComprar = record
		codigo: integer;
		cantidad: integer;
	end;
	ListaCompra = specialize LinkedList<ProductoAComprar>;
	//------------------------------------------------------------------
	
	// Uso interno del módulo que genera las listas
	VectorCodigos = array [1..CANTIDAD_PRODUCTOS] of integer;
	//------------------------------------------------------------------
	ProductoR=record 
		codigo:integer;
		ocurrencias:integer;
	end;
	ABBProductoR=specialize ABB<ProductoR>;

// Use este módulo para obtener la lista de precios que se "dispone" para las actividades 3, 4, 5 y 6
procedure ObtenerListaDePrecios(var lista: ListaProducto; var codigos: VectorCodigos; var nValores: integer);
var i, j, swap: integer;
	swap_s: string;
	prod: Producto;
	codigos_db: array [1..CANTIDAD_PRODUCTOS] of integer = (1234, 1872, 1970, 2345, 3109, 3892, 4520, 4781, 5601, 5905,
	                                                 6254, 6822, 7974, 8145, 9109, 9892, 10520, 10781, 12601, 12905,
	                                                 21834, 21879, 21990, 22745, 23109, 23892, 24520, 24781, 25601, 25905);
	descripciones_db: array [1..CANTIDAD_PRODUCTOS] of string = ('Musculosa',   'Pelota de basquet',    'Paleta',    'Mancuerna',   'Guante',     'Remera',    'Remo',  'Red',        'Casco',   'Botines',
														'Aro de basquet' ,   'Bicicleta', 'Palo de hockey', 'Pelota de futbol',  'Mesa de ping pong',  'Kayak', 'Rodillera',  'Protector bucal', 'Raqueta', 'Colchoneta',
														'Cronometro', 'Botella',    'Banda elastica',   'Caña de pescar', 'Cono plastico', 'Canillera',    'Rollers', 'Bate',     'Antiparra',  'Gorra');

begin
lista:= ListaProducto.create();

nValores:= random(CANTIDAD_PRODUCTOS - 6) + 5;	//Nos aseguramos un mínimo de 5 productos

// Copiamos los códigos al vector pasado por parámetro. Este vector luego será meclado al azar.
// Los códigos que se agreguen a la lista que se dispone serán tomados secuencialmente de este vector.
// De esta manera garantizamos que no haya códigos repetidos en la lista que se dispone.
for i:= 1 to CANTIDAD_PRODUCTOS do
	codigos[i]:= codigos_db[i];
// Mezclamos los códigos y las descripciones al azar.
// Los valores serán tomados de manera secuencial comenzando por el primer elemento.
for i:= 1 to CANTIDAD_PRODUCTOS do
	begin
	j:= random(CANTIDAD_PRODUCTOS) + 1;
	swap:= codigos[i];
	codigos[i]:= codigos[j];
	codigos[j]:= swap;
	
	j:= random(CANTIDAD_PRODUCTOS) + 1;
	swap_s:= descripciones_db[i];
	descripciones_db[i]:= descripciones_db[j];
	descripciones_db[j]:= swap_s;
	end;
	
// Generamos N productos y lo almacenamos en la lista
for i:= 1 to nValores do
	begin
	prod.codigo:= codigos[i];
	prod.descripcion:= descripciones_db[i];
	prod.precio:= (random(10000) + 2000) / 100;
	
	lista.add(prod);
	end;
end;
//----------------------------------------------------------------------
procedure insertarProducto(a:ABBProducto;p:Producto);
begin 
	if a.isEmpty()then 
		a.insertCurrent(p)
	else 
	if p.codigo<a.current().codigo then 
		insertarProducto(a.getLeftChild(),p)
	else 
		insertarProducto(a.getRightChild(),p);
end;
procedure cargarArbol(a:ABBProducto;l:ListaProducto);
begin 
	l.reset();
	while not l.eol() do 
	begin 
		insertarProducto(a,l.current());
		l.next();
	end;
end;

procedure buscarPrecio(a:ABBProducto;cod:integer);
begin 
	if a.isEmpty()then 
		writeln('No encontrado')
	else 
	if a.current().codigo=cod then 
		writeln('El precio del producto es ',a.current().precio:0:2)
	else 
	if cod<a.current().codigo then 
		buscarPrecio(a.getLeftChild(),cod)
	else 
		buscarPrecio(a.getRightChild(),cod);
end;

procedure iterar(a:ABBProducto;var min,max:Producto);
begin 
	if not a.isEmpty()then 
	begin 
		iterar(a.getLeftChild(),min,max);
		if(a.current().precio<min.precio)then 
			min:=a.current();
		if(a.current().precio>max.precio)then 
			max:=a.current();
		iterar(a.getRightChild(),min,max);
	end;
end;
procedure imprimirMinMax(a:ABBProducto);
var 
	min,max:Producto;
begin 
	min.precio:=9999;
	min.codigo:=-1;
	min.descripcion:='';
	max.precio:=-9999;
	max.codigo:=-1;
	max.descripcion:='';
	iterar(a,min,max);
	writeln('MINIMO ',min.descripcion);
	writeln('MAXIMO ',max.descripcion);
end;

function buscarCompra(a:ABBProducto;p:ProductoAComprar):real;
begin 
	if a.isEmpty()then 
		buscarCompra:=0
	else 
	if a.current().codigo=p.codigo then 
		buscarCompra:=a.current().precio*p.cantidad
	else
	if p.codigo<a.current().codigo then 
		buscarCompra:=buscarCompra(a.getLeftChild(),p)
	else 
		buscarCompra:=buscarCompra(a.getRightChild(),p);
end;
function precioCompras(a:ABBProducto;l:ListaCompra):real;
var 
	sum:real;
begin
	sum:=0;
	l.reset();
	while not l.eol() do 
	begin
		sum:=sum+buscarCompra(a,l.current());
		l.next();
	end;
	precioCompras:=sum;
end;


// Utilice este módulo para obtener la lista de compras que se "dispone" para la actividad 4 y 6
procedure ObtenerListaDeCompra(var lista: ListaCompra; codigos: VectorCodigos; nValores: integer);
var prod: ProductoAComprar;
	i: integer;
begin
lista:= ListaCompra.create();

nValores:= random(nValores - 4) + 3;	//Nos aseguramos un mínimo de 3 productos

for i:= 1 to nValores do
	begin
	// Se usa el vector codigos generado por el procedimiento ObtenerListaDePrecios.
	// Esto se hace para asegurarse de generar una lista de compras con productos existentes.
	prod.codigo:= codigos[i];
	prod.cantidad:= random(15) + 1;
	
	lista.add(prod);
	end;
end;
//--------------------------------------------------------
procedure incrementarPorcentual(a:ABBProducto;por:real);
var 
	p:Producto;
begin
	if not a.isEmpty()then 
	begin
		incrementarPorcentual(a.getLeftChild(),por);
		p:=a.current();
		p.precio:=p.precio*por;
		a.setCurrent(p);
		incrementarPorcentual(a.getRightChild(),por);
	end;
end;
procedure imprimirArbolP(a:ABBProducto);
begin
	if not a.isEmpty() then 
	begin
		imprimirArbolP(a.getLeftChild());
		writeln(a.current().codigo,', PRECIO: ',a.current().precio:0:2);
		imprimirArbolP(a.getRightChild());
	end;
end;
procedure sumarCompra(a:ABBProductoR;p:ProductoAComprar);
var 
	act:ProductoR;
begin
	if a.isEmpty()then 
	begin 
		act.codigo:=p.codigo;
		act.ocurrencias:=p.cantidad;
		a.insertCurrent(act);
	end
	else 
	if a.current().codigo=p.codigo then 
	begin
		act:=a.current();
		act.ocurrencias:=act.ocurrencias+p.cantidad;
		a.setCurrent(act);
	end
	else if p.codigo<a.current().codigo then 
		sumarCompra(a.getLeftChild(),p)
	else 
		sumarCompra(a.getRightChild(),p);

end;
procedure cantidadCompra(a:ABBProductoR;l:ListaCompra);
begin
	l.reset();
	while not l.eol() do 
	begin
		sumarCompra(a,l.current());
		l.next();
	end;
end;
procedure imprimirOcurrencias(a:ABBProductoR);
begin
	if not a.isEmpty()then 
	begin
		imprimirOcurrencias(a.getLeftChild());
		writeln(a.current().codigo,', Ocurrencias: ',a.current().ocurrencias);
		imprimirOcurrencias(a.getRightChild());
	end;
end;
var // Variable a utilizar en la actividad 3, 4, 5 y 6
    lp: ListaProducto;
    //------------------------------------------------------------------
	a:ABBProducto;
	cod1:integer;
	// Variables a utilizar en la actividad 4 y 6
	lc: ListaCompra;
	indices_codigos: VectorCodigos;
	cantidadProductosGenerados: integer;
	arbolIncrementado:ABBProducto;
	//------------------------------------------------------------------
	aRepetible:ABBProductoR;
	i,cantCompras:integer;
begin
randomize;

// Lista a utilizar en la actividad 3, 4, 5 y 6
writeln('Obteniendo lista de precios');
ObtenerListaDePrecios(lp, indices_codigos, cantidadProductosGenerados);
//------------------------------------------------------------------
a:=ABBProducto.create();
cargarArbol(a,lp);
writeln('Ingresar un codigo para buscar');
readln(cod1);
buscarPrecio(a,cod1);
imprimirMinMax(a);
// Lista a utilizar en la actividad 4 y 6
writeln('Obteniendo lista de compras');
ObtenerListaDeCompra(lc, indices_codigos, cantidadProductosGenerados);
writeln('El precio total de la compra es de ',precioCompras(a,lc):0:2);
//------------------------------------------------------------------
writeln('PRECIO PRODUCTOS');
imprimirArbolP(a);
writeln('PRECIO PRODUCTOS INCREMENTADOS EN 10%');
arbolIncrementado:=a;
incrementarPorcentual(arbolIncrementado,1.1);
imprimirArbolP(arbolIncrementado);
aRepetible:=ABBProductoR.create();
writeln('GENERANDO LISTA DE COMPRA');
cantCompras:=random(4)+1;
for i:=1 to cantCompras do 
begin
	ObtenerListaDeCompra(lc, indices_codigos, cantidadProductosGenerados);
	cantidadCompra(aRepetible,lc);	
end;
imprimirOcurrencias(aRepetible);
end.
