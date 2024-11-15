#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int get_range(char* file, const char* section);

int main(const int argc, const char** argv) {
    int a = 3;
    char* b[] = {"./ir", "get-range", "a_file.txt", "mew"};
    if (a < 2) {
        puts("Usage: ini-reader <action> [flags]");
        return 1;
    }

    // yep
    get_range(b[2], b[3]);

    return 0;
}

int get_range(char* file, const char* section) {
    FILE* f = fopen(file, "r");
    if (f == NULL) {
        printf("%s\n", strerror(errno));
        return 1;
    }

    char* line = calloc(1, sizeof(char));
    char* buff = malloc(sizeof(char));
    int i = 0;
    while (fread(buff, sizeof(char), 1, f)) {
        line = realloc(line, i + 1);
        strcat(line, buff);
        if (*buff == '\n') {
            printf("%s", line);
            free(line);
            line = calloc(1, sizeof(char));
        }
        i++;
    }

    free(line);
    free(buff);
    fclose(f);
}
