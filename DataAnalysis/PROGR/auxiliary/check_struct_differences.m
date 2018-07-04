function check_struct_differences(struct1,struct2)

fields1=fieldnames(struct1);
fields2=fieldnames(struct2);

% looks for the elements of struct1 also present in struct2
commonfields=fields1(ismember(fields1,fields2));
for ii=1:numel(commonfields)
    if iscell(struct2.(commonfields{ii}))||iscell(struct1.(commonfields{ii}))
        % checks if cells arrays are equal. 
        cc=1;
        for i=1:length(struct2.(commonfields{ii}))
            if struct2.(commonfields{ii}){cc}~=struct2.(commonfields{ii}){cc}
                warning(['Difference in field ' commonfields{ii}]);
                break;
            end
        end
        
    else % otherwise
        if any(struct2.(commonfields{ii})~=struct1.(commonfields{ii}))
            warning(['Difference in field ' commonfields{ii}]);
        end
    end
end
