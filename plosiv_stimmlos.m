%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 							Erzeugung eines Plosiv						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=plosiv_stimmlos(lautliste,DUR,fs)

%%%%%			PARAMETER			%%%%%
if (nargin==0) lautliste={'de';'da';'do';'di'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
		
	bl=0.15;		%%Burst length
	peri_num = 1;	%% anzahl Perioden 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synthese des Bursts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;	%index zum Iterieren über Buchstabeneingabe
fac=1;	%Amplitudenskalierungsfaktor
while i<=numel(lautliste)
	laut=lautliste(i);
	i=i+1;
	switch laut	%Lautstärke und Periodenanzahl für passenden Plosiv wählen
		case 't'			
			peri_num = 0.5;
			fac = 0.7;
		case 'p'	
			peri_num = 3;
			fac = 0.1;
		case 'k'
			peri_num = 2;
			fac = 0.5;
	end
	% Fensterung des Spektrums im Zeitbereich
	time = linspace(0, 2*pi, fs*bl);	
	cosi = cos(time*peri_num)+2;	%aus Tschechnerbriefen nachempfundene Funktion
	burs = burst(laut,bl,fs);	%passenden Burst erzeugen
	burs = burs/(2*max(burs(1:bl*fs)));	%Normierung auf 0.5
	burs = burs.*cosi;			%Fensterung
	y=burs/(max(burs))*fac;
	%wavwrite(y,fs,strcat('plosiv-stimmlos-',lautliste,'.wav'));
end
