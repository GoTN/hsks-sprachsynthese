%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					Erzeugung des Bursts von Plosiven					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,t]=burst(laut,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) laut={'d'};end		%laut
if (nargin<=1) DUR=2; end 			%duration in sec
if (nargin<=2) fs=44100; end 		%sampling freq in Hz
if (nargin<=3) B=[1500 2000]; end 	%bandwidth
	
	Ts=1/fs;	%Abtastperiode
	B1=B(1);	%Filterbandbreite Formant 1
	B2=B(2);	%Filterbandbreite Formant 2
	n=50;		%Bandpass n-ter Ordnung
	%f1 ist Mittenfrequenz Formant Filter 1
	%f2 ist Mittenfrequenz Formant Filter 2
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	x=sourcesignal('zisch',DUR,fs);			%%WGN von Zischquelle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	switch char(laut)
		case 'd'		%siehe Tscheschner Lehrbrief
			f1=600;		
			f2=4000;	
			B1=200;
			B2=8000;
			c1=15;		%Wichtung der Filter in dB
			c2=0;
		case 't'
			f1=300;	
			f2=6000;	
			B1=300;
			B2=4000;
			c1=5;		%Wichtung der Filters in dB
			c2=15;
		case 'b'
			f1=500;	
			f2=1500;	
			B1=500;
			B2=3000;
			c1=15;		%Wichtung der Filter in dB
			c2=1;
		case 'p'		
			f1=500;	
			f2=1500;	
			B1=500;
			B2=3000;
			c1=5;		%Wichtung der Filter in dB
			c2=-10;
		case 'k'
			f1=500;	
			f2=2000;	
			B1=500;
			B2=500;
			c1=15;		%Wichtung der Filter in dB
			c2=15;
		case 'g'		
			f1=400;	
			f2=2000;	
			B1=500;
			B2=600;
			c1=15;		%Wichtung der Filter in dB
			c2=0;
	end
	b1=fir1(n,[(f1-B1/2)*Ts*2,(f1+B1/2)*Ts*2], 'bandpass');
	b2=fir1(n,[(f2-B2/2)*Ts*2,(f2+B2/2)*Ts*2], 'bandpass');

	y= 10^(c1/20)*filter(b1, 1, x)+10^(c2/20)*filter(b2, 1, x);
	%wavwrite(y'/max(y),fs,strcat('burst-',char(laut),'.wav'));
