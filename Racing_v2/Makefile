PRJ_NAME = BrickGame
LIB_NAME = Race
SERV_NAME = BrickGameServ
DEST = 'platform=macOS,arch=arm64e'
SIGN = CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
SDK = macosx

VERSION = Debug

all: rebuild

build: clean build_cli build_serv

build_cli:
	cd gui/Cli && \
	xcodebuild -scheme cliBrickGame build -derivedDataPath ../../build/build_cli $(SIGN) -sdk $(SDK) -destination $(DEST)
	
build_serv:
	cd brick_game/Server/BrickGameServ && \
	xcodebuild -scheme BrickGameServ build -derivedDataPath ../../../build/build_serv $(SIGN) -sdk $(SDK) -destination $(DEST)

dev:
	live-server --port=5500 ./brick_game/Web-gui
	
install:  build
	cp -a build/build_cli/Build/Products/Debug/BrickGame ~/Desktop/
	cp -a build/build_serv/Build/Products/Debug/BrickGameServer ~/Desktop/
	
run: dev
	./~/Desktop/$(PRJ_NAME)
	./~/Desktop/$(PRJ_NAME)Server

uninstall:
	rm ~/Desktop/$(PRJ_NAME)
	rm ~/Desktop/$(PRJ_NAME)Server

dist: clean
	tar -czvf $(PRJ_NAME).tar.gz -C ./ .//var/folders/dj/074l4lrn0mn_ydbnrkjv8rg40000gn/T/TemporaryItems/NSIRD_screencaptureui_KMd58F/Снимок экрана 2024-12-20 в 15.45.52.png

dvi:
	open README.md

test: clean
	cd brick_game/Race && \
	xcodebuild -scheme Race test -derivedDataPath ../../build/build_lib $(SIGN) -sdk $(SDK) -destination $(DEST)

clean:
	rm -rf build
	rm -rf $(PRJ_NAME).tar.gz
	find . -type f -name '.build' | xargs -I {} sh -c 'rm -f {}'


rebuild: clean install
