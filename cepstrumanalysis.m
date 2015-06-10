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
lautliste={'a'};


% Anzahl der Punkte für die spaetere FFT
nf=2^14; %solange das auch immer ausreicht, sonst dynamisch

for datei = 1:numel(lautliste)   % loop over wave files
	%signal = wavread (x(audio_files).name);   % read audio file
	[signal,Fs]=wavread(strcat(char(lautliste(datei)),'-marcus.wav'));
	% Normierung, zeitliche Begrenzung der Aufnahme
	%signal = signal./max(abs(signal));
	signal = signal((end-nf)/2:(end+nf-1)/2);

	% Fensterung der Aufnahme mit einem Hanning-Fenster
	h_window = hanning(nf);
	signal = signal.*h_window;

	% Berechnung des cepstrums
	spectrum = fft(signal);
	log_spectrum = log10(abs(spectrum));
	cepstrum = ifft(log_spectrum);
	%x_axis = (1:size(cepstrum));

	% Fensterung des cepstrums, da das Cepstrum symmetrisch ist
	cepstrum = cepstrum(1:size(cepstrum)/2);
	%plot(cepstrum);
	% Liftering (Filterung des Vokaltraktsignals mit Formanten)
	%lift = zeros(length(cepstrum),1);
	%lift(1:50) = 1;
	%lift_cepstr = real(cepstrum.*lift);	
	%ceps_coeff = lift_cepstr(1:50);		%unnoetig, geht alles in einer zeile
	ceps_coeff=real(cepstrum(1:50));
	mag_spec = fft(ceps_coeff, 41500);
	mag_spec = mag_spec(1:20250);
	figure;
	plot(real(mag_spec));
	title(strcat('Cepstrum',' ',char(lautliste(datei))));
	%input('weiter')

	% Maximabestimmung
	[pks,loc] = findpeaks(real(mag_spec), 'DoubleSided');
end
% TODO: Maximumsbestimmung, Automatische Bearbeitung aller WAV-Files im Ordner
% Wie genau wird die Bandbreite der Formanten abgelesen?
