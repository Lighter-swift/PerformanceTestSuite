# Makefile

all:
	swift build -c release

clean:
	rm -rf .build

run:
	swift run -c release PerformanceTests
