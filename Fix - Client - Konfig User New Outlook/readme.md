# Viel hilft viel Outlook Registry Settings zum (hoffentlichen) Verhindern der Migration auf 'Outlook new'

Die Registry-Keys habe ich nach bestem Wissen und Gewissen zusammengesucht :)
- https://www.borncity.com/blog/2024/11/08/migration-outlook-classic-zu-new-outlook-anfang-2025-auch-fuer-business-kunden/
- https://www.heise.de/news/Microsoft-verteilt-das-neue-Outlook-ab-Januar-an-Business-Kunden-10010043.html
- https://jans.cloud/2024/11/outlook-new-zwangsumstellung-am-06-01-2025/
- https://apps.datev.de/help-center/documents/1037821


### Benötigt werden
- LGPO.exe v3.0 - Download https://www.microsoft.com/en-us/download/details.aspx?id=55319
- Webspace zum Hosten der registry.pol sowie der LGPO.exe

Das Script lädt die LGPO.exe sowie die vorbereitete registry.pol herunter und wendet sie lokal an.
Über `Start-Process` wird der Standardoutput und -Error in Textdateien umgeleitet und in `$folder_fixes` abgelegt

Getestet mit n-able RMM als Aufgabe, sollte aber auch in anderen RMMs sowie Standalone laufen.

Die registry.pol kann anhand der 'konfig-user-new-outlook.registry.txt' erstellt werden:
```
LGPO.exe /r konfig-user-new-outlook.registry.txt /w konfig-user-new-outlook.registry.pol
```

### Es müssen angepasst werden:
- Pfad Zeile 1 (und ggf. die anderen Pfade)
- Download-URL LGPO.exe Zeile 9
- Download-URL registry.pol Zeile 10


Benutzung auf eigene Gefahr usw. etc.
