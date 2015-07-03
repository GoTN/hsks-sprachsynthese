%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 	Erzeugung von Zischlauten mittels einfacher Rauschquellenfilterung 	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,t]=zischlaut(laute,DUR,fs)

%%%%%			PARAMETER			%%%%%
if (nargin==0) laute={'s';'sch';'ch';'f'};end %Zu erzeugende Laute
if (nargin<=1) DUR=2; end %Dauer in sec
if (nargin<=2) fs=44100; end %Sampling Freq in Hz
	
	Ts=1/fs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	x=sourcesignal('zisch',DUR,fs);		%Erzeugen des Anregungssignals
	disp(laute);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%			FILTERUNG				%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(laute)	%Ueber alle Laute iterieren, die erzeugt werden sollen
	laut=laute(i);		%Zu erzeugender Einzellaut
	
	switch char(laut)
		case 's'		
			b1=fir1(40,[6500 7500]/(fs/2),'DC-0');	%Filter 1
			w1=.5;									%Wichtung 1
			b2=fir1(50,[5500 6500]/(fs/2),'DC-0');	%Filter 2
			w2=.5;									%Wichtung 2
		case 'sch'		
			b1=fir1(50,[2000 4750]/(fs/2),'DC-0');
			w1=1;
			b2=fir1(100,[4950 6400]/(fs/2),'DC-0');
			w2=.5;
		case 'ch'		%'Ich'-Laut
			b1=fir1(200,[2700 4750]/(fs/2),'DC-0');
			w1=1;
			b2=fir1(100,[4500 6400]/(fs/2),'DC-0');
			w2=.8;
		case 'f'
			b1=fir1(50,[900 1100]/(fs/2),'DC-0');
			w1=.5;
			b2=fir1(10,[7000 9000]/(fs/2),'DC-0');
			w2=.2;
	end
	y=w1*filter(b1,1,x)+w2*filter(b2,1,x);	%Parallele Filterung des Quellsignals mit Wichtungen
	
	%wavwrite(y'/max(y),fs,strcat('zischlaut-',char(laut),'.wav'));	%Schreiben des Einzellauts in wav-Datei
end
