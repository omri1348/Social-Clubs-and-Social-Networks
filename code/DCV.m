function dcv =  DCV(nMembers, congestionFunc)
% the function calculate the Direct Club
% Value
% dcv - the club direct Club Value.
dcv = (nMembers-1)*(congestionFunc(nMembers));
end