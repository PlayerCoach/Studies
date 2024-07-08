%zadanie 9

options = optimset('Display', 'iter');
display('fzero(@tan, 6, options);');
fzero(@tan, 6, options);
display('fzero(@tan, 4.5, options);');
fzero(@tan, 4.5, options);