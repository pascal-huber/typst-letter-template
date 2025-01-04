#import "@local/lttr:1.0.0": *
#show: lttr-init.with(
    debug: true,
    format: "C5-WINDOW-RIGHT",
    title: "Brief schribä mit Typst isch zimli eifach",
    opening: "Hoi Peter,",
    closing: "Uf widerluege",
    signature: "Ruedi",
    date-place: (
        date: "20.04.2023",
        place: "Witfortistan",
    ),
    receiver: (
        "Peter Empfänger",
        "Bahnhofsstrasse 16",
        "1234 Zimliwitwegistan",
    ),
    sender: ([
        Ruedi Rösti\
        Bahnhofsgasse 15\
        8957 Spreitenbach
    ]),
)

#show: lttr-preamble

#lorem(50)

#show: lttr-closing
