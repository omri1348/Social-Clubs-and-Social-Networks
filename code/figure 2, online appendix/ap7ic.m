%% loop over m, a, delta, calculate upper and lower bounds according to proposition 7, and check whether the lower bound is indeed lower:
results=zeros(30000,7);
row_count=1;
cum_gap_vec=[];

n_a=13;

for m=[2,3,4,5,7]
    gamma=(n_a-1)/(m-1);
    assert(gamma==round(gamma),'The m-Star environment does not exist for the values specified')
    cum_gap=0;
    for a=0:0.01:0.99
        for delta=0.01:0.01:1-a
            if a+delta>=1
                continue
            end
            
            %to track progress through the command line:
            di=['m=' ,num2str(m),', a=' num2str(a),', delta=', num2str(delta)];  
            disp(di);
            
            %l_h:
            x=2;
            while a+delta^(x-1)>(a+delta^(m-1))^2 && x<n_a
                x=x+1;
            end
            l_h=x;
                
            if gamma>=m
                %upper bound:        
                ub=(m-1)*(a+delta^(m-1));
                %lower bound:
                k=2:m;
                FNS_h=(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2));
                max_FNS_h=max(FNS_h);
                k=m+1:min(l_h,n_a)-1;
                FNL_h=(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2);
                max_FNL_h=max(FNL_h);
                lb=max([max_FNS_h,max_FNL_h]);  
                if lb==max_FNS_h
                    cond=2;
                else %lb==max_FNL_h
                    cond=4;
                end
            else %gamma<m
                %upper bound:
                ub=(m-1)*(a+delta^(m-1));
                %lower bound:
                J_h=(m-1)*((a+delta^m)-(a+delta^(m-1))^2);
                k=2:gamma;
                FNS_h=(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta^(m-1))-(m-1)*((a+delta^(m-1))^2));
                max_FNS_h=max(FNS_h);
                k=gamma+1:m;
                FNI_h=(k-1).*(a+delta.^(k-1))-(ceil(k./gamma)-1).*(a+delta^(m-1))+(n_a-m-(k-ceil(k./gamma))).*(a+delta^(m-1)).*(a+delta.^(k-1))-(n_a-m)*(a+delta^(m-1))^2;
                max_FNI_h=max(FNI_h);
                k=m+1:min(l_h,n_a)-1;
                FNL_h=(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2);
                max_FNL_h=max(FNL_h);
                lb=max([J_h,max_FNS_h,max_FNI_h,max_FNL_h]);  
                if lb==J_h
                    cond=1;
                elseif lb==max_FNS_h
                    cond=2;
                elseif lb==max_FNI_h
                    cond=3;
                else %lb==max_FNL_h
                    cond=4;
                end
            end
            
            %compare upper and lower bounds:
            if ub<lb
                stability_range=0;
            elseif ub==lb
                stability_range=1;
            else %ub>lb
                stability_range=2;
                gap=ub-lb;
            end
            cum_gap=cum_gap+gap;
            
            %store result:
            results(row_count,1)=m;
            results(row_count,2)=a;
            results(row_count,3)=delta;            
            results(row_count,4)=stability_range;
            results(row_count,5)=lb; 
            results(row_count,6)=ub;
            results(row_count,7)=cond;
                 
            row_count=row_count+1;
        end
    end
    cum_gap_vec=[cum_gap_vec,cum_gap];
end 
%delete unnecessary rows in the results matrix:
results=results(results(:,1)~=0,:);
%save workspace:
filename=datestr(now,30);
save(filename)
%% plot results and save graphs:
%plot reults for m=2:
scatter(results(results(:,1)==2 & results(:,4)==2,2),results(results(:,1)==2 & results(:,4)==2,3),'.','b');
hold on
scatter(results(results(:,1)==2 & results(:,4)==0,2),results(results(:,1)==2 & results(:,4)==0,3),'.','r');
hold on
scatter(results(results(:,1)==2 & results(:,4)==1,2),results(results(:,1)==2 & results(:,4)==1,3),'.','g');
title('2-Star')
xlabel('a')
ylabel('delta') 
saveas(gcf,'2-Star.png')

%plot reults for m=3:
hold off
scatter(results(results(:,1)==3 & results(:,4)==2,2),results(results(:,1)==3 & results(:,4)==2,3),'.','b');
hold on
scatter(results(results(:,1)==3 & results(:,4)==0,2),results(results(:,1)==3 & results(:,4)==0,3),'.','r');
hold on
scatter(results(results(:,1)==3 & results(:,4)==1,2),results(results(:,1)==3 & results(:,4)==1,3),'.','g');
title('3-Star')
xlabel('a')
ylabel('delta') 
saveas(gcf,'3-Star.png')

%plot reults for m=4:
hold off
scatter(results(results(:,1)==4 & results(:,4)==2,2),results(results(:,1)==4 & results(:,4)==2,3),'.','b');
hold on
scatter(results(results(:,1)==4 & results(:,4)==0,2),results(results(:,1)==4 & results(:,4)==0,3),'.','r');
hold on
scatter(results(results(:,1)==4 & results(:,4)==1,2),results(results(:,1)==4 & results(:,4)==1,3),'.','g');
title('4-Star')
xlabel('a')
ylabel('delta') 
saveas(gcf,'4-Star.png')

%plot reults for m=5:
hold off
scatter(results(results(:,1)==5 & results(:,4)==2,2),results(results(:,1)==5 & results(:,4)==2,3),'.','b');
hold on
scatter(results(results(:,1)==5 & results(:,4)==0,2),results(results(:,1)==5 & results(:,4)==0,3),'.','r');
hold on
scatter(results(results(:,1)==5 & results(:,4)==1,2),results(results(:,1)==5 & results(:,4)==1,3),'.','g');
title('5-Star')
xlabel('a')
ylabel('delta') 
saveas(gcf,'5-Star.png')

%plot reults for m=7:
hold off
scatter(results(results(:,1)==7 & results(:,4)==2,2),results(results(:,1)==7 & results(:,4)==2,3),'.','b');
hold on
scatter(results(results(:,1)==7 & results(:,4)==0,2),results(results(:,1)==7 & results(:,4)==0,3),'.','r');
hold on
scatter(results(results(:,1)==7 & results(:,4)==1,2),results(results(:,1)==7 & results(:,4)==1,3),'.','g');
title('7-Star')
xlabel('a')
ylabel('delta') 
saveas(gcf,'7-Star.png')