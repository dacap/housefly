MXMLC = "$(PROGRAMFILES)/FlashDevelop/Tools/flexsdk/bin/mxmlc.exe"
FLIXEL = src
SRC = $(wildcard src/*.as)
MAIN = src/Game.as
SWF = bin/Game.swf

$(SWF) : $(SRC)
	$(MXMLC) -sp $(FLIXEL) -o $(SWF) -- $(MAIN)
