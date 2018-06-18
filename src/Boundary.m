function [Nodes,Index,known_temp]=Boundary(Nx,Ny,Nodes,step,BL,BR,BT,BB,VL,VR,VT,VB)
% this function will generate the nodes properties based on these conditons
% 
% it also create Inxes and known_temp matrix that will be used later to
% generate T matrix
%
% the nodes type asssigned to each nodes are based on following table
% for midle nodes = 0
% for nodes on drichlet boundary = 1
% for nodes on neumann boundary = 2
% for corner nodes on 2 neumann boundary = 4
% Note : for corner nodes on drichlet and neumann = 1
counter=1;
for j=1:Ny
    for i=1:Nx
        Nodes(counter,1)=(i-1)*step;
        Nodes(counter,2)=(j-1)*step;
        Nodes(counter,3)=j;
        Nodes(counter,4)=i;
        counter=counter+1;
    end
end
Index=zeros(Nx*Ny,1);
known_temp=zeros(Nx*Ny,1);
% .............Left boundary......................
if (BL=='D')
    for i=1:Ny
        Nodes((i-1)*Nx+1,5)=1;
        Index((i-1)*Nx+1,1)=1;
        known_temp((i-1)*Nx+1,1)=VL;
    end
elseif(BL=='N')
    for i=1:Ny
        Nodes((i-1)*Nx+1,5)=2;
    end
end
%............Right boundary .......................
if (BR=='D')
    for i=1:Ny
        Nodes(i*Nx,5)=1;
        Index(i*Nx,1)=1;
        known_temp(i*Nx,1)=VR;
    end
elseif(BR=='N')
    for i=1:Ny
        Nodes(i*Nx,5)=2;
    end
end
%...........bottom boundary .........................
if (BB=='D')
    for i=1:Nx
        Nodes(i,5)=1;
        Index(i,1)=1;
        known_temp(i,1)=VB;
    end
elseif(BB=='N')
    for i=1:Nx
        Nodes(i,5)=2;
    end
end
%............Top boundary..........................
if (BT=='D')
    for i=1:Nx
        Nodes((Ny-1)*Nx+i,5)=1;
        Index((Ny-1)*Nx+i,1)=1;
        known_temp((Ny-1)*Nx+i,1)=VT;
    end
elseif(BT=='N')
    for i=1:Nx
        Nodes((Ny-1)*Nx+i,5)=2;
    end
end
%.......Changing node type to D for D-N corners........
if(and(BL=='D',BB=='N'))
    Nodes(1,5)=1;
    Index(1,1)=1;
    known_temp(1,1)=VL;
end
if(and(BL=='N',BB=='D'))
    Nodes(1,5)=1;
    Index(1,1)=1;
    known_temp(1,1)=VB;
end
if(and(BL=='D',BT=='N'))
    Nodes((Ny-1)*Nx+1,5)=1;
    Index((Ny-1)*Nx+1,1)=1;
    known_temp((Ny-1)*Nx+1,5,1)=VL;
end
if(and(BL=='N',BT=='D'))
    Nodes((Ny-1)*Nx+1,5)=1;
    Index((Ny-1)*Nx+1,1)=1;
    known_temp((Ny-1)*Nx+1,5,1)=VT;
end
if(and(BR=='D',BB=='N'))
    Nodes(Nx,5)=1;
    Index(Nx,1)=1;
    known_temp(Nx,1)=VR;
end
if(and(BR=='N',BB=='D'))
    Nodes(Nx,5)=1;
    Index(Nx,1)=1;
    known_temp(Nx,1)=VB;
end
if(and(BR=='D',BT=='N'))
    Nodes(Nx*Ny,5)=1;
    Index(Nx*Ny,1)=1;
    known_temp(Nx*Ny,1)=VR;
end
if(and(BR=='N',BT=='D'))
    Nodes(Nx*Ny,5)=1;
    Index(Nx*Ny,1)=1;
    known_temp(Nx*Ny,1)=VT;
end
%.........checking for 2 corner N conditions........
if(and(BL=='N',BB=='N'))
    Nodes(1,5)=3;
end
if(and(BL=='N',BT=='N'))
    Nodes((Ny-1)*Nx+1,5)=3;
end
if(and(BR=='N',BB=='N'))
    Nodes(Nx,5)=3;
end
if(and(BR=='N',BT=='N'))
    Nodes(Nx*Ny,5)=3;
end


end

