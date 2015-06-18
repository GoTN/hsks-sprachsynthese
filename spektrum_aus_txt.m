fs=44100;
Ts=1/fs;
f0=125;	% Grundschwingung, Tonhoehe
DUR=2;
samples=ceil(DUR*fs);

mint=.06;
maxt=.09;

maxf=3500;
buchstaben={'a','e','i','o','u','ae','oe','ue'};

for i=1:numel(buchstaben)
	
	M = dlmread(strcat(char(buchstaben(i), '_Marcus.txt'),'\t')
	f=M(:,1);
	f = f.';
	mag=(M,2);
	mag = mag.';
	figure;
	plot(f,mag);
	xlabel('Frequenz f/Hz');
	ylabel(strcat('|',toupper(buchstabe),'(f)| in dB'));
	matlab2tikz(strcat('spektrum-',buchstabe,'-3.tex'),'height','.5\textwidth');
end
