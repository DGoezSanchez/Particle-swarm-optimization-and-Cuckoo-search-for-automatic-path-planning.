clear all; close all
clc
load('Dat_217_314')
load('Lat217')
load('Lon314')
% load('Mede-Man.mat')
h=1950;
% Data=M(1:3:end,1:4:2900); 
Data=sM; 
lambda=0.1:0.1:1;
% Data(Data<h)=-Inf;
vel=500;
vel=vel/40;
p=20;
Psal=[48 41]; %Punto de salida
Pdes=[99 213]; %Punto de llegada
Pdir=Pdes;
TimeProceso=0;
MJ(:,1)=Psal(1);
MJ(:,2)=Psal(2);
MJ(:,3)=0;
MJ(:,4)=TimeProceso;
hold on
mesh (Data')
%contour(Data'); 
for i=2:inf
    tic;
    PsalR=Psal;
    mj=cuckoo_search_graph(Psal,Pdir,Data); %Cálculo de la siguiente posición
    Pdir=Psal+0.4*vel*(mj-Psal)/norm(mj-Psal);
    Psal=Psal+0.2*vel*(mj-Psal)/norm(mj-Psal);
    TimeProceso=toc;
    MJ(i,:)=[Psal(1),Psal(2),Dis_geodesica([sLat(round(Psal(1))) sLon(round(Psal(2)))], [sLat(round(PsalR(1))) sLon(round(PsalR(2)))]),TimeProceso];
    Dist=Dis_geodesica([sLat(round(Psal(1))) sLon(round(Psal(2)))], [sLat(round(Pdes(1))) sLon(round(Pdes(2)))]);
    plot3(Psal(:,1),Psal(:,2),h,'r.')
    axis([0 217 0 314])
    pause(0.00001)
    trayPve=zeros(length(lambda),2);
    for n=1:length(lambda) 
        trayPve(n,:)=Psal*(1-lambda(n))+lambda(n)*Pdes;
    end
    trayPve=round(trayPve);
    for g=1:length(trayPve)
        Z(g,1)=Data(trayPve(g,1),trayPve(g,2));
    end
    if Dist<p
        p1=Dist;
    end
    if Dist<1&&all(Z<h)
        i=i+1;
         MJ(i,:)=[Pdes(1),Pdes(2),Dis_geodesica([sLat(round(Psal(1))) sLon(round(Psal(2)))], [sLat(round(Pdes(1))) sLon(round(Pdes(2)))]),0];
         MJ=abs(MJ);
         plot3(Pdes(:,1),Pdes(:,2),h,'r.')
        break
    end
end
% hold off
% hold on
% mesh (Data')
% plot3(MJ(:,1),MJ(:,2),h*ones(length(MJ),1),'LineWidth',2);
% plot3(MJ(:,1),MJ(:,2),h*ones(length(MJ),1),'r.');