
all:	build
	node test.js

build:
	coffee -o lib/ -c srcs/*.coffee
	coffee -o . -c *.coffee


