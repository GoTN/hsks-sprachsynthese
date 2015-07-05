%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   		   Liquidlaut-L								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=linquidl(buchstaben,DUR,fs)

%%%%%%%%%%%%%%%%%%%%%			Parameter 	 	%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin==0) buchstaben={'l'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz

Ts=1/fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=sourcesignal('linquidl',DUR,fs);	%Erzeugung des Anregungssinals
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%		Filterstruktur 	 	%%%%%%%%%%%%%%%%%%%%%%%%%

y = formantfilter(x,Ts,318,90);				%1. Formantfilter
y = formantfilter(y,Ts,1591,150);			%2. Formantfilter
y = formantfilter(y,Ts,2657,130);			%3. Formantfilter

wind=tukeywin(length(y),.01);
y = y.*wind';
y = .5*y;									%Hüllkurveverformung in Zeitbereich

wavwrite(y'/max(y),fs,strcat('LQDl','.wav'));