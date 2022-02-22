# things to do
1. make top level for the whole std_discr_if [__]
2. make tb_data_source [__]
3. make tb_output_analysis [__]
    3a. receive and parse each packet fields correctly [_DONE_] ( revised? [__] )
    3b. add output textfile log

4. verify basic functionality of the whole system:
    - phase 1: configuration mode [__]
        * send initial config_mode signal > holt software res > set psen > set thresholds > verify values > sampling mode
    - phase 2: continuous sampling [__]
    - packet making every 10 samples [__]
    - verify functionality for:
        * only write [__]
        * only read [__]
        * read and write [__]
