program BilleteraVirtual;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_TRANSACCIONES = 90;
	CANTIDAD_BILLETERAS = 30;

type 	
	Transaccion = record
		CVUDestino, CVUOrigen: string;
		monto: real;
	end;
	ListaTransacciones = specialize LinkedList<Transaccion>;
	
	Movimiento = record
		CVUDestinoOrigen: string;
		monto: real;
	end;
	ListaMovimientos = specialize LinkedList<Movimiento>;
	
	Billetera = record
		CVU: string;
		saldoActual: real;
		movimientos: ListaMovimientos;
	end;
	ABBBilleteras=specialize ABB<Billetera>;
// Use esta función para obtener la lista de transacciones entre billeteras virtuales
procedure ObtenerTransacciones(var lista: ListaTransacciones);
var i, nValores: integer;
	tra: Transaccion;
	cvus_db: array [1..CANTIDAD_BILLETERAS] of string = ('1234', '1872', '1970', '2345', '3109', '3892', '4520', '4781', '5601', '5905',
	                                                 '6254', '6822', '7974', '8145', '9109', '9892', '10520', '10781', '12601', '12905',
	                                                 '21834', '21879', '21990', '22745', '23109', '23892', '24520', '24781', '25601', '25905');

begin
lista:= ListaTransacciones.create();

nValores:= random(CANTIDAD_TRANSACCIONES - 16) + 15;	//Nos aseguramos un mínimo de 15 transacciones
	
// Generamos N transacciones y los almacenamos en la lista
for i:= 1 to nValores do
	begin
	tra.CVUOrigen:= cvus_db[random(CANTIDAD_BILLETERAS)+1];
	tra.CVUDestino:= cvus_db[random(CANTIDAD_BILLETERAS)+1];
	while tra.CVUOrigen = tra.CVUDestino do
		tra.CVUDestino:= cvus_db[random(CANTIDAD_BILLETERAS)+1];
	tra.monto:= (random(10000) - 5000) / 100;
	while tra.monto = 0 do
		tra.monto:= (random(10000) - 5000) / 100;
	
	lista.add(tra);
	end;
end;
//--------------------------------------------------------
procedure agregarOrigen(a : ABBBilleteras; tra : Transaccion);
var
	billAct : Billetera;
	movAct : Movimiento;
begin
	if (a.isEmpty()) then begin
		billAct.movimientos := ListaMovimientos.create();
		movAct.CVUDestinoOrigen := tra.CVUDestino;
		movAct.monto := -tra.monto;
		billAct.movimientos.add(movAct);
		billAct.CVU := tra.CVUOrigen;
		billAct.saldoActual := -tra.monto;
		a.insertCurrent(billAct);		
	end
	else if (a.current().CVU = tra.CVUOrigen) then begin
		movAct.CVUDestinoOrigen := tra.CVUDestino;
		movAct.monto := -tra.monto;
		billAct := a.current();
		billAct.movimientos.add(movAct);
		billAct.saldoActual := billAct.saldoActual - tra.monto;
		a.setCurrent(billAct);
	end
	else if (a.current().CVU > tra.CVUOrigen) then
		agregarOrigen(a.getLeftChild(), tra)
	else
		agregarOrigen(a.getRightChild(), tra);
end;

procedure agregarDestino(a : ABBBilleteras; tra : Transaccion);
var
	billAct : Billetera;
	movAct : Movimiento;
begin
	if (a.isEmpty()) then begin
		billAct.movimientos := ListaMovimientos.create();
		movAct.CVUDestinoOrigen := tra.CVUOrigen;
		movAct.monto := tra.monto;
		billAct.movimientos.add(movAct);
		billAct.CVU := tra.CVUDestino;
		billAct.saldoActual := tra.monto;
		a.insertCurrent(billAct);		
	end
	else if (a.current().CVU = tra.CVUDestino) then begin
		movAct.CVUDestinoOrigen := tra.CVUOrigen;
		movAct.monto := tra.monto;
		billAct := a.current();
		billAct.movimientos.add(movAct);
		billAct.saldoActual := billAct.saldoActual + tra.monto;
		a.setCurrent(billAct);
	end
	else if (a.current().CVU > tra.CVUDestino) then
		agregarDestino(a.getLeftChild(), tra)
	else
		agregarDestino(a.getRightChild(), tra);
end;

procedure cargarArbol(a : ABBBilleteras; l : ListaTransacciones);
begin
	l.reset();
	while (not l.eol()) do begin
	  	agregarOrigen(a, l.current());
		agregarDestino(a, l.current());
	  	l.next();
	end;
end;

procedure printBilleteras(a : ABBBilleteras);
begin
	if (not a.isEmpty()) then begin
	  	printBilleteras(a.getLeftChild());
		writeln('[',a.current().CVU,'] SALDO: ',(a.current().saldoActual):0:2);
		printBilleteras(a.getRightChild());
	end;
end;
procedure printMovimientos(a : ABBBilleteras);
var
	mov : Movimiento;
	contador : integer;
