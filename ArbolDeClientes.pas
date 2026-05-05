program Ejercicio2;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_CLIENTES = 30;

type 	
	Cliente = record
		nombre, apellido: string;
		DNI: integer;
		categoria: integer;
	end;
	ListaCliente = specialize LinkedList<Cliente>;
	ABBClientes=specialize ABB<Cliente>;
	
// Use esta función para obtener la lista que se "dispone"
function ObtenerClientes: ListaCliente;
var lista: ListaCliente;
	nValores, i, j, swap: integer;
	cli: Cliente;
	indices: array [1..CANTIDAD_CLIENTES] of integer;
	dnis: array [1..CANTIDAD_CLIENTES] of integer = (1234, 1872, 1970, 2345, 3109, 3892, 4520, 4781, 5601, 5905,
	                                                 6254, 6822, 7974, 8145, 9109, 9892, 10520, 10781, 12601, 12905,
	                                                 21834, 21879, 21990, 22745, 23109, 23892, 24520, 24781, 25601, 25905);
	nombres: array [1..CANTIDAD_CLIENTES] of string = ('Maria',   'Jose',    'Wei',    'Yan',   'Ali',     'John',    'David',  'Li',        'Ana',   'Michael',
														'Juan' ,   'Roberto', 'Daniel', 'Luis',  'Carlos',  'Antonio', 'Elena',  'Francisco', 'Peter', 'Fatima',
														'Richard', 'Paul',    'Olga',   'Pedro', 'William', 'Rosa',    'Thomas', 'Jorge',     'Yong',  'Elizabeth');
	apellidos: array [1..CANTIDAD_CLIENTES] of string = ('Gonzalez', 'Gomez',  'Diaz',    'Rodriguez', 'Fernandez', 'Martinez', 'Lopez', 'Gutierrez', 'Hernandez', 'Benitez',
	                                                      'Perez',    'Romero', 'Flores',  'Garcia',    'Sosa',	     'Sanchez',	 'Perez', 'Cortez',    'Quiroga',   'Ruiz',
	                                                      'Ramirez',  'Cruz',   'Estevez', 'Vasquez',   'Zapata',    'Rojas',    'Soto',  'Silva',     'Sepulveda', 'Morales');

begin
lista:= ListaCliente.create();

nValores:= random(CANTIDAD_CLIENTES - 6) + 5;	//Nos aseguramos un mínimo de 5 clientes

for i:= 1 to CANTIDAD_CLIENTES do
	indices[i]:= i; 
for i:= 1 to CANTIDAD_CLIENTES do
	begin
	j:= random(CANTIDAD_CLIENTES) + 1;
	swap:= indices[i];
	indices[i]:= indices[j];
	indices[j]:= swap;
	end;
	
for i:= 1 to nValores do
	begin
	cli.DNI:= dnis[indices[i]];
	cli.nombre:= nombres[random(CANTIDAD_CLIENTES) + 1];
	cli.apellido:= apellidos[random(CANTIDAD_CLIENTES) + 1];
	cli.categoria:= random(5) + 1;
	
	lista.add(cli);
	end;
	
ObtenerClientes:= lista;
end;
//--------------------------------------------------------
procedure insertarCliente(a:ABBClientes;c:Cliente);
begin 
	if a.isEmpty()then 
		a.insertCurrent(c)
	else 
	if c.DNI<a.current().DNI then 
		insertarCliente(a.getLeftChild(),c)
	else 
		insertarCliente(a.getRightChild(),c);
end;
procedure cargarArbol(a:ABBClientes;l:ListaCliente);
begin 
	l.reset();
	while not l.eol()do 
	begin 
		insertarCliente(a,l.current());
		l.next();
	end;
end;
procedure buscarCat(a:ABBClientes;dni:integer);
begin 
	if a.isEmpty()then 
		writeln('No encontrado')
	else 
	if a.current().DNI=dni then 
		writeln('Categoria: ',a.current().categoria)
	else 
	if dni<a.current().DNI then 
		buscarCat(a.getLeftChild(),dni)
	else 
		buscarCat(a.getRightChild(),dni);
end;
procedure imprimirRango(a:ABBClientes;dniInf,dniSup:integer);
begin 
	if not a.isEmpty()then 
	begin
		if(a.current().DNI>=dniInf)and(a.current().DNI<=dniSup)then 
		begin 
			imprimirRango(a.getLeftChild(),dniInf,dniSup);
			writeln(a.current().nombre,' ',a.current().apellido);
			imprimirRango(a.getRightChild(),dniInf,dniSup);
		end 
		else 
		if a.current().DNI<=dniInf THEN 
			imprimirRango(a.getRightChild(),dniInf,dniSup)
		else 
			imprimirRango(a.getLeftChild(),dniInf,dniSup);
	end;
end;
procedure imprimirCategoria(a:ABBClientes;cat:integer);
begin 
	if not a.isEmpty()then
	begin
		imprimirCategoria(a.getLeftChild(),cat);
		if a.current().categoria=cat then 
			writeln(a.current().nombre,' ',a.current().apellido,'[',a.current().DNI,']');
		imprimirCategoria(a.getRightChild(),cat);
	end;
end;
var 
	l: ListaCliente;
	a:ABBClientes;
	dni1,dni2,cat:integer;
begin
	randomize;

	writeln('Obteniendo lista');
	l:= ObtenerClientes();
	a:=ABBClientes.create();
	cargarArbol(a,l);
	writeln('Insertar un dni para buscar');
	readln(dni1);
	buscarCat(a,dni1);
	writeln('Ingresar dni bajo para buscar en el rango');
	readln(dni1);
	writeln('Ingresar dni alto para buscar en el rango');
	readln(dni2);
	imprimirRango(a,dni1,dni2);
	writeln('Ingresar una categoria para imprimir');
	readln(cat);
	imprimirCategoria(a,cat);
end.
