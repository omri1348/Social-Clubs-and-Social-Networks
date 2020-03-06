function X = gen_mstar(m,number_of_agents)
num_of_clubs=(number_of_agents-1)/(m-1);
assert(num_of_clubs==round(num_of_clubs),'The m-Star environment does not exist for the values specified')
membMap=NaN(number_of_agents,num_of_clubs);   %prealocation
%create a vector of the powers of 2:
p2_vec=2.^(0:number_of_agents-2);
%sum each m-1 consecutive elements in the p2_vec vector:
temp=reshape(p2_vec,m-1,[]);
s_p2_vec=sum(temp,1);
dec_vec_prep=2^(number_of_agents-1)+s_p2_vec;
columnsCounter=1;
for j=1:size(dec_vec_prep,2)
    dec=dec_vec_prep(j);
    binStr=dec2bin(dec,number_of_agents);
    binLog=logical(binStr-'0');
    membMap(:,columnsCounter)=binLog';
    columnsCounter=columnsCounter+1;            
end
X=membMap;


% function X = gen_mstar(m,number_of_agents)
% num_of_clubs=(number_of_agents-1)/(m-1);
% membMap=NaN(number_of_agents,num_of_clubs);   %prealocation
% dec_vec_prep=[2^(number_of_agents-1)+2.^(0:number_of_agents-2)];
% columnsCounter=1;
% for j=1:size(dec_vec_prep,2)
%     dec=dec_vec_prep(j);
%     binStr=dec2bin(dec,number_of_agents);
%     binLog=logical(binStr-'0');
%     membMap(:,columnsCounter)=binLog';
%     columnsCounter=columnsCounter+1;            
% end
% X=membMap;