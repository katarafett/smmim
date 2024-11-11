#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int get_field (const char** cmd, const int length, const char* arg);

int get_range(const char* file, const char* section);

int main(const int argc, const char** argv) {
    if (argc < 2) {
        puts("Usage: ini-reader <action> [flags]");
        return 1;
    }

    // Get range action
    if (strcmp(argv[1], "get-range") == 0) {
        if (argc < 3) {
            puts("Missing arguments");
            return 1;
        }
        int file_idx = get_field(argv, argc, "--file") + 1;
        printf("%s\n", argv[file_idx]);
        
    }
    return 0;
}

int get_field (const char** cmd, const int length, const char* arg) {
    for (int i = 0; i < length; i++) {
        if (strcmp(cmd[i], arg) == 0) 
            return i;
    }
    return -1;
}
