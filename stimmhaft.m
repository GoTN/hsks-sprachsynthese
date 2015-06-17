%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% Erzeugung eines stimmhaften Lautes mittels einfacher Formantfilterung %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y , f , B]=stimmhaft(buchstaben,DUR,fs,syn)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'ae';'oe';'ue';'a';'u';'e';'i';'o'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
%if (nargin<=3) B=[100 160]; end %bandwidth
if (nargin<=3) syn=1;	end %%soll synthetisieren?
	
Ts=1/fs;
%B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
%B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe
f1=f2=f3=0;%damit die in FKT definiert sind...
B1=B2=B3=0;%damit die in FKT definiert sind...
x=sourcesignal('vokal',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'a'
			%f1=1000;
			%f2=1400;
		%Von Praat ermittelte Werte
			%f1=732;
			%f2=1195;
			%f3=2516;
			%B1=160.5;
			%B2=136.4;
			%B3=219.0;
		%Aus Spektrum ermittelte Werte
			f1=818;
			f2=1249;
			f3=2541;
			B1=196;
			B2=138;
			B3=185;
		%Aus Cepstrum ermittelte Werte
			%f1=861;
			%f2=1206;
			%f3=2584;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'e'
			%f1=500;
			%f2=2300;
		%Von Praat ermittelte Werte
			%f1=372;
			%f2=1983;
			%f3=2506;
			%B1=25.64;
			%B2=65.47;
			%B3=120.4;
		%Aus Spektrum ermittelte Werte
			f1=388;
			f2=2024;
			f3=2541;
			B1=197;
			B2=209;
			B3=267;
		%Aus Cepstrum ermittelte Werte
			%f1=345;
			%f2=2067;
			%f3=2584;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'i'
			%f1=320;
			%f2=3200;
		%Von Praat ermittelte Werte
			%f1=200
			%f2=2211
			%f3=2076
			%B1=34.65;
			%B2=84.69;
			%B3=234.6;
		%Aus Spektrum ermittelte Werte
			f1=215;
			f2=2282;
			f3=3143;
			B1=115;
			B2=184;
			B3=267;
		%Aus Cepstrum ermittelte Werte
			%f1=172;
			%f2=2239;
			%f3=3101;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'o'
			%f1=500;
			%f2=1000;
		%Von Praat ermittelte Werte
			%f1=359
			%f2=727
			%f3=2459
			%B1=161.4;
			%B2=272.6;
			%B3=247.5;
		%Aus Spektrum ermittelte Werte
			f1=388;
			f2=818;
			f3=2283;
			B1=162;
			B2=205;
			B3=197;
		%Aus Cepstrum ermittelte Werte
			%f1=345;
			%f2=861;
			%f3=2239;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'u'
			%f1=320;
			%f2=800;
		%Von Praat ermittelte Werte
			%f1=362
			%f2=721
			%f3=2301
			%B1=159.3;
			%B2=351.7;
			%B3=279.2;
		%Aus Spektrum ermittelte Werte
			f1=215;
			f2=646;
			f3=2110;
			B1=394;
			B2=371;
			B3=377;
		%Aus Cepstrum ermittelte Werte
			%f1=172;
			%f2=689;
			%f3=2067;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'ae'
			%f1=700;
			%f2=1800;
		%Von Praat ermittelte Werte
			%f1=596
			%f2=1421
			%f3=2299
			%B1=99.65;
			%B2=173.0;
			%B3=280.0;
		%Aus Spektrum ermittelte Werte
			f1=646;
			f2=1507;
			f3=2369;
			B1=174;
			B2=276;
			B3=220;
		%Aus Cepstrum ermittelte Werte
			%f1=689;
			%f2=1378;
			%f3=2239;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'oe'
			%f1=500;
			%f2=1400;
		%Von Praat ermittelte Werte
			%f1=335
			%f2=1323
			%f3=2190
			%B1=51.23;
			%B2=129.0;
			%B3=110.6;
		%Aus Spektrum ermittelte Werte
			f1=388;
			f2=1421;
			f3=2196;
			B1=231;
			B2=220;
			B3=162;
		%Aus Cepstrum ermittelte Werte
			%f1=;
			%f2=1387;
			%f3=2239;
			%B1=;
			%B2=;
			%B3=;
		
		
		case 'ue'
			%f1=320;
			%f2=1650;
		%Von Praat ermittelte Werte
			%f1=284;
			%f2=1535;
			%f3=2077;
			%B1=92.18;
			%B2=177.6;
			%B3=231.4;
		%Aus Spektrum ermittelte Werte
			f1=215;
			f2=1680;
			f3=2024;
			B1=115;
			B2=152;
			B3=138;
		%Aus Cepstrum ermittelte Werte
			%f1=172;
			%f2=1550;
			%f3=2067;
			%B1=;
			%B2=;
			%B3=;
		
		
			
	end
	if(syn == 1)
		y=formantfilter(x,Ts,f1,B1);	%1. Formantfilter
		y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter
		y=formantfilter(y,Ts,f3,B3);	%3. Formantfilter
	else 
		y=x;
	end
	f=[f1 f2 f3];
	B=[B1 B2 B3];
	wavwrite(y'/max(y),fs,strcat('stimmhaft-',char(buchstabe),'.wav'));
end
