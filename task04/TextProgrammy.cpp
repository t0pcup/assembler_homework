/*
	Mikhailova K.D.
	variant 15
	task04
*/

#include <iostream>
#include "omp.h"
#include <string>
#include <chrono>
#include <mutex>
using namespace std;

constexpr int VALUES_AMOUNT = 999999000;
constexpr int LOWER_BOUND = 1000, UPPER_BOUND = 999999999;
mutex mem;
string result = "";

void work(int n, int l, int u) {
#pragma omp parallel
	{
#pragma omp for
		for (int i = l; i <= u; ++i) {
			bool flag = true;
			string modified = to_string(i * n), original = to_string(i);

			for (char c : original) {
				unsigned int l = 0, r = modified.length() - 1;
				while (l < r - 1) {
					unsigned int m = l + (r - l) / 2;
					modified[m] < c ? l = m : r = m;
				}
				if (!(modified[l] == c || modified[r] == c)) {
					flag = false;
					break;
				}
			}

			if (flag) {
				mem.lock();
				result += "original=" + original + "....modified=" + modified
					+ "....tid=" + to_string(omp_get_thread_num()) + '\n';
				mem.unlock();
			}
		}
	}
}

int main(int argc, char* argv[]) {
	if (argc != 4) {
		cout << "three params required\n";
		return -1;
	}

	/* number to work with, lower & upper bounds */
	int n = (int)stol(argv[1]), l = (int)stol(argv[2]), u = (int)stol(argv[3]);

	if (n < 2 || n > 9 || l < LOWER_BOUND || u > UPPER_BOUND) {
		cout << "wrong arguments given!\n";
		return -1;
	}
	auto start = chrono::high_resolution_clock::now();
	work(n, l, u);
	chrono::duration<float> duration = chrono::high_resolution_clock::now() - start;
	cout << result << "finished in " << duration.count() << 's';
	return 0;
}