/*
    Mikhailova K.D.
    variant 15
    task03
*/

#include <iostream>
#include <thread>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

const int values_amount = 999999000; 
int n, threads_amount; 
vector<thread> threads; 

void work(int thread_index) {
    int amount = values_amount / threads_amount, lower_bound = 1000 + amount * (thread_index - 1),
            upper_bound = (thread_index == 10 ? 0 : 999) + amount * thread_index;  

    for (int i = lower_bound; i <= upper_bound; ++i) {
        bool flag = true;
        string modified = to_string(i * n), original = to_string(i); 

        for (char c : original) { 
            unsigned int l = 0, r = modified.length() - 1;
            while (l < r - 1) {
                unsigned int m = l + (r - l) / 2;
                if (modified[m] < c)
                    l = m;
                else
                    r = m;
            }
            if (!(modified[l] == c || modified[r] == c)) {
                flag = false;
                break;
            }
        }

        if (flag) 
            cout << original.append("\n");
    }
}

void make_threads() { 
    for (int i = 1; i <= threads_amount; ++i)
        threads.emplace_back(thread(work, i));

    for (int i = 0; i < threads_amount; ++i)
        threads[i].join();
}

int main(int argc, char *argv[]) { /* N, then thread numb */
    if (argc != 3) {
        cout << "two params required\n";
        return -1;
    }

    n = (int) stol(argv[1]); /* number to work with */
    threads_amount = (int) stol(argv[2]); /* how many threads program's allowed to create */

    if (n < 2 || n > 9 || threads_amount < 1) {
        cout << "wrong arguments given!\n";
        return -1;
    }

    cout << "threads amount: " << threads_amount << "\tn: " << n << '\n';

    make_threads();
    return 0;
}