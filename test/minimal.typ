#import "../template.typ": *
#show: lttr_init.with(
    debug: true,
)
#show: lttr_preamble

A letter should compile without any attributes but some default values. 

#show: lttr_closing

Also, we can print the state:

#lttr_state()
