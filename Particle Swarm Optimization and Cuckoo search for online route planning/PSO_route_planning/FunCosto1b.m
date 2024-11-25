function CTotal_x=FunCosto1b(x,Psal,Pdes,Pdir,Data,h,ang,p)
Cto=0;
%p=100;
if x==Psal;
    CTotal_x=inf;
    return
end
xi=Psal+p*(x-Psal)/norm(x-Psal);
lambda=0.1:0.01:1;
trayecto=zeros(length(lambda),2);
for i=1:length(lambda) 
    trayecto(i,:)=Psal*(1-lambda(i))+lambda(i)*xi;
end
trayecto=round(trayecto);
trayecto(trayecto<1)=1;
trayecto(trayecto(:,1)>217,1)=217;trayecto(trayecto(:,2)>314,2)=314;
for g=1:length(trayecto)
    Z(g,1)=Data(trayecto(g,1),trayecto(g,2));
end
% u1=(x-Psal);
% v1=(Pdir-Psal);
% dps=(sqrt(sum((u1-v1).^2)));

%acosd((a^2-b^2+c^2)/(2*c*a))
a=(sqrt(sum((Pdir-Psal).^2)));
b=(sqrt(sum((x-Psal).^2)));
c=(sqrt(sum((Pdir-x).^2)));
dps=acosd((a^2+b^2-c^2)/(2*a*b));
% dps(dps>ang)=2*ang;
if(all(Z<h)&&(dps<300&&dps>0)) %Pregunta si todos los Z son menores que la altura
        
        dt_p=(sqrt(sum((Pdes-Psal).^2)));
        d1=(sqrt(sum((x-Psal).^2)));
        d2=(sqrt(sum((Pdes-x).^2)));  
        
        if dps>ang
            CTotal_x=((((d1+d2)-dt_p)/(dt_p)))+0.01*dps;
% %               CTotal_x=((((d1+d2)-dt_p)/(dt_p)))
%             disp('no')
        else
            CTotal_x=((((d1+d2)-dt_p)/(dt_p)))+(1-0.0000001*ang);
%               CTotal_x=((((d1+d2)-dt_p)/(dt_p)));
%             disp('si')
        end
else
    CTotal_x=Inf;
    
end


% a=(sqrt(sum((Pdir-Psal).^2)));
% b=(sqrt(sum((x-Psal).^2)));
% c=(sqrt(sum((Pdir-x).^2)));
% C=acosd((a^2+b^2-c^2)/(2*a*b));   
