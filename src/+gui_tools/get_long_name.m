function lname= get_long_name(code, oid)
global model_settings;
lname = code;

if(strcmp(oid,'var'))
    data = model_settings.variables; 
elseif(strcmp(oid,'shock'))
    data = model_settings.shocks; 
else
    return;
end
    
num = size(data,1);
c = 2;
c_long_name = 4;
 
 for ii=1:num
    if strcmp(deblank(code), deblank(data{ii,c}))
        lname = data{ii,c_long_name};
        return;
    end
     
 end
 
 end
