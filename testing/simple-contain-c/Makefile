CC = gcc
CFLAGS = -Wall -Wextra -Werror -O2

SRC = main.c
OBJ = main.o

TARGET = mini_container

BINS = bash ls echo cat pwd ps mkdir rm cp mv touch sleep hostid hostname

all: setup $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(TARGET)

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(OBJ)

clean:
	@echo "Cleaning object files..."
	rm -f $(OBJ)

fclean: clean
	@echo "Cleaning executable..."
	rm -f $(TARGET)
	@echo "Cleaning rootfs..."
	rm -rf rootfs

re: fclean all

setup:
	@echo "=================================="
	@echo " Setting up container rootfs"
	@echo "=================================="
	@mkdir -p rootfs/bin rootfs/proc

	@echo ""
	@echo "[1/2] Copying binaries..."
	@for bin in $(BINS); do \
		path=$$(command -v $$bin); \
		if [ -f "rootfs/bin/$$bin" ]; then \
			echo "  [SKIP] $$bin already exists"; \
		else \
			echo "  [COPY] $$path -> rootfs/bin/"; \
			cp "$$path" rootfs/bin/; \
		fi; \
	done

	@echo ""
	@echo "[2/2] Copying shared libraries..."
	@for bin in $(BINS); do \
		path=$$(command -v $$bin); \
		echo "  Checking dependencies: $$bin"; \
		ldd "$$path" | grep -o '/[^ ]*' | while read lib; do \
			if [ -f "rootfs/$$lib" ]; then \
				echo "    [SKIP] $$lib"; \
			else \
				echo "    [COPY] $$lib"; \
				mkdir -p "rootfs/$$(dirname "$$lib")"; \
				cp "$$lib" "rootfs/$$lib"; \
			fi; \
		done; \
	done

	@echo ""
	@echo "=================================="
	@echo " Rootfs setup complete"
	@echo "=================================="

.PHONY: all clean fclean setup