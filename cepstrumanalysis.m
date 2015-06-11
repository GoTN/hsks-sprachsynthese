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
nf=2^11; %solange das auch immer ausreicht, sonst dynamisch

for datei = 1:numel(lautliste)   % loop over wave files
	%signal = wavread (x(audio_files).name);   % read audio file
	[signal,Fs]=wavread(strcat(char(lautliste(datei)),'-marcus.wav'));
	% Normierung, zeitliche Begrenzung der Aufnahme
	%signal = signal./max(abs(signal));
	signal = signal((end-nf)/2:(end+nf-1)/2);
  figure;
  plot(signal);
	df=Fs/nf;
	f=[0:df:(nf-1)*df];
	% Fensterung der Aufnahme mit einem Hamming-Fenster
	h_window = hamming(nf);
	signal = signal.*h_window;
	% Berechnung des cepstrums
	log_spectrum = log10(abs(fft(signal)));
  figure;
  plot(log_spectrum);
	cepstrum = ifft(log_spectrum);
	%x_axis = (1:size(cepstrum));
	
	% Fensterung des cepstrums, da das Cepstrum symmetrisch ist
	cepstrum = cepstrum(1:size(cepstrum)/2);
  figure;
	plot(real(cepstrum));
	%plot(cepstrum);
	% Liftering (Filterung des Vokaltraktsignals mit Formanten)
	%lift = zeros(length(cepstrum),1);
	%lift(1:50) = 1;
	%lift_cepstr = real(cepstrum.*lift);	
	%ceps_coeff = lift_cepstr(1:50);		%unnoetig, geht alles in einer zeile
	ceps_coeff=real(cepstrum(1:128));
	mag_spec = real(fft(ceps_coeff));
  l=length(mag_spec);
  mag_spec = mag_spec(1:64);
	df=Fs/l;
	f=[0:df:(l-1)/2*df];
	figure;
	plot(f,mag_spec);
	title(strcat('Cepstrum',' ',char(lautliste(datei))));
	%input('weiter')

	% Maximabestimmung
	[pks,loc] = findpeaks(abs(mag_spec), 'DoubleSided');
end
% TODO: Maximumsbestimmung, Automatische Bearbeitung aller WAV-Files im Ordner
% Wie genau wird die Bandbreite der Formanten abgelesen?
