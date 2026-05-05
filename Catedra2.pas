program Catedra2;
const
	COM = 4;
	ALU = 5;
	
type
	estudiante = record
	apellido, nombre : string;
	nota : integer;
	end;
	mCat = array[1..COM, 1..ALU] of estudiante; 
    mInt =  array[1..COM, 1..ALU] of integer;
    

procedure imprimirHorizontal(m : mInt);
var
	fil, col: integer;
begin
	for fil:=1 to COM do begin
			if (fil mod 2 = 0) then begin
				for col := ALU downto 1 do
					write(m[fil, col], ' ');
			end
			else
				for col:= 1 to ALU do
					write(m[fil, col], ' ');
			writeln();
			end;
end;

procedure imprimirVertical(m : mInt);
var
	fil, col: integer;
begin
	for col:=1 to ALU do begin
			if (col mod 2 = 0) then begin
				for fil := COM downto 1 do
					write(m[fil, col], ' ');
			end
			else
				for fil:= 1 to COM do
					write(m[fil, col], ' ');
			writeln();
			end;
end;

procedure buscarHorizontal(m : mCat; val : integer);
var
	fil, col : integer;
	estFound : estudiante;
	found : boolean;
begin
	found := false;
	fil := 1;
	while ((fil <= COM) AND (not found)) do begin
		if (fil mod 2 = 0) then begin
			col := ALU;
			while ((col >= 1) and (not found)) do begin
				if (m[fil,col].nota = val) then begin
					estFound := m[fil,col];
					found := true;
				end
				else
					col := col - 1;
			end;
		end
		else begin
			col := 1;
			while ((col <= ALU) and (not found)) do begin
				if (m[fil,col].nota = val) then begin
					estFound := m[fil,col];
					found := true;
				end
				else
					col := col + 1;
			end;
		end;
		fil := fil + 1;
	end;
	
	if found then
		writeln('El estudiante ', estFound.nombre, ' ', estFound.apellido, ' tiene la nota buscada (', val, ')')
	else
		writeln('No existe');
end;

procedure buscarVertical(m : mCat; val : integer);
var
	fil, col : integer;
	estFound : estudiante;
	found : boolean;
begin
	found := false;
	col := 1;
	while ((col <= ALU) AND (not found)) do begin
		if (col mod 2 = 0) then begin
			fil := COM;
			while ((fil >= 1) and (not found)) do begin
				if (m[fil,col].nota = val) then begin
					estFound := m[fil,col];
					found := true;
				end
				else
					fil := fil - 1;
			end;
		end
		else begin
			fil := 1;
			while ((fil <= COM) and (not found)) do begin
				if (m[fil,col].nota = val) then begin
					estFound := m[fil,col];
					found := true;
				end
				else
					fil := fil + 1;
			end;
		end;
		col := col + 1;
	end;
	
	if found then
		writeln('El estudiante ', estFound.nombre, ' ', estFound.apellido, ' tiene la nota buscada (', val, ')')
	else
		writeln('No existe');
end;