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
	
  M = dlmread(strcat(char(buchstaben(i)), '_marcus.txt'),'\t');
  f=M(:,1);
  f = f.';
  mag=M(:,2);
  mag = mag.';
  p_mag = mag/max(abs(mag));
  figure;
  plot(f,p_mag);
	fig_title = strcat('Formanten f\"ur den Vokal \enquote{', char(buchstaben(i)), '}');
	title(fig_title);
	xlim([0 15]*10^3);
	%ylim([-1 0.01]);
	xlabel('Frequenz in Hz')
	ylabel('Amplitudenspektrum')
  %matlab2tikz(strcat('spektrum-',buchstabe(i),'-3.tex'),'height','.5\textwidth');
end
