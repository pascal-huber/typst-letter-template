#import "@preview/lttr:0.1.0": *
#show : lttr_init.with(
    debug: true,
    format: "DIN-5008-B",
    title: "Banana Order Confirmation",
    opening: "Dear Peter,",
    closing: "Peace, I'm out",
    signature: "Hansli",
    author: none,
    settings: (
        min_content_spacing: 0mm, 
    ),
    horizontal_table: (
        ("Ihr Zeichen", "Bananalover149"),
        ("Ihre Nachricht vom", "12.12.2022"),
        ("Unser Zeichen", "BananaFactory"),
        ("Datum", "06.08.2023"),
    ),
    date_place: (
        date: "20.04.2023",
        place: "Monkey City",
    ),
    // NOTE: DIN-5008-B specifies no specific return_to -> it will be merged into remark_zone
    return_to: "Bananas Ltd · Fruitstreet 15 · 1234 Monkey City · Gorillaland",
    remark_zone: "hello world",
    receiver: (
        "Peter Bananaeater",
        "Bahnhofsstrasse 16",
        "1234 Fruchtstadt",
        "Weitfortistan"
    ),
    sender: (
        // NOTE: This overrides the DIN 5008 position.top
        //   because we want a big banana image here
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
#show: lttr_preamble

#lorem(100)

#show: lttr_closing
