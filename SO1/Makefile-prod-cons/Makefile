######################
# Repaso de Makefile #
######################

### Forma de un "comando" de Makefile
# target: requerimientos
# 	comandos
# En una consola yo llamo "make target" y ejecuta primero cada uno de los requerimientos y después comandos.

### Variables de Makefile:
# $@ target 
# $< el primer pre-requerimiento
# $^ todos los pre-requerimientos

### Ejemplo:
# build: clean lint 
#	gcc archivo.c -o main
#
# En este caso:
# $@ es el target, "build"
# $< es el primer requerimiento, "clean"
# $^ son todos los reqs: "clean lint"

#########################
# Ejemplo Makefile de C #
#########################

# Ejecutar make help para lista de comandos

GCC = gcc 
CFLAGS = -pthread -Wall -O2

.PHONY: rwlock clean all build-openmp help

#primer regla, es la default.
rwlock: rwlock-rpref.c lect-esc.c 
	$(GCC) $(CFLAGS) $^ -o $@

all: clean rwlock

clean:
	rm rwlock

build-openmp: CFLAGS = -fopenmp -Wall -O2
build-openmp: 
	$(GCC) $(CFLAGS) rwlock-rpref.c lect-esc.c -o rwlock

help: 
	@echo "make solo ejecuta -rwlock- y compila el programa"
	@echo "make rwlock ejecuta lo mismo"
	@echo "make clean elimina el binario (rwlock)"
	@echo "make all ejecuta -clean- y luego -rwlock- es decir, borra rwlock y luego compila los archivos y genera un ejecutable rwlock"
	@echo "make build-openmp compila los archivos con flags de OpenMP"
