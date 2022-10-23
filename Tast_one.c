#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

const int max_length = 10; // кол-во символов, которое используется для ввода размера массива
const int max_size = 214748;  // максимальное число

// ввод числа
long inputNumber() {
    char buf[max_length];  // временная переменная
    char is_correct;  // проверка на корректность
    long number;  // число
    do {  // пока пользователь не введёт число, продолжаем ввод
        gets(buf);
        number = atol(buf);
        if (number == 0 && buf[0] != '0') {
            printf("You input a not number\n");
            is_correct = 'F';
        } else if (strlen(buf) > 10) {
            printf("You input too long number\n");
            is_correct = 'F';
        }
        else {
            is_correct = 'T';
        }
    } while (is_correct == 'F');

    return number;
}

// вывод массива на экран
void showArray(long *array, long size) {
    for (int i = 0; i < size; i++) {
        printf("array[%d] = %ld, ", i, array[i]);
    }
    printf("\n\n");
}

// считает новый размер для нового массива по условию
int countSize(long *array, long size) {
    int new_size = 0;
    for (int i = 0; i < size; ++i) {
        if (array[i] > 0) {
            new_size++;
        }
    }
    return new_size;
}

// ввод массива с клавиатуры
void inputArray(long *array, long size) {
    long buf;
    for (int i = 0; i < size; ++i) {
        printf("array[%d] =", i);
        buf = inputNumber();
        array[i] = buf;
    }
}

// создание нового массива на основе старого по условию
void createNewArray(long *array, long *new_array, long size) {
    for (int i = 0 ,j = 0; i < size; ++i) {
        if (array[i] > 0) {
            new_array[j] = array[i];
            ++j;
        }
    }
}

int main() {
    // вводим размер массива
    long N;
    printf("Input size of array A:");
    N = inputNumber();

    if (N == 0) {  // выходим из программы, если пользователь ввёл не число или 0.
        printf("Size of array A = 0. Arrays A and B cannot be created.");
        return 0;
    } else if (N < 0) {  // выходим из программы, если пользователь ввёл отрицательное число
        printf("You input a negative number.");
        return 0;
    } else if (N > max_size) {
        printf("N > max_size (214748)");
        return 0;
    }

    printf("N = %ld\n", N);
    long A[N];  // исходный массив

    // заполнение исходного массива числами
    inputArray(A, N);

    // выведем исходный массив
    printf("Array A:\n");
    showArray(A, N);

    // посчитаем количество положительных чисел в исходном массиве
    long count_positive;  // количество положительных чисел
    count_positive = countSize(A, N);

    // создадим новый массив на основе старого
    long B[count_positive];  // новый массив
    createNewArray(A, B, N);

    // выведем новый массив
    printf("Array B:\n");
    showArray(B, count_positive);
    return 0;
}
