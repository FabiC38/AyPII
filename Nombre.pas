program Nombre;
uses GenericABB;
type 
    ABBNombre=specialize ABB<string>;
procedure agregarNodo(a:ABBNombre; n:string);
begin 
    if a.isEmpty()then 
        a.insertCurrent(n)
    else 
    if n<a.current()then 
        agregarNodo(a.getLeftChild(),n)
    else 
        agregarNodo(a.getRightChild(),n);
end;
procedure cargarArbol(a:ABBNombre);
var 
    n:string;
begin 
    writeln('Escribir un nombre(ZZZ lo termina');
    readln(n);
    while(n<>'ZZZ')do 
    begin 
        agregarNodo(a,n);
        writeln('Escribir un nombre(ZZZ lo termina');
        readln(n);
    end;
end;
function buscarUnNombre(a:ABBNombre;buscar:string):boolean;
begin
    if(a.isEmpty())then 
        buscarUnNombre:=false
    else 
    if(a.current()=buscar)then 
        buscarUnNombre:=true
    else 
    if buscar<a.current()then 
        buscarUnNombre:=buscarUnNombre(a.getLeftChild(),buscar)
    else 
        buscarUnNombre:=buscarUnNombre(a.getRightChild(),buscar);
end;
procedure imprimir(a:ABBNombre);
begin 
    if not a.isEmpty()then 
    begin 
        imprimir(a.getLeftChild());
        writeln(a.current());
        imprimir(a.getRightChild());
    end;
end;
procedure imprimirRango(a:ABBNombre;min,max:string);
begin 
    if not a.isEmpty()then 
    begin 
        if(a.current()>=min)and(a.current()<=max)then 
        begin 
            imprimirRango(a.getLeftChild(),min,max);
            writeln(a.current());
            imprimirRango(a.getRightChild(),min,max);
        end 
        else 
        if(a.current()>min)then 
            imprimirRango(a.getLeftChild(),min,max)
        else
            imprimirRango(a.getRightChild(),min,max);
    end;
end;
var 
    a:ABBNombre;
    n1,n2:string;
begin 
    a:=ABBNombre.create();
    cargarArbol(a);
    writeln('Ingresar nombre para saber si esta');
    readln(n1);
    if(buscarUnNombre(a,n1))then 
        writeln('El nombre se encuentra')
    else 
        writeln('El nombre no se encuentra');
    imprimir(a);
    writeln('Ingresar nombre minimo');
    readln(n1);
    writeln('Ingresar nombre max');
    readln(n2);
    imprimirRango(a,n1,n2);
end.
