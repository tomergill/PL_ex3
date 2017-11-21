//
// Created by tomer on 21/11/17.
//

#include <iostream>
#include <map>

using namespace std;

int main() {
    map<string, int> a;
    map<string, int>::iterator it = a.begin();
    cout << (it == a.end()) << endl;
}