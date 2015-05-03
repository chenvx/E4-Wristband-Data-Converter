% This function converts E4 wristband csv files into a Q eda file
%
% Inputs
%   
%   filename    - Output filename
%
% Outputs
%   None

% Vincent Chen, 2/20/2015

function Qwrite(filename)

%% initial checks on the inputs
if ~ischar(filename)
    error('FILENAME must be a string');
end

%% read E4 files
EDA=dlmread('EDA.csv');
ACC=dlmread('ACC.csv');
TEMP=dlmread('TEMP.csv');

%% write the header string to the file

%turn the headers into a single comma seperated string if it is a cell
%array, 
header1 = 'File Exported by Q - (c) 2009 Affectiva Inc.';
header2 = 'File Version: 1.01';
header3 = 'Firmware Version: 1.12';
header4 = 'UUID: AFQ1610003x';
header5 = 'Sampling Rate: 4';
initialT = datestr(EDA(1)/24/3600+datenum(1970,1,1,-5,0,0),31);
header6 = ['Start Time: ' initialT ' Offset:-05'];
header7 = 'Z-axis,Y-axis,X-axis,Battery,?Celsius,EDA(uS)';
header8 = '---------------------------------------------------------';

%write the string to a file
fid = fopen(filename,'w');
fprintf(fid,'%s\r\n',header1);
fprintf(fid,'%s\r\n',header2);
fprintf(fid,'%s\r\n',header3);
fprintf(fid,'%s\r\n',header4);
fprintf(fid,'%s\r\n',header5);
fprintf(fid,'%s\r\n',header6);
fprintf(fid,'%s\r\n',header7);
fprintf(fid,'%s\r\n',header8);
fclose(fid);

%% reorganize the data
x = decimate(ACC(3:end,1),8)/64;
y = decimate(ACC(3:end,2),8)/64;
z = decimate(ACC(3:end,3),8)/64;
e = EDA(3:end);
t = TEMP(3:end);
t(t>50)=mean(t(t<50));
lastp = min([length(x) length(y) length(z) length(e) length(t)]);
m = [x(1:lastp) y(1:lastp) z(1:lastp) -ones(lastp,1) t(1:lastp) e(1:lastp)];

%% write the append the data to the file

%
% Call dlmwrite with a comma as the delimiter
%
dlmwrite(filename, m,'-append','delimiter',',');
