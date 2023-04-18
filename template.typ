// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let swissletter(
    debug: false,
    // TODO: think about making sender and receiver a dict and handle order and spacing.
    sender: (
        "John Doe",
        "Somestreet 15",
        "8000 Zürich",
        "Switzerland",
        "",
        "john@doe.org",
        "+41 79 345 34 34",
    ),
    receiver: (
        "Firma AG",
        "Somestreet 16",
        "8000 Zürich",
        "Switzerland",
    ),
    // TODO: find out if there is a way to compute todays date
    // TODO: support multiple date formats?
    letter_date: "21.03.2023",
    letter_place: "Zürich",
    title: "Ein Brief für die Ewigkeit",
    opening: "Sehr geehrte Damen und Herren",
    closing: "Freundliche Grüsse",
    signature: "John Doe",
    sender_position: (
        left: 2cm,
        top: 2cm,
    ),
    // TODO: put receiver bos in the right position for "standard" window letter
    // TODO: support different presets for various envelopes
    receiver_position: (
        left: 12cm,
        top: 4.7cm,
    ),
    content_start: 10cm,
    // NOTE: all the other spacings are independent of the margins
    margin: (
        top: 2cm,
        bottom: 2cm,
        x: 2cm,
    ),
    itemspacing: 1cm,
    // The paper's content.
    content
) = {


    // Set the body font.
    set text(font: "Source Sans Pro", size: 11pt)
    // set text(font: "Times new Roman", size: 12pt)

// Configure the page.
set page(
    paper: "a4",
    // The margins depend on the paper size.
    margin: (x: margin.x, top: margin.top, bottom: margin.bottom),
)

// sender
{
    place(
        dx: sender_position.left - margin.x,
        dy: sender_position.top - margin.top,
        rect(
            stroke: if debug {blue} else {none},
            {
                sender.join(linebreak())
            }
        )
    )
}

// receiver
{
    place(
        dx: receiver_position.left - margin.x,
        dy: receiver_position.top - margin.top,
        rect(
            height: 3cm,
            stroke: if debug {red} else {none},
            {
                receiver.join(linebreak())
            }
        )
    )
}

// spacing on first page
// TODO: is there a nicer way to handle vspace?
box(height: content_start - margin.top)

// content
{
    set par(justify: true)
        {
            letter_place
            text(", ")
            letter_date
            linebreak()
            box(height: itemspacing)
            text(
                weight: "bold",
                size: 1.0em,
                title
            )
            linebreak()
            box(height: itemspacing)
            opening
            linebreak()
            box(height: itemspacing)
            content
            linebreak()
            box(height: itemspacing)
            closing
            linebreak()
            box(height: itemspacing)
            signature

        }
}

}
