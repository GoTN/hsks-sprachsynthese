%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		HAUPTSEMINAR SPRACHSYNTHESE				%
% 	Erzeugung eines Vibranten mittels einfacher Formantfilterung 	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y , f , B]=vibrant(laute,DUR,fs,syn)

%%%%%			PARAMETER			%%%%%
if (nargin==0) laute={'r'}			;end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
%if (nargin<=3) B=[100 160]; end %bandwidth
if (nargin<=3) syn=1;	end %bool, ob synthetisiert werden soll

Definition von Periodendauer, Grundfrequenz und Filterparameter
Ts=1/fs;	%Dauer eines Samples
f1=f2=f3=0;%Initialisierung f1-f3
B1=B2=B3=0;%Initialisierung B1-B3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samples=ceil(DUR*fs); %Anzahl der Samples
t=0:Ts:(samples-1)*Ts; %Zeitachse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=sourcesignal('vibrant',DUR,fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_w = 7; %Frequenz für Fensterfunktion

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(laute)
	laut=laute(i);
	
	%Switch-Case-Struktur, zur einfachen Erweiterung des Programms
	switch char(buchstabe)
		case 'r'
		% Aus Klatt-Paper entnommene Werte
			f1=310;
			f2=1060;
			f3=1380;	
			B1=70;
			B2=100;
			B3=120;
	end
	if(syn == 1)
	
	%Formantfilterung
		y=formantfilter(x,Ts,f1,B1);	%1. Formantfilter
		y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter
		y=formantfilter(y,Ts,f3,B3);	%3. Formantfilter
		
	%Definition eines Fensters nach Lehrbriefen
    N = length(y);
		N1 = floor(.2*N);
		wind_1 = zeros(1,N1);
		wind_2 = 3*sin(2*pi*f_w*t(N1+1:N))+t(N1+1:N);
		wind = [wind_1 wind_2];
	%Fensterung des Signals
    y=y.*wind;
	end
	%Normierung des Signals
	y=y/max(y);
	%Schreiben des Einzellauts in wav-Datei
	wavwrite(y'/max(y),fs,strcat('vibrant-',char(buchstabe),'.wav'));
end
