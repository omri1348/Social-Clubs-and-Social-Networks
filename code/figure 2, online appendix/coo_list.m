%% create coordinate lists for the latex code to produce the m-Star figure:

syms delta

n_a=13;

for m=2 %[2,3,4,5,7]
    gamma=(n_a-1)/(m-1);
    for k=12 %2:n_a
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for a=0:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', a=' num2str(a)];  
                disp(di);
                if gamma>=m
                    if k>=2 && k<=m
                        sol_delta=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),delta>0,delta<1,'Real',true); 
                    else %k>m
                        sol_delta=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),delta>0,delta<1,'Real',true); 
                    end
                else %gamma<m
                    if k>=2 && k<=gamma
                        
                    elseif k>gamma && k<=m
                        
                    else %k>m && k<n_a
                        
                    end  
                end
                if isempty(sol_delta)
                    continue
                else                    
                    sol_delta_num=double(sol_delta); 
                    num_of_sol=size(sol_delta,1);
                    for i=1:num_of_sol
                        coo_mat(row_counter,1)=a;
                        coo_mat(row_counter,2)=sol_delta_num(i,1);                            
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
        filename=['m=',num2str(m),', k=' num2str(k),'.dat'];
        dlmwrite(filename,coo_mat_ord,'\t')
    end
end

