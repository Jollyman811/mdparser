
all:	build generate test

build:
	coffee -o lib/ -c srcs/*.coffee
	coffee -o . -c *.coffee

test:
	node test.js

generate:
	node generate.js > lib/grammar.js


