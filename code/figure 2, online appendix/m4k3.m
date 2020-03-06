%% m=4, k=12
syms a
n_a=13;
for m=4 
    gamma=(n_a-1)/(m-1);
    for k=12 
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.01:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                if gamma>=m
                    if k>=2 && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    else %k>m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),a>0,a+delta>0,a+delta<1,'Real',true); 
                    end
                else %gamma<m
                    if k>=2 && k<=gamma
                        
                    elseif k>gamma && k<=m
                        
                    else %k>m && k<n_a
                        
                    end  
                end
                if isempty(sol_a)
                    continue
                else                    
                    sol_a_num=double(sol_a); 
                    num_of_sol=size(sol_a,1);
                    for i=1:num_of_sol
                        coo_mat(row_counter,1)=sol_a_num(i,1);
                        coo_mat(row_counter,2)=delta;                            
                        row_counter=row_counter+1;
                    end
                end 
            end
        %sort coo_mat:        
        dist = pdist2(coo_mat,coo_mat);
        N = size(coo_mat,1);
        order = NaN(1,N);
        order(1) = 1; % first point is first row in data matrix
        coo_mat_ord(1,:)=coo_mat(1,:);
        for ii=2:N
            dist(:,order(ii-1)) = Inf;
            [~, closest_idx] = min(dist(order(ii-1),:));
            order(ii) = closest_idx;
            coo_mat_ord(ii,:)=coo_mat(order(ii),:);
        end
        %break into bounding and non-bounding parts:
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,1)>=0.1391,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,1)<0.1391,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end