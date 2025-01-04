#import "@local/lttr:1.0.0": *
#show : lttr-init.with(
    debug: true,
    format: "DIN-5008-B",
    title: "Banana Order Confirmation",
    opening: "Dear Peter,",
    closing: "Peace, I'm out",
    signature: "Hans",
    horizontal-table: (
        // NOTE: we can override the default fmt to format the table entries
        fmt: (header, content) => [
            #text(fill: green, size: 0.8em)[
                #underline[#header]
            ]
            #linebreak()
            #content
        ],
        content: (
            ("Ihr Zeichen", "Banana"),
            ("Ihre Nachricht vom", "12.12.2022"),
            ("Unser Zeichen", "BananaFactory"),
            ("Datum", "06.08.2023")
        )
    ),
    date-place: (
        date: "20.04.2023",
        place: "Monkey City",
    ),
    return-to: "Bananas Ltd · Fruitstreet 15 · 1234 Monkey City",
    receiver: (
        "Peter Bananaeater",
        "Bahnhofsstrasse 16",
        "1234 Fruchtstadt",
        "Weitfortistan"
    ),
    sender: (
        // NOTE: This overrides the DIN 5008 position.top because we want a big
        //   banana image here
        position: (top: 3cm),
        content: [
            #image("logo_big.png", width: 60%)
            Bananas Ltd.\
            Fruitstreet 15\
            1234 Monkey City\
            Gorillaland 
        ]
    ),
)
#show: lttr-preamble

#lorem(100)

#show: lttr-closing
