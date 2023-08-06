#import "@preview/lttr:0.1.0": *

#set document(
    title: "asdf"
)
#show : lttr_init.with(
    debug: true,
    // author: "asdf",
)
#show: lttr_preamble

A letter should compile without any attributes but some default values. 

#show: lttr_closing

Also, we can print the state:

#lttr_state()
