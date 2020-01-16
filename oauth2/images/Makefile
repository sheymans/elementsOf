PUML  = $(wildcard *.puml)
ATXT = $(PUML:.puml=.atxt)
PNG = $(PUML:.puml=.png)
PLANTUMLJAR = ~/Software/plantuml.jar

all: asciiart

asciiart: $(ATXT)

png: $(PNG)

%.atxt: %.puml
	java -jar $(PLANTUMLJAR) -txt $@ $<

%.png: %.puml
	java -jar $(PLANTUMLJAR) $@ $<

clean:
	@rm -f $(ATXT)
	@rm -f $(PNG)