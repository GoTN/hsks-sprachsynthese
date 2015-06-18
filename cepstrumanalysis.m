%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	HAUPTSEMINAR SPRACHSYNTHESE%
%				  Cepstrum-Analyse von WAVFiles						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function y=cepstrumanalysis()

% Einlesen einer Datei
% Man braucht ja nur marcus zu analysieren
% Einfacher ueber liste mit buchstaben

%signal=wavread('a-marcus.wav');
%x = dir("*.wav")
lautliste={'a';'e';'i';'o';'u';'ae';'oe';'ue'};


% Anzahl der Punkte für die spaetere FFT
nf=2^14; %solange das auch immer ausreicht, sonst dynamisch

for datei = 1:numel(lautliste)   % loop over wave files
	%signal = wavread (x(audio_files).name);   % read audio file
	[signal,Fs]=wavread(strcat(char(lautliste(datei)),'-marcus.wav'));
	% Normierung, zeitliche Begrenzung der Aufnahme
	signal = signal((end-nf)/2:(end+nf-1)/2);
	%figure;
	%plot(signal);
	df=Fs/nf;
	f=[0:df:(nf-1)*df];
	% Fensterung der Aufnahme mit einem Hamming-Fenster
	h_window = hamming(nf);
	signal = signal.*h_window;
	% Berechnung des cepstrums
	log_spectrum = 20*log10(abs(fft(signal)));
	%figure;
	%plot(log_spectrum);
	cepstrum = ifft(log_spectrum);
	% Fensterung des cepstrums, da das Cepstrum symmetrisch ist
	cepstrum = cepstrum(1:size(cepstrum)/2);
	figure;
	plot(real(cepstrum));
	fig_title = strcat('Cepstrum f\"ur den Vokal "', char(lautliste(datei)), '"');
	title(fig_title);
	xlabel('Quefrenz in Samples')
	ylabel('Cepstrum')
	%matlab2tikz(strcat(char(lautliste(datei)),'_cepstrum.tex'), 'height', '.5\textwidth')
  % Geliftertes Cepstrum
	ceps_coeff=real(cepstrum(1:256));
	figure;
	plot(ceps_coeff);
	fig_title = strcat('geliftertes Cepstrum f\"ur den Vokal "', char(lautliste(datei)), '"');
	title(fig_title);
	xlabel('Quefrenz in Samples')
	ylabel('geliftertes Cepstrum')
	%matlab2tikz(strcat(char(lautliste(datei)),'_liftered_cepstrum.tex'), 'height', '.5\textwidth')
  % Formantanalyse
	mag_spec = real(fft(ceps_coeff));
	l=length(mag_spec);
	mag_spec = mag_spec(1:128);
	df=Fs/l;
	f=[0:df:(l-1)/2*df];
	figure;
	plot(f,mag_spec);
	fig_title = strcat('Formanten f\"ur den Vokal " ', char(lautliste(datei)), '"');
	title(fig_title);
	xlabel('Frequenz in Hz')
	ylabel('Amplitudenspektrum')
	%matlab2tikz(strcat(char(lautliste(datei)),'_amplitude.tex'), 'height', '.5\textwidth');
	[peak, loc] = findpeaks(mag_spec, "DoubleSided")

	%input('weiter')

	% Maximabestimmung
end
% TODO: Maximumsbestimmung, Automatische Bearbeitung aller WAV-Files im Ordner
% Wie genau wird die Bandbreite der Formanten abgelesen?
