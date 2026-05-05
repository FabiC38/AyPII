program Adicional3;
uses SysUtils, GenericABB, GenericLinkedList;

const
	CANTIDAD_FILAS = 80;
	CANTIDAD_BUTACAS = 100;
	CANTIDAD_OBRAS = 20;

type 	
	EntradaVendida = record
		fecha: string;
		nombre_obra: string;
		fila, butaca: integer;
		dni_espectador: integer;
	end;
	ListaEntradasVendidas = specialize LinkedList<EntradaVendida>;

// Use esta función para obtener la lista de entradas vendidas
procedure ObtenerEntradasVendidas(var lista: ListaEntradasVendidas);
var i, nValores, dia: integer;
	sdia: string;
	enVen: EntradaVendida;
	obras: array [1..CANTIDAD_OBRAS] of string = ('Romeo y Julieta', 'Hamlet', 'Don Juan Tenorio', 'El fantasma de la opera', 'La Celestina',
	                                              'Casa de muñecas', 'Un tranvia llamado deseo', 'La gaviota', 'Bodas de sangre', 'Las troyanas',
	                                              'Guillermo Tell', 'Antigona', 'Los miserables', 'La divina comedia', 'La casa de Bernarda Alba',
	                                              'Fuente Ovejuna', 'Las aves', 'El burlador de Sevilla', 'Tres sombreros de copa', 'La venganza de Don Mendo');

begin
lista:= ListaEntradasVendidas.create();

nValores:= random(1000) + 200;

// Generamos N ventas de entradas y las almacenamos en la lista
for i:= 1 to nValores do
	begin
	dia:= random(30)+1;
	sdia:= IntToStr(dia);
	if dia < 10 then
		sdia:= '0' + sdia;
	enVen.fecha:= '2023-09-' + sdia;
		
	enVen.nombre_obra:= obras[random(CANTIDAD_OBRAS) + 1];
		
	enVen.fila:= random(CANTIDAD_FILAS) + 1;
	enVen.butaca:= random(CANTIDAD_BUTACAS) + 1;
	enVen.dni_espectador:= random(20000) + 300;

	lista.add(enVen);
	end;
end;
//--------------------------------------------------------

var l: ListaEntradasVendidas;
begin
randomize;

writeln('Obteniendo lista');
ObtenerEntradasVendidas(l);


end.
