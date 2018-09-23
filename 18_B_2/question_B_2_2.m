clc;
clear all;
close all;

iter = 1;                                           % 迭代次数初值
a_1=0.99;                                  %温度衰减系数
t0=50;                                            %初始温度
tf=1;                                                    %最后温度
t=t0;
Markov=10;                                                     %Markov链长度

load 18_B.mat a city D_2  population

% population(1)=21.81;
% population(2)=3.0;
% population(3)=45.96;
% population(4)=80.41;
% population(5)=28.8;
% population(6)=37.32;
% population(7)=94.02;
% population(8)=57.24;
% population(9)=104.3;
% population(10)=19.6+12.9;
% population(11)=23.0;
% population(12)=38.31;

best_f=0; %最大网络价值
f=0;
best_p=0;
p=0;
best_load=0;




while t>=tf
            for j=1:Markov
                p = randperm(46,16);   %存在中间节点，两个节点一条连接
                % p=randi([1 46],1,16); %存在中间节点，两个节点任意连接
                p_flag(1:12) = 0;
                p_a = a;

                X = zeros(12,12);
                X_1 = zeros(12,12);
%                 for i=1:12
%                     X(i,i)=0;
%                     X_1(i,i)=0;
%                 end
% figure
            Xload_1 = D_2;
            Xload = zeros(12,12);

            for i=1:16
                if  p_flag(p_a(p(i),2)) ~=1 || p_flag(p_a(p(i),3)) ~=1
                    p_flag(p_a(p(i),2)) =1;
                    p_flag(p_a(p(i),3)) =1;
                end
                X(p_a(p(i),2),p_a(p(i),3)) = 1;
                X(p_a(p(i),3),p_a(p(i),2)) = 1;
    
                X_1(p_a(p(i),2),p_a(p(i),3)) = 1;
                X_1(p_a(p(i),3),p_a(p(i),2)) = 1;
    
                Xload(p_a(p(i),2),p_a(p(i),3)) = Xload_1(p_a(p(i),2),p_a(p(i),3));
                Xload(p_a(p(i),3),p_a(p(i),2)) = Xload_1(p_a(p(i),3),p_a(p(i),2));
    
    
%     hold on,plot([city(p_a(p(i),2),1);city(p_a(p(i),3),1)],[city(p_a(p(i),2),2);city(p_a(p(i),3),2)]);
            end
            
            for i=1:12
                for j=(i+1):12
                    if X_1(i,j)==0
                        X_1(i,j)=100000000;
                        X_1(j,i)=X_1(i,j);
                    end
                end
            end

            if p_flag(1:12) == 1
                for i=1:12
                    for j=(i+1):12
                        if X(i,j)==0
                            [shortestPath, totalCost] = Dijkstra(X_1,i,j);
                            for ii=1:(length(shortestPath)-1)
                                Xload(shortestPath(ii),shortestPath(ii+1)) = Xload(shortestPath(ii),shortestPath(ii+1)) -5;
                                Xload(shortestPath(ii+1),shortestPath(ii)) = Xload(shortestPath(ii+1),shortestPath(ii)) -5;
                            end
%                             X_1(i,j)=0;
%                             X_1(j,i)=0;
                        end
                    end
                end
                f = 0;
            for ii =1:12
                for jj=(ii+1):12
                    f = f + Xload(ii,jj)*8*sqrt(population(ii)*population(jj))/100;
                end
            end
            end
            
            f_new = f;
            p_new = p;
            load_new = Xload;
                           %对最优路线和距离更新
                     if       f_new>best_f
                                    iter = iter + 1;    
                                     best_f=f_new;
                                     best_p=p_new;
                                     best_load=load_new;
                     elseif rand<exp(-(f_new-f)/t)
                                  f=f_new;
                                  p=p_new;
                                  Xload=load_new;
               
                     end
            
 
             end              
             t=t*a_1;
end

D_222 = D_2 - best_load;
for i=1:12
    for j=1:12
        if D_222(i,j) >= 100
            D_222(i,j) = 0;
        end
    end
end

figure
for i=1:16
    plot(city(:,1),city(:,2),'ro');
    hold on,plot([city(p_a(best_p(i),2),1);city(p_a(best_p(i),3),1)],[city(p_a(best_p(i),2),2);city(p_a(best_p(i),3),2)]);
end

title('光传送网络规划  连接数=16')