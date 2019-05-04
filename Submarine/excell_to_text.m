
fname = 'C:\Users\Ante\Dropbox\STEM Games\2019\git\Submarine\PodmornicaLast.xlsx';
cell_range = 'D3:D43';



xlObj = actxserver('Excel.Application');%Start Excel
xlObj.Visible = 0;%Make Excel visible
wsObj = xlObj.Workbooks.Open(fname);%Open workbook
Sheet = wsObj.Sheets.Item(1);%Assume we're using the first sheet
% A3_value = Sheet.Range(cell_range).Value
A3_formula = Sheet.Range(cell_range).Formula

Quit(xlObj)
delete(xlObj)