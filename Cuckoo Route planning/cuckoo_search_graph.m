
function [bestnest,fmin]=cuckoo_search_graph(Psal,Pdir,Data)



% Number of nests (or different solutions)

n=60;  %Número de pajaros realizando la busqueda





% Discovery rate of alien eggs/solutions

% pa=0.25;

pa=0.1;

%% Change this if you want to get better results

% Tolerance

Tol=1.0e-0000001;

%% Simple bounds of the search domain

% Lower bounds

nd=2; %NÃºmero de dimensiones es igual a lo que se lleva a la función objetivo

Lb=0*ones(1,nd); 

% Upper bounds

Ub=20*ones(1,nd);



% Random initial solutions

for i=1:n,

nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb))+Psal;
% Xnuevo=randn(n,2)*p+ones(n,1)*Psal; %Posiciones iniciales

end
% xlim([0 217])
% ylim([0 314])
% plot(nest(:,1),nest(:,2),'.');hold on
% 
% axis([0 217 0 314])



% Get the current best

fitness=10^10*ones(n,1);

[fmin,bestnest,nest,fitness]=get_best_nest(nest,nest,fitness,Psal,Pdir,Data);



% plot(bestnest(:,1),bestnest(:,2),'*r')
% 
% pause(0.11)



N_iter=0;

%% Starting iterations

while (N_iter<2000),



    % Generate new solutions (but keep the current best)

     new_nest=get_cuckoos(nest,bestnest,Lb,Ub);   

     [fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness,Psal,Pdir,Data);

    % Update the counter

      N_iter=N_iter+n; 

    % Discovery and randomization

      new_nest=empty_nests(nest,Lb,Ub,pa) ;
      %new_nest(new_nest<-500)=-500;
      %new_nest(new_nest>500)=500;
     %hold off;plot(new_nest(:,1),new_nest(:,2),'.');hold on

%       axis([0 217 00 314])

      

    % Evaluate this set of solutions

      [fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness,Psal,Pdir,Data);

    % Update the counter again

      N_iter=N_iter+n;

    % Find the best objective so far  

    if fnew<=fmin,
       
        fmin=fnew;

        bestnest=best;

    end

%     plot(bestnest(:,1),bestnest(:,2),'*r')
% 
%     pause(0.1)

end %% End of iterations



%% Post-optimization processing

%% Display all the nests

% disp(strcat('Total number of iterations=',num2str(N_iter)));

% fmin=bestnest



%% --------------- All subfunctions are list below ------------------

%% Get cuckoos by ramdom walk

function nest=get_cuckoos(nest,best,Lb,Ub)

% Levy flights

n=size(nest,1);

% Levy exponent and coefficient

% For details, see equation (2.21), Page 16 (chapter 2) of the book

% X. S. Yang, Nature-Inspired Metaheuristic Algorithms, 2nd Edition, Luniver Press, (2010).

beta=3/2;

sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);



for j=1:n,

    s=nest(j,:);

    % This is a simple way of implementing Levy flights

    % For standard random walks, use step=1;

    %% Levy flights by Mantegna's algorithm

    u=randn(size(s))*sigma;
%randn(n,2)*p+ones(n,1)*Psal; %Posiciones iniciales
    v=randn(size(s));

    step=u./abs(v).^(1/beta);

  

    % In the next equation, the difference factor (s-best) means that 

    % when the solution is the best solution, it remains unchanged.     

    stepsize=0.01*step.*(s-best);

    % Here the factor 0.01 comes from the fact that L/100 should the typical

    % step size of walks/flights where L is the typical lenghtscale; 

    % otherwise, Levy flights may become too aggresive/efficient, 

    % which makes new solutions (even) jump out side of the design domain 

    % (and thus wasting evaluations).

    % Now the actual random walks or flights

    s=s+stepsize.*randn(size(s));

   % Apply simple bounds/limits

   nest(j,:)=simplebounds(s,Lb,Ub);

end



%% Find the current best nest

function [fmin,best,nest,fitness]=get_best_nest(nest,newnest,fitness,Psal,Pdir,Data)

% Evaluating all new solutions

for j=1:size(nest,1),

    fnew=fobj(newnest(j,:),Psal,Pdir,Data);
    
    if fnew<=fitness(j),
       
       fitness(j)=fnew;

       nest(j,:)=newnest(j,:);

    end

end

% Find the current best

[fmin,K]=min(fitness) ;

best=nest(K,:);



%% Replace some nests by constructing new solutions/nests

function new_nest=empty_nests(nest,Lb,Ub,pa)

% A fraction of worse nests are discovered with a probability pa

n=size(nest,1);

% Discovered or not -- a status vector

K=rand(size(nest))>pa;



% In the real world, if a cuckoo's egg is very similar to a host's eggs, then 

% this cuckoo's egg is less likely to be discovered, thus the fitness should 

% be related to the difference in solutions.  Therefore, it is a good idea 

% to do a random walk in a biased way with some random step sizes.  

%% New solution by biased/selective random walks

stepsize=rand*(nest(randperm(n),:)-nest(randperm(n),:));

new_nest=nest+stepsize.*K;



% Application of simple constraints

function s=simplebounds(s,Lb,Ub)

  % Apply the lower bound

  ns_tmp=s;

  I=ns_tmp<Lb;

  ns_tmp(I)=Lb(I);

  

  % Apply the upper bounds 

  J=ns_tmp>Ub;

  ns_tmp(J)=Ub(J);

  % Update this new move 

  s=ns_tmp;



%% You can replace the following by your own functions

% A d-dimensional objective function

function CTotal_x=fobj(x,Psal,Pdir,Data)
p=20;
h=1950;
ang=35;
Pdes=[99 213]; %Punto de llegada
if x==Psal;
    CTotal_x=inf;
    return
end
xi=Psal+p*(x-Psal)/norm(x-Psal);
lambda=0.1:0.009:1;
trayecto=zeros(length(lambda),2);
for i=1:length(lambda) 
    trayecto(i,:)=Psal*(1-lambda(i))+lambda(i)*xi;
end
trayecto=round(trayecto);
trayecto(trayecto(:,1)<1,1)=1;trayecto(trayecto(:,2)<1,2)=1;
trayecto(trayecto(:,1)>217,1)=217;trayecto(trayecto(:,2)>314,2)=314;
for g=1:length(trayecto)
    Z(g,1)=Data(trayecto(g,1),trayecto(g,2));
end
a=(sqrt(sum((Pdir-Psal).^2)));
b=(sqrt(sum((x-Psal).^2)));
c=(sqrt(sum((Pdir-x).^2)));
dps=acosd((a^2+b^2-c^2)/(2*a*b));
if(all(Z<h)&&(dps<170&&dps>0)) %Pregunta si todos los Z son menores que la altura
    dt_p=(sqrt(sum((Pdes-Psal).^2)));
        d1=(sqrt(sum((x-Psal).^2)));
        d2=(sqrt(sum((Pdes-x).^2)));  
        
        if dps>ang
            CTotal_x=((((d1+d2)-dt_p)/(dt_p)))+0.1*ang;
%             disp('no')
        else
            CTotal_x=((((d1+d2)-dt_p)/(dt_p)))+(1-0.0000001*ang);
%             disp('si')
        end
else
    CTotal_x=Inf;
    
end

