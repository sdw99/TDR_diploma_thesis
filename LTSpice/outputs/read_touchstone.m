function [sp] = read_touchstone(fname, mode);
%  [sp] = read_touchstone(fname);
%
if nargin < 2, mode = 'magph'; end

fid = fopen (fname, 'rt');
sp.freq = [];

if strcmpi(mode,'complex')
   sp.s11 = [];
   sp.s21 = [];
   sp.s12 = [];
   sp.s22 = [];
   sp.time=[];
   sp.voltage1=[];
   sp.voltage2=[];
else
   sp.s11.mag = [];
   sp.s21.mag = [];
   sp.s12.mag = [];
   sp.s22.mag = [];   
   sp.s11.ph = [];
   sp.s21.ph = [];
   sp.s12.ph = [];
   sp.s22.ph = [];
   sp.time=[];
   sp.voltage1=[];
   sp.voltage2=[];
end

while ( ~feof(fid) )
   str = fgets (fid);
   if ((str(1) == '!')||(str(1) == '#')||(str(1) == 'F')||(str(1) == 't'))
      continue;
   end
   [val, len]= sscanf (str, '%f %1s %f %3s %f %2s');
   % Ignore lines with less than 9 elements
   if (len == 6)
     sp.freq = [sp.freq; val(1)];

     if strcmpi(mode,'complex')
        sp.s11 = [sp.s11; ( val(3) .* exp(i*val(7)) ) ];
        %sp.s21 = [sp.s21; ( val(4) .* exp(i*val(5)) ) ];
        %sp.s12 = [sp.s12; ( val(6) .* exp(i*val(7)) ) ];
        %sp.s22 = [sp.s22; ( val(8) .* exp(i*val(9)) ) ];
      else % mode == 'magph'
        sp.s11.mag = [sp.s11.mag; val(3)];
        sp.s11.ph = [sp.s11.ph; val(7)];
        %sp.s21.mag = [sp.s21.mag; val(4)];
        %sp.s21.ph = [sp.s21.ph; val(5)];
        %sp.s12.mag = [sp.s12.mag; val(6)];
        %sp.s12.ph = [sp.s12.ph; val(7)];
        %sp.s22.mag = [sp.s22.mag; val(8)];
        %sp.s22.ph = [sp.s22.ph; val(9)];
      end
   end
   
   [val, len]= sscanf (str, '%f %f %f');
   
   if(len==2)
      sp.time=val(1);
      sp.voltage1=[sp.voltage1 val(2)];
   end
   
   if(len==3)
      sp.time=val(1);
      sp.voltage1=[sp.voltage1 val(2)];
      sp.voltage2=[sp.voltage2 val(3)];
   end
end

fclose(fid); 