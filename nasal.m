%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   			 Nasallaute								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=nasal(buchstaben,DUR,fs)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'m';'n'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz

Ts=1/fs;
f0=150;	% Grundschwingung, Tonhoehe

x=sourcesignal('nasal',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%		Filter(nur mit Tiefpassfilter)	 %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
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
%}

for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'm'
			f1 = 500;
			f2 = 1506;
			f3 = 2543;
			B1 = 40;
			B2 = 70;
			B3 = 70;
		case 'n'
			f1 = 390;
			f2 = 1608;
			f3 = 2454;
			B1 = 40;
			B2 = 67;
			B3 = 70;
	end
	
	[b a] = butter(1,[400/(0.5*fs),500/(0.5*fs)],'stop');
	y = filter(b,a,x);		%Anti-Formantfilter "RNZ-FNZ"
	
	y = formantfilter(y,Ts,250,20);		%Zusaetzlicher Formantfilter "RNP-FNP"
	y=formantfilter(y,Ts,f1,B1);	%1. Formantfilter
	y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter
	y=formantfilter(y,Ts,f3,B3);	%3. Formantfilter
	
	[b a] = butter(1,[500/(0.5*fs),1500/(0.5*fs)],'stop');
	y = filter(b,a,y);
	[b a] = butter(1,[1500/(0.5*fs),2500/(0.5*fs)],'stop');
	y = filter(b,a,y);


	wavwrite(y'/max(y),fs,strcat('nasal-',char(buchstabe),'.wav'));
end