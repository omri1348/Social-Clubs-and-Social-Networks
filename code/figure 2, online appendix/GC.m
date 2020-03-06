%% loop over m, a, delta, calculate upper and lower bounds according to proposition 7, and check whether the lower bound is indeed lower:
results=zeros(30000,7);
row_count=1;
%cum_gap_vec=[];

n_a=13;

for a=0:0.001:0.999
    for delta=0.001:0.001:1-a
        if a+delta>=1
            continue
        end

        %to track progress through the command line:
        di=['a=' num2str(a),', delta=', num2str(delta)];  
        disp(di);

        %k_hat:
        x=2:n_a;
        khm=(x-1).*(a+delta.^(x-1));
        k_hat=max(khm);
        if k_hat<2
            k_hat=2;
        end
        %ub:
        ub=(n_a-1)*(a+delta^(n_a-1));
        %lb:
        k=2:min([n_a-1,k_hat]);
        lb_vec=(k-1).*((a+delta.^(k-1))-(a+delta^(n_a-1)));
        lb=max(lb_vec);

        %compare upper and lower bounds:
        if ub<lb
            stability_range=0;
        elseif ub==lb
            stability_range=1;
        else %ub>lb
            stability_range=2;
        end

        %store result:
        results(row_count,1)=a;
        results(row_count,2)=delta;
        results(row_count,3)=stability_range;            
        results(row_count,4)=lb;
        results(row_count,5)=ub; 

        row_count=row_count+1;
    end
end 

%delete unnecessary rows in the results matrix:
results=results(results(:,1)~=0,:);
%save workspace:
filename=datestr(now,30);
save(filename)

%% plot results and save graph:
scatter(results(results(:,3)==2,1),results(results(:,3)==2,2),'.','b');
hold on
scatter(results(results(:,3)==0,1),results(results(:,3)==0,2),'.','r');
hold on
scatter(results(results(:,3)==1,1),results(results(:,3)==1,2),'.','g');
title('GC')
xlabel('a')
ylabel('delta') 
saveas(gcf,'GC.png')