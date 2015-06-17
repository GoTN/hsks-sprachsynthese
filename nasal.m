%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   			 Nasallaute								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=nasal(buchstaben,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'m';'n'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth

Ts=1/fs;
B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe

x=sourcesignal('nasal',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%		Filter(nur mit Tiefpassfilter)	 %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'm'
			fg=200; %Grenzfrequenz
		case 'n'
			fg=300;
	end
	
	[b a] = butter(3,200/(0.5*fs),'high');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter(f0 = 800HZ)
	y = filter(b,a,x);
	
	[b a] = butter(3,fg/(.5*fs),'low');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter
	y = filter(b,a,x);
	
%{
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'm'
			f1 = 480;
			f2 = 1270;
			f3 = 2130;
			B1 = 40;
			B2 = 200;
			B3 = 200;
		case 'n'
			f1 = 480;
			f2 = 1340;
			f3 = 2470;
			B1 = 40;
			B2 = 300;
			B3 = 300;
	end
	
	[b a] = butter(2,[440/(0.5*fs),460/(0.5*fs)],'stop');
	y = filter(b,a,x);		%Anti-Formantfilter "RNZ-FNZ"
	
	y = formantfilter(y,Ts,270,20);		%Zusaetzlicher Formantfilter "RNP-FNP"
	y=formantfilter(y,Ts,f1,B1);	%1. Formantfilter
	y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter
	y=formantfilter(y,Ts,f3,B3);	%3. Formantfilter
%}

	wavwrite(y'/max(y),fs,strcat('nasal-',char(buchstabe),'.wav'));
end