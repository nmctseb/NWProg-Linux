# Labo 2: Working with text

## Tools

- Linux box/VM (pref Ubuntu)
- GNU grep, sed, (g)awk
- python >= 3.6
- As always: take notes in Markdown (or RsT if you prefer)

## Part 1: Regular Expressions

### Relevant xkcd's

- [s/keyboard/leopard/ (#1171)](https://xkcd.com/1171/)
- [Regex Golf (#1331)](https://xkcd.com/1313/)
- [Regular Expressions (#208)](https://xkcd.com/208/)
- [Perl Problems (#1171)](https://xkcd.com/1171/)
- [Backslashes (#1638)](https://www.xkcd.com/1638/)
- [Ayn Random (#1277)](https://www.xkcd.com/1277/)

### Intro/Refresh

- <https://regexone.com/lesson/introduction_abcs> --> do them all, including practice problems!

### Flavours

- POSIX (basic/extended): <https://www.regular-expressions.info/posix.html>
- GNU (basic/extended): <https://www.regular-expressions.info/gnu.html>
- Python: <https://www.regular-expressions.info/python.html>
- PCRE (Perl - FOSS lib used in PHP, R, ...): <https://www.regular-expressions.info/pcre.html>
- PowerShell: <https://www.regular-expressions.info/powershell.html>
- More: <https://www.regular-expressions.info/reference.html>

### References

- cheatsheet: <https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285>
- seriously serious tutorial: <https://www.regular-expressions.info/tutorial.html>
- moar:
  - https://regexr.com/
  - https://www.rexegg.com/
  - https://regexone.com/
  - https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285
- sed: https://www.digitalocean.com/community/tutorials/the-basics-of-using-the-sed-stream-editor-to-manipulate-text-in-linux
- python: https://docs.python.org/3/library/re.html

- file formats
  - csv: https://www.joeldare.com/wiki/using_awk_on_csv_files, https://docs.python.org/3/library/csv.html
  - ini: https://passingcuriosity.com/2010/updating-an-ini-file-with-awk/, https://docs.python.org/3/library/configparser.html
  - json: https://docs.python.org/3/library/json.html
  - yaml (PyYaML): https://pyyaml.org/wiki/PyYAMLDocumentation
  - xml: https://docs.python.org/3/library/xml.etree.elementtree.html
  
- python:
  - https://docs.python.org/3/library/text.html
  - parse nmap XML output
  - difflib

- parse/modify/generate confs (dhcpd, bind, apache, nginx, ...)
- http://augeas.net/download.html
