# MAIN things to check for "DISCRTE IO"
1. command from the outside sets which channels are used as an output o input, or which one is disabled [__]
2. ( main entity ) must have two modes:
    - configuration mode :
        * ( main entity ) must have "configuration_mode" signal to start configuration mode [_DONE_]
        * ( main entity ) must have HI_threshold and LO_threshold as input [_DONE_]
    - sampling mode :
        * ( main entity ) must have a counter for fixed 10 ksps sampling [_DONE_]

3. discrete I/O data must be processed as packets when needed [_DONE_]
4. ( main entity ) must have BIT (SBIT and IBIT) as INTERNAL control. [__]
        -> so It doesn't need any external controls to be activated, how is it activated then? [__]

5. output functionality ( std_discr_dir = '1' ) [__]

# main blocks
1. ( Main entity ) must be composed of 3 macro blocks :
    - SPI master to interface with HOLT [_DONE_]
    - 32 standard discrete channels ( single entity replicated 32 times ) [_DONE_]
    - Packet manager [_DONE_]

2. testbench must have :
    - replica of the holt IC ( atleast the reading of the sensor values ) [_DONE_]
    - output analyzer block [_DONE_]

# macro blocks must :
1. SPI master :
    * must be able to write/read data to/from holt IC [_DONE_]
    * controlled by a unit that decodes commands from backbone [_DONE_]
        + unit must provide commands and parameters to send to HOLT IC [_DONE_]
        + unit is directly controlled by the signal that dictates the operation mode of the ( main entity ) ( see pt. 2 "configuration mode" ) [_DONE_]               
    * when in "sampling mode" sensor values (output) is accompanied by "data_ready" signal [_FIX_THE_FLAG_DURATION_] (it is working though)
    * Verify that the sensor channel "N" data is sent to the "N"th standard discrete IO channel [__]
        ( example : sensor 32 bit is being stored in standard discr_channel 32  )
        <!-- * at power on SPI must send software reset and release to holt ( see configuration mode and C231 ) [__] -->

2. standard discrete channel :
    * configured during "configuration mode" [__]
    * must have 2 buffers ( seee specs of excel sheet ) [_DONE_]
    * samples are stored when "data_ready" is HIGH [_DONE_]
    * during sampling mode, it must store sensor values every 100us ( see pt.2 "sampling mode" ) [_DONE_]
        + when "write_op" and "read_op" are both high, bit value must be stored in a second buffer while
          the already stored bits are being read [_DONE_]

3. packet manager :
    * when send_snf_data is HIGH, freeze all 32 buffers and make packet to transmit back to backbone [_DONE_]
    * even with disabled channels, datablock must be adjacent in the transmitted packet [_TO VERIFY IS DUMMY SLOTS ARE NEEDED_]
    * transmitted packet must be accompanied with a HIGH "receive_snf_data" signal [_DONE_]

# doubts :
1. what is emergency mode? [__]
    ->

2. what does criticality mean in this context? ( see C186 xls file ) [__]
    ->

3. The single channels receive data in the same form of a packet as the one sent?
   So I must make a unit that parses each datablocks to distibute data to channels? ( see C210 ) [__]
    ->

4. according to C213, each channel has their respective position, so i must fill those positions with
   dummy datablock? [__]
   ->

5. During configuration mode, do I need to reread HOLT regs to verify the correct configs? [__]
   ->
