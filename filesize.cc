#include <iostream>
#include <fstream>
using namespace std;

int numlines(char *filename) {
    int lines = 0;
    ifstream thefile(filename); 
    if (!thefile.is_open())
        return(-1);

    string inputline;
    while (getline(thefile, inputline))
        ++lines;
    
    return lines;
}


int main( int argc, char* argv[] )
{
    std::cout << "program: " << argv[0] << '\n' ;

    for (int arg = 1; arg < argc; ++arg) {
        std::cout << " " << argv[arg] << ": " << numlines(argv[arg]) << '\n' ;
    }
    exit(0);
}
