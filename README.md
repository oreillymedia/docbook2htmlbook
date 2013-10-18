docbook2htmlbook
================

This script is currently in development and converts [DocBook XML](http://www.docbook.org/) to [HTMLBook](https://github.com/oreillymedia/HTMLBook).

It's written in XSLT 2.0, so you'll need to run it with an XSLT 2.0 processor.

### Running the Script

Run these commands to output the HTMLBook:

```java -jar saxon9he.jar -s:book.xml -o:book.xml unwrapblocks.xsl```
```java -jar saxon9he.jar -s:book.xml -o:book.html docbook2htmlbook.xsl```

If you're starting with DocBook 5, run the DB 5 to DB 4 converter first:

```java -jar saxon9he.jar -s:book.xml -o:book.xml db5to4.xsl```
```java -jar saxon9he.jar -s:book.xml -o:book.xml unwrapblocks.xsl```
```java -jar saxon9he.jar -s:book.xml -o:book.html docbook2htmlbook.xsl```

#### Optional parameters

* Output xref label text by running conversion with parameter ```xref_label``` set to ```true```. For example:
```java -jar saxon9he.jar -s book.xml -o book.asc docbook2htmlbook.xsl xref_label=true```

### Validating the Output

You can validate the output against the HTMLBook Schema, found [here](https://github.com/oreillymedia/HTMLBook).
