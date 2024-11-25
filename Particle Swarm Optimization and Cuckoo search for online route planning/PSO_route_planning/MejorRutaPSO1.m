clear all; close all
clc
load('Dat217_314')
vel=500;
vel=vel/40;
% load('Mede-Mn.mat')
h=2550;
% Data=M(1:3:end,1:4:2900); 
Data=sM; 
Data(Data<h)=-Inf;
p=10; %Distancia para lanzar partículas
p1=p;
% Pdes=[88 283]; %Punto de llegada
% Psal=[43 195]; %Punto de salida
% Pdes=[45 174]; %Punto de llegada
Psal=[60 198]; %Punto de salida
Pdes=[100 25]; %Punto de llegada
% Pdir=Psal+p*(Pdes-Psal)/norm(Pdes-Psal);
Pdir=Pdes;
TimeProceso=0;
MJ(1)=Psal(1);
MJ(2)=Psal(2);
MJ(3)=0;
MJ(4)=0;
ang=45;
lambda=0.1:0.1:1;
hold on
mesh (Data')
% contour(Data'); 
tic;
for v=2:inf
    tic;
    PsalR=Psal;
    mj=pso2D1(Pdes,Psal,Pdir,p1,Data,h,ang); %Cï¿½lculo de la siguiente posiciï¿½n 
%     Pdir=Psal+2*TimeProceso*vel*(mj-Psal)/norm(mj-Psal);
%     Psal=Psal+TimeProceso*vel*(mj-Psal)/norm(mj-Psal);
    Pdir=Psal+0.3*vel*(mj-Psal)/norm(mj-Psal);
    Psal=Psal+0.2*vel*(mj-Psal)/norm(mj-Psal);
    TimeProceso=toc;
    MJ=[MJ;Psal(1),Psal(2),distanciaGeodesica([sLat(round(Psal(1))) sLon(round(Psal(2)))], [sLat(round(PsalR(1))) sLon(round(PsalR(2)))]),TimeProceso];
    %disp(MJ(v,:));
    %     MJ1=[MJ1; Psal];
%     MJ2=[MJ2; [distanciaGeodesica([sLat(round(Psal(1))) sLon(round(Psal(2)))], [sLat(round(PsalR(1))) sLon(round(PsalR(2)))]),TimeProceso]];
    Dist=distanciaGeodesica([sLat(round(Pdes(1))) sLon(round(Pdes(2)))], [sLat(round(Psal(1))) sLon(round(Psal(2)))]);
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
    if Dist<2&&all(Z<h)
         MJ=[MJ;Pdes(1),Pdes(2),distanciaGeodesica([sLat(round(Psal(1))) sLon(round(Psal(2)))], [sLat(round(PsalR(1))) sLon(round(PsalR(2)))]),TimeProceso];
        break
    end
    TimeProceso=toc;
end
axis([0 217 0 314])
hold on
plot3(MJ(:,1),MJ(:,2),h*ones(length(MJ),1),'LineWidth',2);
plot3(MJ(:,1),MJ(:,2),h*ones(length(MJ),1),'r.');
% mesh(Data'); %AQUï¿½ SE LE RESTA LA ALTURA!!!
analisis(1)=std(MJ(:,4));  %Desviación estandar del tiempo
analisis(2)=mean(MJ(:,4));  %media del tiempo
analisis(3)=sum(MJ(:,4));  %tiempo total de la ruta
analisis(4)=sum(MJ(:,3));  %Distancia total recorrida
analisis(5)=length(MJ(:,1));
