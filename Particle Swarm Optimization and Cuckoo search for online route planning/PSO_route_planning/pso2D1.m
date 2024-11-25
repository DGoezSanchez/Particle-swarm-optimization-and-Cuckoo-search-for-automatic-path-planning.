function [mejor]=pso2D1(Pdes,Psal,Pdir,p,Data,h,ang)
ProDisPar=0;
n=40; %Nï¿½mero de partï¿½culas para hacer la bï¿½squeda
Xnuevo=(rand(n,2)*(2*p)-p+ones(n,1)*Psal); %Posiciones iniciales   (rand(20,2)*20-10+ones(20,1)*[100 100])
Vnuevo=(rand(n,2)); %Velocidades iniciales
Xast=Xnuevo; %Mejor posiciï¿½n de cada partï¿½cula hasta el momento
for(j=1:n)
    Fnuevo(j)=FunCosto1b([Xnuevo(j,1),Xnuevo(j,2)],Psal,Pdes,Pdir,Data,h,ang,p);
end
g=find(Fnuevo==min(Fnuevo));%Mï¿½nimo global hasta el momento
mejor=Xnuevo(g,:);
for(cont=1:380)
    X=Xnuevo;
    V=Vnuevo;
    F=Fnuevo;
    Xnuevo=X+V;
    Xnuevo(Xnuevo<1)=1;
    Xnuevo(Xnuevo(:,1)>217,1)=217;Xnuevo(Xnuevo(:,2)>314,2)=314;
    for(s=1:n)
        Fnuevo(s)=FunCosto1b([Xnuevo(s,1),Xnuevo(s,2)],Psal,Pdes,Pdir,Data,h,ang,p);
        if(Fnuevo(s)<F(s))
            Xast(s,:)=Xnuevo(s,:); %Mejor posición de cada partï¿½cula i
        end
        if(s>1)
        ProDisPar=ProDisPar+(sqrt(sum(( Xast(s,:)- Xast(s-1,:)).^2)));  %suma de las distancias entre las particulas
        end
    end
    ProDisPar=ProDisPar/n;  %Promedio de la distancia
    %disp(ProDisPar)
    gnuevo=find(Fnuevo==min(Fnuevo),1);%Mï¿½nimo global hasta el momento
    mejornuevo=Xnuevo(gnuevo,:);
    %gnuevoX=find(F==min(F),1);
   % MNX=Xnuevo(gnuevoX,:);
    if(FunCosto1b([mejornuevo(1,1),mejornuevo(1,2)],Psal,Pdes,Pdir,Data,h,ang,p)<FunCosto1b([mejor(1,1),mejor(1,2)],Psal,Pdes,Pdir,Data,h,ang,p))
        mejor=mejornuevo;
    end
    Vnuevo=0.7213*V+rand*1.1931*(ones(n,1)*mejor-Xnuevo)+rand*1.1931*(Xast-Xnuevo);
    
end
 
end

