#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <thread>
#include <vector>
#include <mutex>
#include <numeric>
#include <condition_variable>
#include <chrono>

using namespace std;

mutex mtx; // мьютекс        
condition_variable cv; // условная переменная
int pot = 0; // текущее количество глотков в горшке
int counter = 0; // счетчик для выхода из программы
int n; // количество пчёл
int h; // максимальная вместимость горшка
chrono::steady_clock::time_point start; // таймер

void beeThread(int i) {
    while (true) {
        unique_lock<mutex> lock(mtx); // лок

        while (pot == h) { // пока горшок полон и пока его не опустошил медведь, пчёлы спят
            cv.wait(lock); 
        }

        if (counter == 20) break;

        pot++; // кладём глоток в горшочек

        cv.notify_all(); // оповещаем всех пчёл, что можно нести следующий глоток

        this_thread::sleep_for(chrono::milliseconds(250));

        cout << "[Timer: " << chrono::duration<double>(chrono::steady_clock::now() - start).count() << "] Bee " << i << " filled the pot. Pot: " << pot << " / " << h << "\n";

        if (pot == h) {
            this_thread::sleep_for(chrono::milliseconds(250));
            cout << "\n----------------------------------------------------\n--> [Timer: " << chrono::duration<double>(chrono::steady_clock::now() - start).count() << "] Bee " << i << " woke up the bear\n";
            cv.notify_one();// оповещаем медведя, что горшок наполнился
        }

        if (n > 1) cv.wait(lock); // пчела ожидает, пока другая пчела не положит глоток в горшок
    }
}

void bearThread() {
    while (true) {
        unique_lock<mutex> lock(mtx); // лок

        while (pot != h) { // пока горшок не полон, медведь спит
            cv.wait(lock); 
        }

        pot = 0; // медведь опустошает горшок

        cout << "--> [Timer: " << chrono::duration<double>(chrono::steady_clock::now() - start).count() << "] The bear ate. It was delicious!" << "\n----------------------------------------------------\n\n";

        counter++;

        this_thread::sleep_for(chrono::milliseconds(250));
        cv.notify_all(); // медведь оповещает пчёл, что можно заново наполнять горшок

        if (counter == 20) break;
    }
}

int main() {
    cout << "Enter the number of bees: ";
    cin >> n;

    if (n <= 0 || n > 1000) {
        cout << "Invalid number of bees!";
        exit(0);
    }

    cout << "Enter the pot capacity: ";
    cin >> h;

    if (h <= 0 || h >= INT_MAX) {
        cout << "Invalid number of pot capacity!";
        exit(0);
    }

    vector<thread> bees;

    thread bear = thread(bearThread); // создаем поток медведя

    for (int i = 0; i < n; i++) 
        bees.push_back(thread(beeThread, i + 1)); // создаем потоки пчёл

    start = chrono::steady_clock::now(); // запуск таймера

    for (int i = 0; i < n; i++)
        bees[i].join();
    bear.join();

    cout << "\nThe bear is full and asleep!\n";

    return 0;
}