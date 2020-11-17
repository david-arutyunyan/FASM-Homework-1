﻿#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <thread>
#include <vector>
#include <mutex>
#include <numeric>

using namespace std;

const double EPS = 1E-9;
constexpr int SIZE = 1;
long long n, threads_number;
vector<vector<double>> A(SIZE, vector<double>(SIZE));
double det;
mutex mut;

void PrintMatr(vector<vector<double>> arr, int m) {
	int i, j;
	for (i = 0; i < m; i++) {
		for (j = 0; j < m; j++)
			cout << setiosflags(ios::fixed) << setprecision(0) << arr[i][j] << " ";
		cout << '\n';
	}
}

vector<vector<double> > GetMatr(vector<vector<double> > arr, int ii, int jj, int m) {
	vector<vector<double> > ans(n - 1, vector<double>(n - 1));
	int dj, di = 0;

	for (int i = 0; i < m - 1; i++) {
		if (i == ii) di = 1;
		dj = 0;
		for (int j = 0; j < m - 1; j++) {
			if (j == jj) dj = 1;
			ans[i][j] = arr[i + di][j + dj];
		}
	}

	return ans;
}

double Det(vector<vector<double>> a, int m) {
	double det = 1;
	for (int i = 0; i < m; ++i) {
		int k = i;
		for (int j = i + 1; j < m; ++j)
			if (abs(a[j][i]) > abs(a[k][i]))
				k = j;
		if (abs(a[k][i]) < EPS) {
			return 0;
		}
		swap(a[i], a[k]);
		if (i != k)
			det = -det;
		det *= a[i][i];
		for (int j = i + 1; j < m; ++j)
			a[i][j] /= a[i][i];
		for (int j = 0; j < m; ++j)
			if (j != i && abs(a[j][i]) > EPS)
				for (int l = i + 1; l < m; ++l)
					a[j][l] -= a[i][l] * a[j][i];
	}

	return det;
}

void Keks(int i) {
	double sum = 0;

	for (int j = i; j < n; j += threads_number) {
		vector<vector<double>> p = GetMatr(A, j, 0, n);

		double det = Det(p, n - 1);

		sum += pow(-1, j) * A[(int64_t)j][0] * det;
	}

	mut.lock();

	det += sum;

	mut.unlock();
}

int main() {
	cout << "Enter the number of threads [1, 2147483647]: ";
	cin >> threads_number;
	if (threads_number <= 0 || threads_number > INT_MAX) {
		cout << "Invalid number of threads!";
		exit(0);
	}

	cout << "Enter the dimension of the square matrix [1, 2147483647]: ";
	cin >> n;
	if (n <= 0 || n > INT_MAX) {
		cout << "Invalid dimension of the square matrix!";
		exit(0);
	}

	A.assign(n, vector<double>(n));

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			cout << "M[" << i << "][" << j << "] = ";
			cin >> A[i][j];
		}
	}

	cout << "\n\nMatrix: \n";
	PrintMatr(A, n);

	chrono::steady_clock::time_point start = chrono::steady_clock::now();

	vector<thread> threads;
	
	int len = threads_number < n ? threads_number : n;
	threads_number = len;

	for (int i = 0; i < len; i++) {
		threads.push_back(thread(Keks, i));
	}

	for (int i = 0; i < len; i++) {
		threads[i].join();
	}

	if (abs(det) <= EPS) det = 0;

	cout << "\nDeterminant = " << setiosflags(ios::fixed) << setprecision(0) << det;

	chrono::duration<double> elapsed_seconds = chrono::steady_clock::now() - start;
	cout << "\n\nelapsed time: " << setiosflags(ios::fixed) << setprecision(6)
		<< elapsed_seconds.count() << "s\n";

	return 0;
}