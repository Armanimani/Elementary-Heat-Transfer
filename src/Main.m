% The following program is capable of solving heat transsfer problems using
% finite difference method.
%
% the boundary of the domain can be either Drichlet or Neumann.
%
% there are no limitation in the positioning or number of each boundary
% conditons that can be used in  this program , for example u can use 3
% neumann BC , 4 Drichlet BC , ....
%
% there are no limitations in the length of our domain it can be either
% squre or rectangular.
%
% the data will be read from the input.txt file and the outputs are 2 .plt
% files; one is for steady state solution and one is for non-steady
% solution.
%
% Additional information about this project is available in the main PDF of
% project.

tic
clc;
clear all;
format long;
%.................Reading Data from input.txt..............................
fid=fopen('input.txt');
fgetl(fid);
BL=fgetl(fid);
BR=fgetl(fid);
BT=fgetl(fid);
BB=fgetl(fid);
fgetl(fid);
VL=str2double(fgetl(fid));
VR=str2double(fgetl(fid));
VT=str2double(fgetl(fid));
VB=str2double(fgetl(fid));
fgetl(fid);
Q=str2double(fgetl(fid));
fgetl(fid);
k=str2double(fgetl(fid));
fgetl(fid);
step=str2double(fgetl(fid));
fgetl(fid);
lx=str2double(fgetl(fid));
fgetl(fid);
ly=str2double(fgetl(fid));
fgetl(fid);
time_step=str2double(fgetl(fid));
fgetl(fid);
Max_time=str2double(fgetl(fid));
Ny=lx/step+1;
Nx=ly/step+1;
Nodes=zeros(Nx*Ny,5);
%...Assigning boundary condition type to each nodes as explained in PDF
%....................Calling boundary function..........................
[Nodes,Index,known_temp]=Boundary(Nx,Ny,Nodes,step,BL,BR,BT,BB,VL,VR,VT,VB);
%...........Generating K and F matrix based on the node types..............
K=zeros(Nx*Ny,Nx*Ny);
F=zeros(Nx*Ny,1);
%................... Calling stiffness matrix ............................
[F,K]=Stiffness(Nx,Ny,Nodes,K,F,known_temp,VL,VR,VT,VB,Q,k,step);
k_temp=K;
f_temp=F;
ii=0;
%...........removing columns and rows of drichlet's points................
for i=1:Nx*Ny
    if (Index(i,1)==1)
        K(i-ii,:)=[];
        K(:,i-ii)=[];
        F(i-ii,:)=[];
        ii=ii+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%.................Solving for steady state T.............................%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_temp=K\F;
ii=1;
%........................Generating T matrix .............................
for i=1:Nx*Ny
    if (Index(i,1)==1)
        T(i,1)=known_temp(i,1);
    else
        T(i,1)=t_temp(ii,1);
        ii=ii+1;
    end
end
%...............Creating output1 matrix to write in output................
fclose(fid);
fid=fopen('Steady_state_solution.plt','wt');
for i=1:Nx*Ny
    output1(i,1)=Nodes(i,1);
    output1(i,2)=Nodes(i,2);
    output1(i,3)=T(i,1);
end
%...Writing the steady-state result in output txt file for tecplot.........
output1=output1';
fprintf(fid,'%10.5f     %10.5f      %10.5f \n',output1);
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%...........................None-steady solution..........................%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid=fopen('Nonsteady_solution.plt','wt');
DOF=size(t_temp,1);
T1=zeros(DOF,1);
time=0;
ST=1;
fprintf(fid,'ZONE\nSOLUTIONTIME=%d \n',ST);
ii=1;
clear output1;
%......................Creating T0 matrix..................................
for i=1:Nx*Ny
    if (Index(i,1)==1)
        T(i,1)=known_temp(i,1);
    else
        T(i,1)=T1(ii,1);
        ii=ii+1;
    end
end
for i=1:Nx*Ny
    output1(i,1)=Nodes(i,1);
    output1(i,2)=Nodes(i,2);
    output1(i,3)=T(i,1);
end
output1=output1';
fprintf(fid,'%10.5f     %10.5f      %10.5f \n',output1);
%............... calculating for T till the max time .....................
while (time<=Max_time)
    Td1=(K*T1-F);
    Td2=Td1;
    %............Irritaion to calculate the T2............................
    for i=1:10
        T2=T1+time_step*0.5*(Td1+Td2);
        Td2_temp=(K*T2-F);
        error=Td2_temp-Td2;
        Td2=Td2_temp;
    end
    T1=T2;
    Td1=Td2;
    ST=ST+1;
    fprintf(fid,'ZONE\nSOLUTIONTIME=%d \n',ST);
    clear output1;
    ii=1;
    %...................Generating T matrix .............................
    for i=1:Nx*Ny
        if (Index(i,1)==1)
            T(i,1)=known_temp(i,1);
        else
            T(i,1)=T1(ii,1);
            ii=ii+1;
        end
    end
    %..........Generatin output1 file that can be used with tecplot........
    for i=1:Nx*Ny
        output1(i,1)=Nodes(i,1);
        output1(i,2)=Nodes(i,2);
        output1(i,3)=T(i,1);
    end
    %......writing outputs to txt file that can be read for tecplot........
    output1=output1';
    fprintf(fid,'%10.5f     %10.5f      %10.5f \n',output1);
    time=time+time_step;
end
toc