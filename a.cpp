//
// Created by tomer on 21/11/17.
//

#include <iostream>
#include <map>

using namespace std;

int main() {
    map<string, int> a;
    a["aaa"] = 3;
    a["c"] = 12;
    cout << a["xyz"] << endl;
}