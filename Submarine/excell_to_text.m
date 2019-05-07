
fname = 'C:\STEM\git\Submarine\PodmornicaLast.xlsx';
% fname = 'C:\Users\Ante\Dropbox\STEM Games\2019\git\Submarine\PodmornicaLast.xlsx';

cell_range = ["D3:D5", "D8:D13", "D18:D19", "D16:D17",    ...
              "D29:D31", "D34:D37","D21:D26",                                 ...
              "D40:D43", "F39:F40", "F46:F47", "H50:H51", "E50:E65"];

            
xlObj = actxserver('Excel.Application');%Start Excel
xlObj.Visible = 0;%Make Excel visible
wsObj = xlObj.Workbooks.Open(fname);%Open workbook
Sheet = wsObj.Sheets.Item(1);%Assume we're using the first sheet
% A3_value = Sheet.Range(cell_range).Value
fid = fopen('excell_formulas.txt', 'a+');


for k = 1:length(cell_range)
    

    range = Sheet.Range(char(cell_range(k))).Formula;


    fprintf(fid, '\n\n');

    for i = 1:length(range)

        [a, b, c, d] = range_to_num(char(cell_range(k)));

        strRan = num_to_cell(a, b+i-1);
        strFor = cell2mat(range(i));

        if isempty(strFor)
            continue
        end

        if strFor(1) == '='
            strFor = strFor(2:end);
        end
        fprintf(fid, '%s = %s;\n', strRan, strFor);
    end

end

fclose(fid);
Quit(xlObj)
delete(xlObj)





