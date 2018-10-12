# Exercises: scripting + text manipulation

## Account administration

1. Maak een functie die een user-account aanmaakt a.d.h.v. een e-mailadres
   - neem aan dat adres van de vorm Howest-student is
   - gebruik de voornaam als login, indien de gebruiker al bestaat wordt een cijfer toegevoegd
     - `adduser` geeft bv. exit codes waar je dat uit kan afleiden, zie `man adduser`
     - of je kan eerst in `/etc/passwd` kijken
   - genereer een random wachtwoord van de vorm `/[A-Za-z0-9]{8}/` voor de account (zie bv. <https://gist.github.com/earthgecko/3089509>)
   - maak de account aan (remember: `adduser` vs. `useradd` - which is best for scripting?)
   - output een regel van de vorm `user:password@hostname` op stdout
   - indien geen permissie (m.a.w. niet `root`), geef foutboodschap op `stderr` en exit
1. Schrijf een script rond deze functie zodat je adressen in batch kan verwerken
   - lees de e-mailadressen van `stdin`, 1 adres per regel
   - je kan [students.txt](./data/student.txt) gebruiken om te testen
1. Maak een script dat voorgaande gebruikt om een CSV-bestand te verwerken
   - een one-liner is ook goed! ;)
   - vorm CSV (merk op: 1e regel is header!):
     ```csv
     Pointer persoon,Student,Sorteernaam,Geboortedatum,E-mailadres
     42479,Mathieu Bonte,"BONTE,MATHIEU,GUNTHER",25.08.1998,mathieu.bonte@student.howest.be
     39420,Daan Claerhout,"CLAERHOUT,DAAN,WILLEM",17.04.1997,daan.claerhout@student.howest.be
     ...
     ```
    (zie [students.csv](./data/students.csv)))
   - gebruikersnaam en wachtwoord worden achteraan elke regel toegvoegd als 2 nieuwe kolommen, output op `stdout`
1. Extra: Breid uit zodat je een gebruikersnaam als argument kan meegeven en gebruik het `cloneuser` script dat je (hopelijk) geschreven hebt in week 1 om de accounts aan te maken (pas zo nodig aan, bv. voor random wachtwoord)
  
## Parsing log files

Voorbereiding:

- zoek de nodige opties om met `wget` iets te dowloaden en rechtsreeks op `stdout` te tonen
- breid uit tot one-liner die dat met gzipped-files werkt
  - NB: kan je aanpassen voor bv. xz compressie, tar, ... (maar: "gewone" zip gaat niet, slecht formaat...)
- breid uit om te download te beperken tot een max. aantal regels
  
### HTTP

1. SDSC-HTTP logs: <ftp://ita.ee.lbl.gov/traces/sdsc-http.txt.Z>, details at <http://ita.ee.lbl.gov/html/contrib/SDSC-HTTP.html>
   - geef het aantal requests/uur weer (logs zijn 24u lang, dus zou 24 resultaten moeten geven)
   - geef per "operation" weer hoeveel requests er in totaal waren
  
1. Apache `access.log`: <http://www.almhuette-raith.at/apache-log/access.log>
   - **520MB file! - beperk tot 100k regels = 22MB**
   - geef de top 10 van meest gevraagde bestanden/URLs weer
   - maak een lijst van de pagina's met broken links (dus de referer van alle requests die met status 404 eindigen)
   - zet om naar een CSV-bestand met formaat Date, IP, URL, Status

### SSH

1. Dataset: <https://www.secrepo.com/maccdc2012/ssh.log.gz>
   - Geef alle IP-adressen weer die succesvol hebben ingelogd

### Moar log data

<https://www.secrepo.com/>