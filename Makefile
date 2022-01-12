CXX=g++
CPPFLAGS=-Wall -Werror

TARGET=filesize
SRCS=$(TARGET).cc

all: $(TARGET)

$(TARGET): $(SRCS) 

tests: test
test: $(TARGET)
	-./newtest.1
	-./newtest.2
	-./newtest.3
	-./newtest.4
	-./newtest.5

clean:
	rm -f $(TARGET) *.o test.*myoutput
