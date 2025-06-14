cmake_minimum_required(VERSION 3.15...3.25)
# Define la versión mínima y máxima aceptada de CMake
# (obligatorio definir versión mínima)

project(LectoresEscritores
    VERSION
        1.0
    DESCRIPTION
        "Producción y Consumo"
    LANGUAGES
        C)
# Define nombre, versión, descripción y lenguaje(s) usado(s) por el proyecto.
# (obligatorio definir el nombre)

add_library(RWLock rwlock-rpref.c)
# Define una librería con su nombre y archivo 

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(RWLock PUBLIC Threads::Threads)
# Declara que vamos a usar threads y en particular preferimos usar pthreads.
# Además linkeamos nuestra libreria para que use threads.

add_executable(LectEsc lect-esc.c)
# Define un executable con su nombre y archivo

target_link_libraries(LectEsc PUBLIC RWLock)
# Linkeamos nuestro ejecutable con nuestra libreria

# Se recomienda crear una carpeta build para llamar CMake desde ahí
# y que se generen todos los archivos ahí. Así lo aislamos de nuestros
# archivos, no se mezclan, y es más fácil ignorar los archivos
# de generación automática, por ejemplo, en git.

# Para generar el sistema de 'buildeo' (Makefile por ejemplo y por defecto)
# usamos el comando 'cmake {dir}' donde dir es la carpeta donde está
# el CMakeLists.txt

# Para efectivamente buildear el proyecto (una vez ya ejecutado el comando
# anterior) utilizamos el comando "cmake --build {dir}" donde dir es la
# carpeta donde se genero el sistema de buildeo.

# Estando en la carpeta build se podría ejecutar así:
# 1) cmake ..
# 2) cmake --build .

# Se puede ejcutar el comando 'cmake --build {dir} --target clean' para
# limpiar (eliminar) los archivos generados al buildear.
# Estando parado en build: cmake --build . --target clean

# Para mas información se puede consultar la documentación: https://cmake.org/cmake/help/latest/