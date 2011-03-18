all: lib.swf

lib.swf: src/*.hx src/ui/*.hx src/media/musicplayer/*.hx compile.hxml
	haxe compile.hxml

clean:
	rm -f lib.swf
