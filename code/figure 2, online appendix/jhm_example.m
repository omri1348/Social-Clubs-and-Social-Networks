%% loop over m, a, delta, calculate upper and lower bounds according to proposition 7, and check whether the lower bound is indeed lower:
results=zeros(30000,7);
row_count=1;

n_a=13;

for m=7
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
                if lb==J_h && J_h~=max_FNS_h && J_h~=max_FNI_h && J_h~=max_FNL_h
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
            end
            
            %store result:
            results(row_count,1)=m;
            results(row_count,2)=a;
            results(row_count,3)=delta;            
            results(row_count,4)=stability_range;
            results(row_count,5)=J_h; 
            results(row_count,6)=max_FNS_h;
            results(row_count,7)=max_FNI_h;
            results(row_count,8)=max_FNL_h;
            results(row_count,9)=cond;
                 
            row_count=row_count+1;
        end
    end
end 
%delete unnecessary rows in the results matrix:
results=results(results(:,1)~=0,:);
%save examples where J_h(m) is maximal:
examples=results(results(:,5)>results(:,6) & results(:,5)>results(:,7) & results(:,5)>results(:,8),:);

%% loop over m, a, delta, calculate upper and lower bounds according to proposition 7, and check whether the lower bound is indeed lower:
results=zeros(30000,7);
row_count=1;

n_a=5;

for m=3
    gamma=(n_a-1)/(m-1);
    assert(gamma==round(gamma),'The m-Star environment does not exist for the values specified')
    cum_gap=0;
    for a=0:0.001:0.999
        for delta=0.001:0.001:1-a
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
                if lb==J_h && J_h~=max_FNS_h && J_h~=max_FNI_h && J_h~=max_FNL_h
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
            end
            
            %store result:
            results(row_count,1)=m;
            results(row_count,2)=a;
            results(row_count,3)=delta;            
            results(row_count,4)=stability_range;
            results(row_count,5)=J_h; 
            results(row_count,6)=max_FNS_h;
            results(row_count,7)=max_FNI_h;
            results(row_count,8)=max_FNL_h;
            results(row_count,9)=cond;
                 
            row_count=row_count+1;
        end
    end
end 
%delete unnecessary rows in the results matrix:
results=results(results(:,1)~=0,:);
%save examples where J_h(m) is maximal:
examples=results(results(:,5)>results(:,6) & results(:,5)>results(:,7) & results(:,5)>results(:,8),:);