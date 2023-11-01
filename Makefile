.PHONY: all clean

DIRECTORY=./
EXTENSION=.typ
COMPILE_EXTENSION=.pdf
FILES=$(shell find $(DIRECTORY) -type f -name '*$(EXTENSION)' -not -path './.cache/*')
COMPILED_FILES=$(patsubst %$(EXTENSION), %$(COMPILE_EXTENSION), $(FILES))

RM=rm
TC=typst -v c
TCARGS=--root $(DIRECTORY)

%.pdf: %.typ
	$(TC) $(TCARGS) $^

all: $(COMPILED_FILES)

clean: $(COMPILED_FILES)
	@for file in $^; do \
		$(RM) -rf $$file; \
	done