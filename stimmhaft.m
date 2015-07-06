%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% Erzeugung eines stimmhaften Vokals mittels einfacher Formantfilterung %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,f,B]=stimmhaft(laute,DUR,fs,syn)

%%%%%			PARAMETER			%%%%%
if (nargin==0) laute={'ae';'oe';'ue';'a';'u';'e';'i';'o'};end	%Zu erzeugende Laute
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) syn=1;	end %bool, ob synthetisiert werden soll
	
Ts=1/fs;
f1=f2=f3=0;		%Initialisierung f1-f3
B1=B2=B3=0;		%Initialisierung B1-B3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=sourcesignal('vokal',DUR,fs);		%Erzeugen des Anregungssignals

%%%%%%%%%%%%%%%%%			FILTERUNG				%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(laute)	%Ueber alle Laute iterieren, die erzeugt werden sollen
	laut=laute(i);		%Zu erzeugender Einzellaut
	
	switch char(laut)
		case 'a'
		%Aus Spektrum ermittelte Werte
			f1=818;
			f2=1249;
			f3=2541;
			B1=196;
			B2=138;
			B3=185;
		
		case 'e'
		%Aus Spektrum ermittelte Werte
			f1=388;
			f2=2024;
			f3=2541;
			B1=197;
			B2=209;
			B3=267;
		
		case 'i'
		%Aus Spektrum ermittelte Werte
			f1=215;
			f2=2282;
			f3=3143;
			B1=115;
			B2=184;
			B3=267;
		
		case 'o'
		%Aus Spektrum ermittelte Werte
			f1=388;
			f2=818;
			f3=2283;
			B1=162;
			B2=205;
			B3=197;
		
		case 'u'
		%Aus Spektrum ermittelte Werte
			f1=215;
			f2=646;
			f3=2110;
			B1=394;
			B2=371;
			B3=377;
		
		case 'ae'
		%Aus Spektrum ermittelte Werte
			f1=646;
			f2=1507;
			f3=2369;
			B1=174;
			B2=276;
			B3=220;
		
		case 'oe'
		%Aus Spektrum ermittelte Werte
			f1=388;
			f2=1421;
			f3=2196;
			B1=231;
			B2=220;
			B3=162;		
		
		case 'ue'
		%Aus Spektrum ermittelte Werte
			f1=215;
			f2=1680;
			f3=2024;
			B1=115;
			B2=152;
			B3=138;		
	end
	f=[f1 f2 f3];
	B=[B1 B2 B3];
	y=x;
	if(syn == 1)
		for n=1:length(f)
			y=formantfilter(y,Ts,f(n),B(n));	%Formantfilter
		end
	end
	%wavwrite(y'/max(y),fs,strcat('stimmhaft-',char(laut),'.wav'));	%Schreiben des Einzellauts in wav-Datei
end
