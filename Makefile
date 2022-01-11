CXX=g++
CPPFLAGS=-Wall -Werror

TARGET=filesize
SRCS=$(TARGET).cc

all: $(TARGET)

$(TARGET): $(SRCS) 

tests: test
test: $(TARGET)
	sudo -./newtest.1
	sudo -./newtest.2
	sudo -./newtest.3
	sudo -./newtest.4
	sudo -./newtest.5

clean:
	rm -f $(TARGET) *.o test.*myoutput
