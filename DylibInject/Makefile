OBJC = clang
CFLAGS = -dynamiclib -framework Foundation -fobjc-arc -arch arm64 -isysroot $(shell xcrun --sdk iphoneos --show-sdk-path)
TARGET = DylibInject.dylib

all:
	$(OBJC) $(CFLAGS) DylibInject.m -o $(TARGET)
