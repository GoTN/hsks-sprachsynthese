%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% Erzeugung eines Vibranten mittels einfacher Formantfilterung %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y , f , B]=vibrant(buchstaben,DUR,fs,syn)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'r'}			;end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
%if (nargin<=3) B=[100 160]; end %bandwidth
if (nargin<=3) syn=1;	end %%soll synthetisieren?
	
Ts=1/fs;
%B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
%B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe
f1=f2=f3=f4=0;%damit die in FKT definiert sind...
B1=B2=B3=B4=0;%damit die in FKT definiert sind...
x=sourcesignal('vibrant',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'r'
			f1=460;
			f2=1113;
			f3=2408;	
			B1=100;
			B2=190;
			B3=550;
	end
	if(syn == 1)
		y=formantfilter(x,Ts,f1,B1);	%1. Formantfilter
		y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter
		y=formantfilter(y,Ts,f3,B3);	%3. Formantfilter
		%y=formantfilter(y,Ts,f4,B4);	%4. Formantfilter
		[b,a] = butter(1, 1000/fs, 'low');
		y=filter(b,a,y);

	else 
		y=x;
	end
	wavwrite(y'/max(y),fs,strcat('vibrant-',char(buchstabe),'.wav'));
end
