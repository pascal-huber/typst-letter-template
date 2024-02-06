#import "@local/lttr:0.1.0": *
#show: lttr-init.with(
    debug: true,
    format: "DIN-5008-A",
    title: "Writing Letters in Typst is Easy",
    settings: (
        min_content-spacing: 10cm,
    ),
    opening: "Dear Peter,",
    closing: "Peace, I'm out",
    signature: "Hans",
    date-place: (
        date: "20.04.2023",
        place: "Weitfortistan",
    ),
    horizontal-table: (
        ("Ihr Zeichen", "Bananalover149"),
        ("Ihre Nachricht vom", "12.12.2022"),
        ("Unser Zeichen", "BananaFactory"),
        ("Datum", "06.08.2023"),
    ),
    return-to: "Bananas Ltd · Fruitstreet 15 · 1234 Monkey City · Gorillaland",
    remark-zone: (
        "Why would anyone write a remark?",
        "...hideous...",
    ),
    receiver: (
        "Peter Bananeater",
        "Bahnhofsstrasse 16",
        "1234 Fruchtstadt",
        "Weitfortistan",
    ),
    sender: ([
        #image("logo.png", width: 60%)
        Bananas Ltd.\
        Fruitstreet 15\
        1234 Monkey City\
        Gorillaland 
    ]),
)

#show: lttr-preamble

#lorem(50)

#lorem(20)

#show: lttr-closing