%% m=3, k=2
syms delta
n_a=13;
for m=3 
    gamma=(n_a-1)/(m-1);
    for k=2 
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for a=0:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', a=' num2str(a)];  
                disp(di);
                if gamma>=m
                    if k>=2 && k<=m
                        sol_delta=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),delta>0,delta<1,'Real',true); 
                    else %k>m
                        sol_delta=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),delta>0,delta<1,'Real',true); 
                    end
                else %gamma<m
                    if k>=2 && k<=gamma
                        
                    elseif k>gamma && k<=m
                        
                    else %k>m && k<n_a
                        
                    end  
                end
                if isempty(sol_delta)
                    continue
                else                    
                    sol_delta_num=double(sol_delta); 
                    num_of_sol=size(sol_delta,1);
                    for i=1:num_of_sol
                        coo_mat(row_counter,1)=a;
                        coo_mat(row_counter,2)=sol_delta_num(i,1);                            
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.3626,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)<0.3626,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=3, k=12
syms delta
n_a=13;
for m=3 
    gamma=(n_a-1)/(m-1);
    for k=12 
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for a=0:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', a=' num2str(a)];  
                disp(di);
                if gamma>=m
                    if k>=2 && k<=m
                        sol_delta=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),delta>0,delta<1,'Real',true); 
                    else %k>m
                        sol_delta=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),delta>0,delta<1,'Real',true); 
                    end
                else %gamma<m
                    if k>=2 && k<=gamma
                        
                    elseif k>gamma && k<=m
                        
                    else %k>m && k<n_a
                        
                    end  
                end
                if isempty(sol_delta)
                    continue
                else                    
                    sol_delta_num=double(sol_delta); 
                    num_of_sol=size(sol_delta,1);
                    for i=1:num_of_sol
                        coo_mat(row_counter,1)=a;
                        coo_mat(row_counter,2)=sol_delta_num(i,1);                            
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,1)>=0.0996,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,1)<0.0996,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=4, k=2
syms a
n_a=13;
for m=4 
    gamma=(n_a-1)/(m-1);
    for k=2 
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                if gamma>=m
                    if k>=2 && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    else %k>m
                        
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)<=0.5 & coo_mat_ord(:,2)>=0.4688,:);
        coo_mat_ord_n1=coo_mat_ord(coo_mat_ord(:,2)>0.5,:);
        coo_mat_ord_n2=coo_mat_ord(coo_mat_ord(:,2)<0.4688,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n1.dat'];
        dlmwrite(filename,coo_mat_ord_n1,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n2.dat'];
        dlmwrite(filename,coo_mat_ord_n2,'\t')
    end
end
%% m=4, k=3
syms a
n_a=13;
for m=4 
    gamma=(n_a-1)/(m-1);
    for k=3 
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                if gamma>=m
                    if k>=2 && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    else %k>m
                        
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.5,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)<0.5,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end

%% m=4, k=12
syms a
n_a=13;
for m=4 
    gamma=(n_a-1)/(m-1);
    for k=12 
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
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
%% m=5, k=3
syms a
n_a=13;
for m=5
    gamma=(n_a-1)/(m-1);
    for k=3
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
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
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    elseif k>gamma && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*(a+delta.^(k-1))-(ceil(k./gamma)-1).*(a+delta^(m-1))+(n_a-m-(k-ceil(k./gamma))).*(a+delta^(m-1)).*(a+delta.^(k-1))-(n_a-m)*(a+delta^(m-1))^2,a>0,a+delta>0,a+delta<1,'Real',true);                         
                    else %k>m && k<n_a
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),a>0,a+delta>0,a+delta<1,'Real',true); 
                    %joinning is never bounding (at least when n_a=12), so the condition is not
                    %specified here.
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.5004,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)<0.5004,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=5, k=12
syms a
n_a=13;
for m=5
    gamma=(n_a-1)/(m-1);
    for k=12
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.0005:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
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
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    elseif k>gamma && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*(a+delta.^(k-1))-(ceil(k./gamma)-1).*(a+delta^(m-1))+(n_a-m-(k-ceil(k./gamma))).*(a+delta^(m-1)).*(a+delta.^(k-1))-(n_a-m)*(a+delta^(m-1))^2,a>0,a+delta>0,a+delta<1,'Real',true);                         
                    else %k>m && k<n_a
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),a>0,a+delta>0,a+delta<1,'Real',true); 
                    %joinning is never bounding (at least when n_a=12), so the condition is not
                    %specified here.
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,1)>=0.2041,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,1)<0.2041,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=7, k=2
syms a
n_a=13;
for m=7
    gamma=(n_a-1)/(m-1);
    for k=2
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
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
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    elseif k>gamma && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*(a+delta.^(k-1))-(ceil(k./gamma)-1).*(a+delta^(m-1))+(n_a-m-(k-ceil(k./gamma))).*(a+delta^(m-1)).*(a+delta.^(k-1))-(n_a-m)*(a+delta^(m-1))^2,a>0,a+delta>0,a+delta<1,'Real',true);                         
                    else %k>m && k<n_a
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),a>0,a+delta>0,a+delta<1,'Real',true); 
                    %joinning is never bounding (at least when n_a=12), so the condition is not
                    %specified here.
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)<=0.7686,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)>0.7686,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=7, k=3
syms a
n_a=13;
for m=7
    gamma=(n_a-1)/(m-1);
    for k=3
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
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
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*((a+delta.^(k-1))+(m-2).*(a+delta.^(k-1)).*(a+delta.^(m-1))-(m-1)*((a+delta.^(m-1))^2)),a>0,a+delta>0,a+delta<1,'Real',true); 
                    elseif k>gamma && k<=m
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-1).*(a+delta.^(k-1))-(ceil(k./gamma)-1).*(a+delta^(m-1))+(n_a-m-(k-ceil(k./gamma))).*(a+delta^(m-1)).*(a+delta.^(k-1))-(n_a-m)*(a+delta^(m-1))^2,a>0,a+delta>0,a+delta<1,'Real',true);                         
                    else %k>m && k<n_a
                        sol_a=solve((m-1)*(a+delta^(m-1))==(k-ceil(k./gamma)).*((a+delta.^(k-1))-(a+delta.^(m-1))^2),a>0,a+delta>0,a+delta<1,'Real',true); 
                    %joinning is never bounding (at least when n_a=12), so the condition is not
                    %specified here.
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.7686,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)<0.7686,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=8, k=2
syms a
n_a=13;
for m=8
    for k=2
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                sol_a=solve((n_a-1)*(a+delta^(n_a-1))==(k-1).*((a+delta.^(k-1))-(a+delta^(n_a-1))),a>0,a+delta>0,a+delta<1,'Real',true);
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)<=0.5002,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)>0.5002,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end
%% m=8, k=3
syms a
n_a=13;
for m=8
    for k=3
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                sol_a=solve((n_a-1)*(a+delta^(n_a-1))==(k-1).*((a+delta.^(k-1))-(a+delta^(n_a-1))),a>0,a+delta>0,a+delta<1,'Real',true);
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.5002 & coo_mat_ord(:,2)<=0.673,:);
        coo_mat_ord_n1=coo_mat_ord(coo_mat_ord(:,2)<0.5002,:);
        coo_mat_ord_n2=coo_mat_ord(coo_mat_ord(:,2)>0.673,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n1.dat'];
        dlmwrite(filename,coo_mat_ord_n1,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n2.dat'];
        dlmwrite(filename,coo_mat_ord_n2,'\t')
    end
end
%% m=8, k=4
syms a
n_a=13;
for m=8
    for k=4
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                sol_a=solve((n_a-1)*(a+delta^(n_a-1))==(k-1).*((a+delta.^(k-1))-(a+delta^(n_a-1))),a>0,a+delta>0,a+delta<1,'Real',true);
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.673 & coo_mat_ord(:,2)<=0.7753,:);
        coo_mat_ord_n1=coo_mat_ord(coo_mat_ord(:,2)<0.673,:);
        coo_mat_ord_n2=coo_mat_ord(coo_mat_ord(:,2)>0.7753,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n1.dat'];
        dlmwrite(filename,coo_mat_ord_n1,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n2.dat'];
        dlmwrite(filename,coo_mat_ord_n2,'\t')
    end
end
%% m=8, k=5
syms a
n_a=13;
for m=8
    for k=5
        clear coo_mat
        clear coo_mat_ord
        row_counter=1;
            for delta=0.001:0.001:0.999 %[0,0.0001,0.01:0.01:0.79,0.79:0.001:0.82]  
                %to track progress through the command line:
                di=['m=',num2str(m),', k=' num2str(k),', delta=' num2str(delta)];  
                disp(di);
                sol_a=solve((n_a-1)*(a+delta^(n_a-1))==(k-1).*((a+delta.^(k-1))-(a+delta^(n_a-1))),a>0,a+delta>0,a+delta<1,'Real',true);
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
        coo_mat_ord_b=coo_mat_ord(coo_mat_ord(:,2)>=0.7753,:);
        coo_mat_ord_n=coo_mat_ord(coo_mat_ord(:,2)<0.7753,:);
        %export tables:
        filename=['m=',num2str(m),', k=' num2str(k),', b.dat'];
        dlmwrite(filename,coo_mat_ord_b,'\t')
        filename=['m=',num2str(m),', k=' num2str(k),', n.dat'];
        dlmwrite(filename,coo_mat_ord_n,'\t')
    end
end