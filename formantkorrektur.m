%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 				Korrektur Formantverläufe für Plosivanalyse				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;	%Fenster für Diagramm öffnen
file='gugu';	%Dateiname ohne .txt mit Formantferläufen
procent=5;		%Intensität in Prozent, die mindestens vorhanden sein müssen, damit die Formantwerte angezeigt werden
A=dlmread([file '.txt']);	%Datei mit Formantverläufen einlesen
a=[1 3 4 5 6];		%Spaltenauswahl
mini=max(A(:,2))*procent/100;			%%minimaler wert zum zeichnen
first=1;		%Wert überprüft, ob im ersten abschnitt oder im zweiten Abschnitt von z.B. "da-da"
beginn=0;		%erste gültiger Wert 
last=0;			%letzer gültiger Wert
for k=2:size(A(:,2))
	if(A(k,2)<mini)	%Wenn Amplitude zu niedrig --> Wert weglassen
		A(k,3:end)=[NaN NaN NaN NaN NaN];
		if(first == 1)
			beginn=k;
		end
	else 
		first=0;
		last=k;
	end
end		% Wenn Wert des ersten Formanten aufgrund von Fehlern zum zweiten geföhrt wird das korrigiert
	for k=beginn:size(A(:,2))-last
		if(isnan(A(k-3,3)))	%%wenn der wert keine Nummer ist dann nicht nehmen...
			if(isnan(A(k+3,3)))
				%%fail wir können nicht vergleichen...
			elseif(abs(A(k+3,3)-A(k,3))> abs(A(k+3,4)-A(k,3))) %%nur nächster wert verfügbar
				A(k,3:end)=[NaN A(k,3:end-1)];	%%falls der Abstand zum nächsten kleiner ist...
				disp("korreg");
			end
		elseif(isnan(A(k-3,3)))
			if(abs(A(k-3,3)-A(k,3))> abs(A(k-3,4)-A(k,3))) %%nur nächster wert verfügbar
				A(k,3:end)=[NaN A(k,3:end-1)];	%%falls der Abstand zum nächsten kleiner ist...
				disp("korreg");			
			end
		elseif(abs(A(k-3,3)+A(k+3,3)-2*A(k,3))> abs(A(k-3,4)+A(k+3,4)-2*A(k,3))) %%vorgänger und nachfolger verfügbar
				A(k,3:end)=[NaN A(k,3:end-1)];	%%falls der Abstand zum nächsten kleiner ist...
				disp("korreg");
		end
	end
beginn = ceil(beginn*0.8);	%Abstand zum anfang im 20% verringern
last=ceil(last*0.8);		%Abstand zum schluss um 20% verringern

t=A(1:end-beginn-last+1,1);	%Zeit auf Verringerung anpassen
t=[t ; 1.0];				%Zeit 1 s einfügen, damit alle diagramm 1s lang sind
A=A(beginn+1:end-last+1,a);	%Werte auf Verringerung anpassen
A=[A ; 1.0 NaN NaN NaN NaN];%Ungültigen Wert für 1s einfügen, damit bei 1s kein Punkt hingemacht wird

for i=2:size(A,2)			%Ploten der einzelnen Formantverläufe
	plot(t,A(:,i),"*");
	hold all;
end
legend('1','2','3','4')		%Bezeichnung der Verläufe

xlabel('Zeit t/s');
ylabel('Frequenz f/Hz');

matlab2tikz(['tex/stern/' file '-'  num2str(procent) '.tex']);	%in tex für Dokumentation speichern

