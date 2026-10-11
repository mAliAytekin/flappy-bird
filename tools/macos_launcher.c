/* Yerel macOS paketinin Godot çalıştırıcısını kendi PCK dosyasıyla başlatır. */
#include <mach-o/dyld.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
int main(int argc, char **argv) {
    char executable[PATH_MAX], runtime[PATH_MAX], pack[PATH_MAX], resources[PATH_MAX];
    uint32_t size = sizeof(executable);
    if (_NSGetExecutablePath(executable, &size) != 0) return 1;
    char *directory = dirname(executable);
    snprintf(runtime, sizeof(runtime), "%s/GodotRuntime", directory);
    snprintf(pack, sizeof(pack), "%s/../Resources/ParlakIsler.pck", directory);
    snprintf(resources, sizeof(resources), "%s/../Resources", directory);
    if (chdir(resources) != 0) { perror("Paket klasörü açılamadı"); return 1; }
    char **arguments = calloc((size_t)argc + 3, sizeof(char *));
    if (!arguments) return 1;
    arguments[0] = runtime;
    arguments[1] = "--main-pack";
    arguments[2] = pack;
    for (int i = 1; i < argc; i++) arguments[i + 2] = argv[i];
    execv(runtime, arguments);
    perror("Oyun başlatılamadı");
    free(arguments);
    return 1;
}
