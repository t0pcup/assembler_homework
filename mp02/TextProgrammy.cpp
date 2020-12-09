/*
    Mikhailova K.D.
    variant 15
    mini project 02
*/

#include <iostream>
#include <thread>
#include <string>
#include <mutex>
#include <chrono>
#include <random>

using namespace std;

constexpr int LEN_S = 10, LEN_D = 15;

char *solo;
pair<char, char> *duet;
int last_solo = -1, madam = -1, sir = -1, gone = 0;
mutex mem;

int place_to_duet(bool lady) {
    int last = lady ? madam : sir, opp = !lady ? madam : sir;
    char guest = lady ? 'w' : 'm';

    if (last == -1) {
        ++last;
        while (duet[last].second != 'n' || last == opp) ++last;

        duet[last].first = guest;
    } else {
        if (duet[last].second == 'n') {
            duet[last].second = guest;
        } else {
            ++last;
            while (duet[last].second != 'n' || last == opp) ++last;

            duet[last].first = guest;
        }
    }

    return last;
}

void occupy_s(const string &person) {
    if (last_solo >= LEN_S - 1) {
        mem.lock();
        ++gone;
        mem.unlock();
        cout << person + " left the hotel... [manager id: " << this_thread::get_id() << "]\n";
        return;
    }

    mem.lock();
    solo[++last_solo] = person[0] == 'L' ? 'w' : 'm';
    mem.unlock();
    cout << person << " checked in to the solo room #" << last_solo <<
         "! [manager id: " << this_thread::get_id() << "]\n";
}

void occupy_d(const string &person) {
    mem.lock();
    person[0] == 'L' ? madam = place_to_duet(true) : sir = place_to_duet(false);
    mem.unlock();

    cout << person << " checked in to the duet room #" << (person[0] == 'L' ? madam : sir) <<
         "! [manager id: " << this_thread::get_id() << "]\n";

}

void visitor(const string &person) {
    cout << person + " came to the hotel! ";
    int last = person[0] == 'L' ? madam : sir, opp = person[0] != 'L' ? madam : sir;

    last < LEN_D && (duet[LEN_D - 1].second == 'n' && opp != 14 || duet[last].second == 'n') ?
    occupy_d(person) : occupy_s(person);
}

void info() {
    cout << "\n  _______________________________________\n /                 HOTEL    " <<
         "             \\\n/                  *****                  \\\n|__________" <<
         "_______________________________|\n|  " << solo[0] << ' ';

    for (int i = 1; i < LEN_S; ++i)
        cout << "| " << solo[i] << ' ';
    cout << " |\n|_________________________________________|\t _____ \n| "
         << duet[0].first << ' ' << duet[0].second << ' ';

    for (int i = 1; i < 7; ++i)
        cout << "| " << duet[i].first << ' ' << duet[i].second << ' ';
    cout << "|\t/     \\\n";

    for (int i = 7; i < LEN_D - 1; ++i)
        cout << "| " << duet[i].first << ' ' << duet[i].second << ' ';
    cout << "|\t| " << duet[14].first << ' ' << duet[14].second << " |\n"
         << "Guests who left the hotel: " << gone << "\n\n";

}

void queue() {
    random_device rd;
    mt19937 mersenne(rd());

    while (solo[LEN_S - 1] == 'n' || duet[LEN_D - 1].second == 'n') {
        auto t = new thread(visitor, mersenne() % 2 == 0 ? "Lady" : "Gentleman");
        this_thread::sleep_for(0.27s);
//        info();
        t->join();
    }
}

void prepare() {
    solo = new char[LEN_S];
    duet = new pair<char, char>[LEN_D];

    for (int i = 0; i < LEN_S; ++i) {
        solo[i] = 'n';
        duet[i] = {'n', 'n'};
    }

    for (int i = LEN_S; i < LEN_D; ++i) {
        duet[i] = {'n', 'n'};
    }
}

int main() {
    prepare();
    info();
    queue();
    info();
    return 0;
}