begin
	if (not a.isEmpty()) then begin
	  	printMovimientos(a.getLeftChild());
		writeln('=== BILLETERA: ', a.current().CVU, ' ===');
		writeln('Saldo: ', (a.current().saldoActual):0:2);
		writeln('Movimientos:');
		
		contador := 0;
		a.current().movimientos.reset();
		while (not a.current().movimientos.eol()) do begin
			mov := a.current().movimientos.current();
			writeln('  -> CVU: ', mov.CVUDestinoOrigen, ' | Monto: ', (mov.monto):0:2);
			a.current().movimientos.next();
			contador := contador + 1;
		end;
		writeln('Total movimientos: ', contador);
		writeln();
	  	printMovimientos(a.getRightChild());
	end;
end;

procedure printBilleterasConMovimientos(a : ABBBilleteras);
var
	contador : integer;
begin
	if (not a.isEmpty()) then begin
	  	printBilleterasConMovimientos(a.getLeftChild());
		
		contador := 0;
		a.current().movimientos.reset();
		while (not a.current().movimientos.eol()) do begin
			contador := contador + 1;
			a.current().movimientos.next();
		end;
		
		writeln('[',a.current().CVU,'] SALDO: ',(a.current().saldoActual):0:2, ' | MOVIMIENTOS: ', contador);
	  	printBilleterasConMovimientos(a.getRightChild());
	end;
end;

{ Implemente un módulo que reciba un CVU y un ABB previamente 
cargado e imprima el movimiento negativo más chico, el movimiento 
negativo más grande, el movimiento positivo más chico, el movimiento 
positivo más grande y el valor promedio entre todos los movimientos 
de la billetera con el CVU recibido}

procedure buscarDatos(a : ABBBilleteras; cvu : string; var negChico, negGrande, posChico, posGrande, cantCVU : real; var contCVU : integer);
var
	salAct : real;
begin
	if (not a.isEmpty()) then begin
		buscarDatos(a.getLeftChild(), cvu, negChico, negGrande, posChico, posGrande, cantCVU, contCVU);
		salAct := a.current().saldoActual;
		if (salAct < 0) then begin
			if (salAct <  negChico) then
				negChico := salAct;
			if (salAct > negGrande) then
				negGrande := salAct;
		end
		else begin // A efectos prácticos, el 0 es positivo. Perdón a los Lic. en Matemática
		  	if (salAct < posChico) then
				posChico := salAct;
			if (salAct > posGrande) then
				posGrande := salAct;
		end;
		if (a.current().CVU = cvu) then begin
			cantCVU := 0;
			contCVU := 0;
			a.current().movimientos.reset();
			while (not a.current().movimientos.eol()) do begin
				cantCVU := cantCVU + a.current().movimientos.current().monto;
				contCVU := contCVU + 1;
			  	a.current().movimientos.next();
			end;
		end;
		buscarDatos(a.getRightChild(), cvu, negChico, negGrande, posChico, posGrande, cantCVU, contCVU);
	end;
end;

procedure contadores(a : ABBBilleteras; cvu : string);
var
	negativoChico, negativoGrande, positivoChico, positivoGrande : real;
	cantPromCVU : real;
	contPromCVU : integer;
begin
	negativoChico := 0;
	negativoGrande := -32766;
	positivoChico := 32767;
	positivoGrande := 0;
	buscarDatos(a, cvu, negativoChico, negativoGrande, positivoChico, positivoGrande, cantPromCVU, contPromCVU);
	writeln('NEGATIVO MAS CHICO: ',(negativoChico):0:2);
	writeln('NEGATIVO MAS GRANDE: ',(negativoGrande):0:2);
	writeln('POSITIVO MAS CHICO: ',(positivoChico):0:2);
	writeln('POSITIVO MAS GRANDE: ',(positivoGrande):0:2);
	writeln('PROMEDIO DEL CVU BUSCADO: ',(cantPromCVU/contPromCVU):0:2);
end;

{Implemente un módulo que reciba un ABB previamente cargado y 
devuelva la cantidad de billeteras con saldo actual negativo.}

procedure contarNegativos(a : ABBBilleteras; var cont : integer);
begin
	if (not a.isEmpty()) then begin
	  	contarNegativos(a.getLeftChild(), cont);
		if (a.current().saldoActual < 0) then
			cont := cont + 1;
		contarNegativos(a.getRightChild(), cont);
	end;
end;

procedure cantNegativos(a : ABBBilleteras);
var
	cont : integer;
begin
	cont := 0;
	contarNegativos(a, cont);
	writeln('CANT. CUENTAS SALDO NEGATIVO: ',cont);
end;

var 
	l: ListaTransacciones;
	arbol : ABBBilleteras;
	cvuBuscar : string;
begin
	randomize;

{Utilice el módulo ObtenerTransacciones ya implementado por la 
cátedra para obtener una lista de transacciones entre billeteras. }
	writeln('Obteniendo lista');
	ObtenerTransacciones(l);

	arbol := ABBBilleteras.create();
	cargarArbol(arbol, l);
	writeln('IMPRIMIENDO');
	printBilleteras(arbol);

	writeln('===== RESUMEN BILLETERAS =====');
	printBilleterasConMovimientos(arbol);
	
	writeln('===== DETALLE MOVIMIENTOS =====');
	printMovimientos(arbol);

	writeln('Ingresa un CVU para buscar su promedio:');
	readln(cvuBuscar);
	contadores(arbol, cvuBuscar);

	cantNegativos(arbol);
end.
