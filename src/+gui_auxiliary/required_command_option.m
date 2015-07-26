function s = required_command_option( used, flag, option, value_if_selected, value_if_not_selected, description)
 s = struct();
 s = setfield(s, 'used', used);
 s = setfield(s, 'flag', flag);
 s = setfield(s, 'option', option);
 s = setfield(s, 'value_if_selected', value_if_selected);
 s = setfield(s, 'value_if_not_selected', value_if_not_selected);
 s = setfield(s, 'description', description);


end

