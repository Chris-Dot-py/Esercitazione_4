# things to do
1. make top level for the whole std_discr_if [_DONE_]
2. make tb_data_source [__]
3. make tb_output_analysis [__]
    3a. receive and parse each packet fields correctly [_DONE_] ( revised? [_DONE_] )
    3b. add output textfile log [__]

4. verify basic functionality of the whole system:
    - phase 1: configuration mode [_DONE_]
        * send initial config_mode signal > holt software res > set psen > set thresholds > sampling mode
    - phase 2: continuous sampling [_DONE_]
    - packet making every N samples [__]
    - verify functionality for memory:
        * only write [_DONE_]
        * only read [_DONE_]
        * read and write [_DONE_]

5. add counter for sampling every X secs [_DONE_]

6. Add tracking mechanism of the oldest bit in case of send_snf_data doesnt arrive before
   the 11th bit [__]
