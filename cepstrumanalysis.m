%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			HAUPTSEMINAR SPRACHSYNTHESE                 %
%			Cepstrum-Analyse von WAVFiles	            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lautliste={'a';'e';'i';'o';'u';'ae';'oe';'ue'};

% Anzahl der Punkte für die spaetere FFT
nf=2^14;

% Alle Elemente von lautliste werden bearbeitet
for datei = 1:numel(lautliste)
	[signal,Fs]=wavread(strcat(char(lautliste(datei)),'-marcus.wav'));
	% Normierung, zeitliche Begrenzung der Aufnahme
	signal = signal((end-nf)/2:(end+nf-1)/2);
	% Festlegung eines Frequenzschrittes und des Frequenzbereichs für die spätere Frequenzachse
	df=Fs/nf;
	f=[0:df:(nf-1)*df];
	% Fensterung der Aufnahme mit einem von-Hann-Fenster
	h_window = hamming(nf);
	signal = signal.*h_window;
	% Berechnung des Cepstrums
	log_spectrum = 20*log10(abs(fft(signal)));
	cepstrum = ifft(log_spectrum);
	% Fensterung des cepstrums, da das Cepstrum symmetrisch ist
	cepstrum = real(cepstrum(1:size(cepstrum)/2));
	figure;
	plot(cepstrum);
	fig_title = strcat('Cepstrum f\"ur den Vokal \enquote{', char(lautliste(datei)), '}');
	title(fig_title);
	xlabel('Quefrenz in Samples')
	ylabel('Cepstrum')
  	% Lifterung des Cepstrums, Fenstergröße experimentell ermittelt
	ceps_coeff=real(cepstrum(1:256));
	figure;
	plot(ceps_coeff);
	fig_title = strcat('geliftertes Cepstrum f\"ur den Vokal \enquote{', char(lautliste(datei)), '}');
	title(fig_title);
	xlabel('Quefrenz in Samples')
	ylabel('Geliftertes Cepstrum')
	 % Formantanalyse - Rücktransformation und Plot der spektralen Hüllkurve
	mag_spec = real(fft(ceps_coeff));
	l=length(mag_spec);
	mag_spec = mag_spec(1:128);
	df=Fs/l;
	f=[0:df:(l-1)/2*df];
	figure;
	plot(f,mag_spec);
	fig_title = strcat('Formanten f\"ur den Vokal \enquote{', char(lautliste(datei)), '}');
	title(fig_title);
	xlabel('Frequenz in Hz')
	ylabel('Amplitudenspektrum')

end
