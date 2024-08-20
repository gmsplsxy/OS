SRC_DIR = src
HEADER_DIR = include
BUILD_DIR = .build

SRCS = $(wildcard $(SRC_DIR)/*.c)
ARMS = $(wildcard $(SRC_DIR)/*.S)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
OBJS += $(patsubst $(SRC_DIR)/%.S, $(BUILD_DIR)/%.o, $(ARMS))

PROGRAM = $(BUILD_DIR)/kernel8.img

TOOLCHAIN = aarch64-linux-gnu-
AS = $(TOOLCHAIN)as
GCC = $(TOOLCHAIN)gcc
OBJCOPY = $(TOOLCHAIN)objcopy

CFLAGS = -ffreestanding -O2 -Wall -Wextra

all: clean bear $(PROGRAM)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	$(GCC) -I$(HEADER_DIR) -c $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(GCC) $(CFLAGS) -I$(HEADER_DIR) -c $^ -o $@

$(PROGRAM): $(OBJS)
	$(GCC) $(CFLAGS) -nostdlib -lgcc $^ -T linker.ld -o $(BUILD_DIR)/kernel8.elf
	$(OBJCOPY) -O binary $(BUILD_DIR)/kernel8.elf $@

bear:
	bear -- make $(PROGRAM)

run: $(PROGRAM)
	qemu-system-aarch64 -M raspi3b -serial stdio -vnc :2180 -kernel $^

clean:
	rm -rf $(BUILD_DIR)/*
