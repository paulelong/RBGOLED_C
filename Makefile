DIR_FONTS = ./Fonts
DIR_OBJ = ./obj
DIR_BIN = ./bin

OBJ_C = $(wildcard ${DIR_FONTS}/*.c ${DIR_OBJ}/*.c)
OBJ_O = $(patsubst %.c,${DIR_BIN}/%.o,$(notdir ${OBJ_C}))

TARGET = main
#BIN_TARGET = ${DIR_BIN}/${TARGET}

CC = g++

DEBUG = -g -O0 -Wall
CFLAGS += $(DEBUG) 

# USELIB = USE_BCM2835_LIB
#USELIB = USE_WIRINGPI_LIB
#USELIB = USE_DEV_LIB
USELIB = USE_BELA

DEBUG = -D $(USELIB)
ifeq ($(USELIB), USE_BCM2835_LIB)
    LIB = -lbcm2835 -lm 
else ifeq ($(USELIB), USE_WIRINGPI_LIB)
    LIB = -lwiringPi -lm 
else ifeq ($(USELIB), USE_BELA)
    LIB = -L/root/Bela/lib -lbela -lbelaextra
endif

ifeq ($(USELIB), USE_BELA)
	INCLUDE = /root/Bela/include
else
	INCLUDE = .
endif


${TARGET}:${OBJ_O}
	$(CC) $(CFLAGS) $(OBJ_O) -o $@ $(LIB)

${DIR_BIN}/%.o : $(DIR_OBJ)/%.c 
	$(CC) $(CFLAGS) -c  $< -o $@ -I $(DIR_FONTS) -I $(INCLUDE) $(LIB)

${DIR_BIN}/%.o:$(DIR_FONTS)/%.c
	$(CC) $(CFLAGS) -c  $< -o $@ 
	
clean :
	$(RM) $(DIR_BIN)/*.* $(TARGET) $(DIR_OBJ)/.*.sw?
