program Catedra;
const 
    COM=4;
    ALU=5;
type 
    estudiante= record
        nombre:string;
        apellido:string;
        nota:integer;  
    end;
    mCat=array[1..COM,1..ALU] of estudiante;
procedure leerEstudiante(var e:estudiante);
begin
    writeln('NOMBRE:');
    readln(e.nombre);
    writeln('APELLIDO:');
    readln(e.apellido);
    writeln('NOTA:');
    readln(e.nota);
end;
//Implemente un módulo que almacenela información de los 20 estudiantes.
procedure cargarCatedra(var m:mCat);
var 
    fil,col:integer;
    e:estudiante;
begin
    for fil:=1 to COM do 
    begin
        for col:=1 to ALU do 
        begin
            writeln('ESTUDIANTE ',col,' COMISION NUMERO ',fil);
            leerEstudiante(e);
            m[fil,col]:=e;
        end;
    end;
end;
function Maximo(m:mCat):estudiante;
var 
    fil,col:integer;
    e:estudiante;
begin
    e:=m[1,1];
    for fil:=1 to COM do
    begin
        for col:=1 to ALU do
        begin
            if(e.nota < m[fil,col].nota)then 
                e:=m[fil,col];
        end;
    end;
    Maximo:=e;
end;
function existeNota(m:mCat;n:integer):boolean;
var 
    fil,col:integer;
begin
    existeNota:=false;
    for fil:=1 to COM do 
        for col:=1 to ALU do 
            if(n=m[fil,col].nota)then 
                existeNota:=true;
end;
var 
    m:mCat;
    e:estudiante;
    buscar:integer;
begin
    cargarCatedra(m);
    e:=Maximo(m);
    writeln('El estudiante ',e.nombre,' ',e.apellido,' tiene la nota maxima ',e.nota);
    writeln('Insertar una nota para buscar');
    readln(buscar);
    if existeNota(m,buscar)then 
        writeln('Existe')
    else 
        writeln('No existe');
end.