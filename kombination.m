%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%			HAUPSEMINAR KOMMUNIKATIONSSYSTEME SPRACHSYNTHESE		%%%%%
%%%%%					Kombination von Lauten							%%%%%
%%%%%							Mai 2015								%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							 PARAMETER 								%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phonemelength = .23;	%Laenge in sec
alpha = 1;			%%alpha for tukey window
ver =	int32((alpha*(phonemelength-1)/2));		%Verbindungsfaktor 
fs=44100;		%Abtastfrequenz
phonemesamples=floor(phonemelength*fs);	%Normierte Länge



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							READ WORD								%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Bitte geben sie ein Wort ein, dass gesprochen werden soll:');
word = scanf('%s','C');	%Wort einlesen, was ausgegeben werden soll
outputname = strcat(word , '.wav');	%Dateiname generieren
disp ('Das eingegebene Wort lautet:'), disp (word);
wordlength = length(word);	
disp ('und hat die laenge:'),disp (wordlength);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							MANIPULATE WORD							%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
word = tolower(word);	%Aussprache interresiert Groß- und Kleinschreibung nicht
%...Fallunterscheidungen, Lautpaare, ...
%neues cellarray, was laute beinhaltet
%word cellarray, wordlength=numel(word)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							SYNTHESIZE WORD							%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
final_out = zeros(1,wordlength*phonemesamples);	%%Vector, in den Wort gespeichert werden wird (großzügige länge, wird wegen verschiebung noch kleiner...)
anfang = 0; %Startwert ist Null
ende = 0;
charnum = 1;	%erster Laut wird gesucht
num_laut = 1;	%%Welcher Laut wird jetzt generiert
while charnum <= wordlength
	buchstabe=word(charnum);	%aktueller Buchstabe

	
	
%%%%%	LAUTTYP BESTIMMEN	%%%%%
max_size=3;	%Maximale Lautgröße; wird dann auf aktuelle angepasst
lauttyp = 'none';
  while(strcmp(lauttyp,'none'))
	if(max_size >= 0)
		max_size = max_size - 1;	%such nach kleinerer Lautkombination
	else
		lauttyp='Fail!';		%es wurde kein Laut gefunden, d.h. nichtbekannten Buchstabe eingegeben.
		disp('FAIL!!! Es wurde kein Lauttyp gefunden!!!');
		return;
	end	
	if(length(word)>=charnum+max_size)			%Pruefen ob aufeinanderfolgende Buchstaben als Laut bekannt sind	
		lauttyp=lautliste(word(charnum:charnum+max_size));
	end	
  end
	fprintf('Der %d. Laut ist:%s\n',num_laut,word(charnum:charnum+max_size));
	num_laut=num_laut+1; %einen weiteren Laut gefunden --> Anzahl Laute + 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
%%%%%	SOUND ERZEUGEN	%%%%%
charnum_temp=0; %temporäre Charnum
norm = 1;		%soll noch normiert werden?	norm = 1 --> ja sonst nicht normiert
	switch lauttyp					
		case 'diphthong'
			sound=diphthong({word(charnum:charnum+1)},2*phonemelength,fs);			%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +2;												%diphtong hat 2 Buchstaben		
		case 'vokal'
			sound=stimmhaft({word(charnum:charnum+max_size)},phonemelength,fs);							%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			if(max_size==0)
			charnum_temp = charnum +1;												%vokal hat 1 Buchstaben		
			else
			charnum_temp = charnum +2;
			end
		case 'vibrant'
			sound=vibrant({word(charnum:charnum+max_size)},phonemelength,fs)*0.4;							%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +1;												%vibrant hat 1 Buchstaben
			norm=0;			
		case 'zisch'
			sound=zischlaut({word(charnum:charnum+max_size)},phonemelength,fs);		%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +max_size+1;										%Zisch hat x Buchstaben
			norm=0;		
		case 'plosiv'
			sound=plosiv(word(charnum:charnum+1),phonemelength*1.5,fs);				%Plosiv ist 1,5 mal so lang wie vokal
			sound=[zeros(1,floor(0.083*fs)) sound];									%Pause vor Plosiv
			charnum_temp = charnum +2;												%plosiv hat 2 Buchstaben
		case 'plosiv_st'
			sound=plosiv_stimmlos(word(charnum),phonemelength,fs);
			charnum_temp = charnum + 1;
			sound=[zeros(1,floor(0.1*fs)) sound];			% Pause vor Burst
			norm=0;											% nicht normiert, weil Burst geringere Amplitude hat
		case 'pause'
			sound=zeros(1,phonemesamples*1.2);
			charnum_temp = charnum +1;												%pause hat 1
		case 'nasal'
			sound=nasal(word(charnum),phonemelength,fs);
			charnum_temp = charnum +1;
		case 'linquidl'
			sound=linquidl(word(charnum),phonemelength,fs);
			charnum_temp = charnum +1;
		case 'fricationw'
			sound=fricationw(word(charnum),phonemelength,fs);
			charnum_temp = charnum +1;
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phonemesamples_end=numel(sound);	

	
%%%%%	FENSTERUNG	%%%%%
	
	wind=tukeywin(numel(sound),alpha);								%Window (Samples)
	sound_out = sound.*wind';										%Fenstern des Lautes
	if(max(sound_out) != 0) if(norm == 1) sound_out = sound_out/max(sound_out); end end	%Normierung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%	Laut hinzufuegen	%%%%%
	if (charnum == 1)		%Erster Laut
		final_out(1:phonemesamples_end) = sound_out(1:phonemesamples_end);		%Laut in finalen Vektor
		anfang = phonemesamples_end-int32((alpha*(phonemesamples_end-1)/2))+1;	%Anfang des naechsten Lauts
	else
		ende = anfang + phonemesamples_end-1;	%Laut endet bei Anfang + Soundlänge
		final_out(anfang:ende) = final_out(anfang:ende) + sound_out(1:phonemesamples_end);	%Laut in finalen Vektor
		anfang = anfang + phonemesamples_end-int32((alpha*(phonemesamples-1)/2)); 	%neuer Angangswert Berechnet: Anfang + Lautlänge - Verschiebung ineinander
	end
	charnum = charnum_temp;	%Übernehmen der zwischengespeicherten Nummer der Buchstabenfolge
end
final_out(ende+1:numel(final_out))=[];%Offset wegschneiden
wavwrite(final_out'/max(final_out),fs,outputname);	%Vektor als Wav exportieren
