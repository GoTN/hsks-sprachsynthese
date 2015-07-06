%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 				Erzeugung einer Plosiv/Vokal-Lautkombination 			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=plosiv(lautliste,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) lautliste={'de';'da';'do';'di'};end%lautliste
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth	
	Ts=1/fs;
	B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
	B2=B(2);	%Filterbandbreite Formant 2
	
	x=sourcesignal('plosiv',DUR,fs); %Vokalanregugssignal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Übergangszeiten festlegen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
if(lautliste(1)=='b')
	U = 0.005*fs;  	%%empirisch ermittelt
	O = 0.01*fs;	%%ein Drittel der Zeit wird offset	
elseif(lautliste(1)=='g')
	U = 0.030*fs;  	%%empirisch ermittelt
	O = 0.001*fs;	%%ein Drittel der Zeit wird offset	
else
	U = 0.012*fs;  	%%empirisch ermittelt
	O = 0.005*fs;	%%ein Drittel der Zeit wird offset	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Anfangs- und Endwerte für Plosiv festlegen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
while i<=numel(lautliste)
	if(length(lautliste)-i>0)	%%nur wenn lang genug
		doppellaut = lautliste(i:i+1);	%%Doppellaut
	else	
		doppellaut = [0, 0];	%%dann kein Doppellaut	
	end
	i=i+2;					%%erstmal um zwei erhöhen, wir gehen von einem Diphthong aus.
	f=B=0;					%%Bandbreite Vektor, Angaben immer in Hz
	switch char(doppellaut(2))	%zweite Buchstabe, d.h. hier Vokal, analysieren
		case 'a'
			[y , f , B]=stimmhaft({'a'},DUR,fs,0);
		case 'e'
			[y , f , B]=stimmhaft({'e'},DUR,fs,0);
		case 'i'
			[y , f , B]=stimmhaft({'i'},DUR,fs,0);
		case 'o'
			[y , f , B]=stimmhaft({'o'},DUR,fs,0);
		case 'u'
			[y , f , B]=stimmhaft({'u'},DUR,fs,0);
		%case 'ae'
		%	[y , f , B]=stimmhaft({'ae'},DUR,fs,0);
		%case 'oe'
		%	[y , f , B]=stimmhaft({'oe'},DUR,fs,0);
		%case 'ue'
		%	[y , f , B]=stimmhaft({'ue'},DUR,fs,0);	
	end
			f1=f(1);
			f2=f(2);
			f3=f(3);
			B1=B(1);
			B2=B(2);
			B3=B(3);
	switch doppellaut
		case 'da'			%%Werte aus Analyse bestimmt, bzw. wenn unmöglich/ schwer möglich geschätzt, dann mit !!! gekennzeichnet
			f11=470;		
			f21=1850;		
			f31=2680;		
		case 'de'			
			f11=320;		%%!!!
			f21=1900;		%%200Hz Differenz
			f31=2700;
		case 'di'	
			f11=120;		%%!!!
			f21=1750;		
			f31=2500;		
		case 'do'
			f11=250;		%%!!!
			f21=1400;		
			f31=2600;		%%2700Hz erstes 2500Hz 2. mal --> Mittel 2600
		case 'du'
			f11=120;		%%!!!
			f21=1500;		
			f31=2600;		%%!!!
		case 'ba'
			f11=400;		
			f21=1080;		%%bei etwa 1080Hz begonnen beim 2.
			f31=2700;		%%2700Hz beim 2.
		case 'be'	
			f11=140;		%%2. bei 140 Hz
			f21=1200;		%%fängt bei 1200Hz an
			f31=2200;		%%fängt bei etwa 2200Hz an
		case 'bi'		
			f11=150;		%%fängt bei 150Hz an(einzelne werte 1 und 2)
			f21=1600;		%%fängt bei etwa 1600Hz an
			f31=2800;		
		case 'bo'			
			f11=120;		%%2. sagt 120Hz
			f21=f2-150;		%%steigt um etwa 100Hz
			f31=2650;		%%2. mal über 2600Hz
		case 'bu'			
			f11=120;		%%2. sagt etwa 120Hz
			f21=f2;			%%unklar, vllt. sogar gleich
			f31=3000;		%%!!!
		case 'ga'			
			f11=260;		
			f21=1700;		
			f31=2100;		
		case 'ge'	
			f11=200;		%%beim 1.
			f21=2300;		%%!!!
			f31=2600;
		case 'gi'		
			f11=100;		
			f21=2500;		
			f31=3200;
		case 'go'
			f11=250;		%%steigt um etwa 100Hz
			f21=1250;		
			f31=3000;		
		case 'gu'		
			f11=50;			%%!!!
			f21=1200;		%%!!!
			f31=2700;
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filterung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	y=formantfilter(x,Ts,f11,B1,f1, U, O);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B2,f2, U, O);	%2. Formantfilter
	y=formantfilter(y,Ts,f31,B3,f3, U, O);	%2. Formantfilter
	%wavwrite(y'/max(y),fs,strcat('plosiv-',lautliste,'.wav'));
end
