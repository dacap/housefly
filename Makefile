MXMLC = "$(PROGRAMFILES)/FlashDevelop/Tools/flexsdk/bin/mxmlc.exe"
FLIXEL = third_party/flixel
SRC = $(wildcard src/*.as)
MAIN = src/Game.as
SWF = bin/Game.swf

$(SWF) : $(SRC)
	$(MXMLC) -sp $(FLIXEL) -o $(SWF) -- $(MAIN)
