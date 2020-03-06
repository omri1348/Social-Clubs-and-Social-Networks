%% preparations:
addpath('C:\Users\User\Dropbox\Chaim\Final\Code\New\Code\Code 1.4')
results=zeros(15000,4);

%% constant parameters:
club_congestion_function='exponential'; %may be 'exponential','inv','none','zeros','ones','constant','fix',''.
individual_congestion_function='none';   %may be 'exponential','inv','none','zeros','ones','constant'.
weight_of_link_function='max'; %may be 'max','min','mean','sum','prod'.
weight_of_path_function='prod';  %may only be 'prod'
max_path_length='inf';  %may be any number between 1 and 'inf'.
fix_vector=[];

number_of_clubs='';
input_file_name='';
CSR_sheets='';

processing_type='current setup report'; %may be 'current setup report','exhaustive scan','genetic scan'.
max_number_of_generation='';
target_folder='';

number_of_agents=13;
%% loop over m, a, delta and c, and search for at least one value of c for which the environment is stable:
row_count=1;
for m=[2,3,4,5,7]
    %create the 2-star environment:
    membMap=gen_mstar(m,number_of_agents);
    for club_congestion_a=0:0.02:0.99
        for club_congestion_delta=0.01:0.02:1-club_congestion_a
            %to track progress through the command line:
            di=['m=' ,num2str(m),', a=' num2str(club_congestion_a),', delta=', num2str(club_congestion_delta)];  
            disp(di);
            khm=(m-1)*(club_congestion_a+club_congestion_delta^(m-1));
            for club_membership_cost=0:0.04:khm
                
                %to track progress through the command line:
                di=['c=' ,num2str(club_membership_cost)];
                disp(di);
                
                stable_range=0;
    
                % insert parameters into "config":
                Model=struct('club_membership_cost',club_membership_cost,'club_congestion_function'...
                    ,club_congestion_function,'club_congestion_delta',club_congestion_delta...
                    ,'club_congestion_a',club_congestion_a,'individual_congestion_function',individual_congestion_function...
                    ,'weight_of_link_function',weight_of_link_function,'weight_of_path_function',weight_of_path_function...
                    ,'fix_vector',fix_vector,'max_path_length',max_path_length);
                Envieonment=struct('number_of_agents',number_of_agents,'number_of_clubs',number_of_clubs...
                    ,'input_file_name',input_file_name,'CSR_sheets',CSR_sheets);
                Processing=struct('processing_type',processing_type...
                    ,'max_number_of_generation',max_number_of_generation...
                    ,'target_folder',target_folder);
                config=struct('Model',Model,'Envieonment',Envieonment,'Processing',Processing);
    
                %submit to CSR:
                stabilityOmri=AnalyzeConfig(config,membMap);
                
                %if the membership fees result in stability - exit current loop and 
                %store the result:
                if stabilityOmri==1
                    stable_range=1;
                    break
                else
                    %just move to the next c and keep searching
                end
            end
            %store result:
            results(row_count,1)=m;
            results(row_count,2)=club_congestion_a;
            results(row_count,3)=club_congestion_delta;            
            results(row_count,4)=stable_range;
            row_count=row_count+1;
        end
    end
    %save workspace (after each m):
    filename=datestr(now,30);
    save(filename)
end

%save workspace (after all m's are completed):
filename=datestr(now,30);
save(filename)