/* check the conection with server
 * function without paramters
 */
int check_connection() {
    return 0;
}

int main() {
    int i, j, k;
    for (int i = 0; i < 10; i++) {
        printf("%d\n", i);
        // goto to the the end in the middle
        // of the thecicle
        if (i < 5) {
            goto m1;
        }
    }

m1:
    return 1;
}

