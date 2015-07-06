%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   			 Fricationw								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=fricationw(buchstaben,DUR,fs)

%%%%%%%%%%%%%%%%%%%%%			Parameter 	 	%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin==0) buchstaben={'w'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz

Ts=1/fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x01=sourcesignal('zisch',DUR,fs);		%Erzeugung des ersten Anregungssignal(Rauschen)
x02=sourcesignal('vokal',DUR,fs);		%Erzeugung des zweiten Anregungssignal

%%%%%%%%%%%%%%%%%%%%%		Filterstruktur 	 %%%%%%%%%%%%%%%%%%%%%%%%%


[b a] = butter(2,100/(.5*fs),'low');	%Manipulation des ersten Anregungssignals im Frequenzbereich mit Tiefpassfilter
y1 = filter(b,a,x01);

w1 = formantfilter(x02,Ts,251,100);		%1. Formantfilter
w1 = formantfilter(w1,Ts,1164,300);		%2. Formantfilter
w1 = formantfilter(w1,Ts,2183,200);		%3. Formantfilter
w = w1 + .001*y1;						%Parallele Struktur von "w"
y=w;

%wavwrite(y'/max(y),fs,strcat('FRCw','.wav'));
