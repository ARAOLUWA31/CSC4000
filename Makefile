CXX=g++
CPPFLAGS=-Wall -Werror

TARGET=filesize
SRCS=$(TARGET).cc

all: $(TARGET)
	chmod u+x newtest.?

$(TARGET): $(SRCS) 

tests: test
test: $(TARGET)
	chmod u+rx newtest.?
	-./newtest.1
	-./newtest.2
	-./newtest.3
	-./newtest.4
	-./newtest.5

clean:
	rm -f $(TARGET) *.o newtest.?.*

