#let letter(
    debug: false,

    sender: (
        "Sender Firma AG",
        "Hauptstrasse 15",
        "1234 Freiburg",
        "Weitfortistan",
        "",
        "sender@company.com",
        "+41 79 345 34 34",
    ),
    receiver: (
        "Mr. Hans Receiver",
        "Bahnhofsstrasse 16",
        "1234 Nochvielweiterwegstadt",
    ),
    letter_date: "21.03.2023",
    letter_place: "Weitfortistan",
    title: "Briefe mit Typst erstellen",
    opening: "Sehr geehrte Damen und Herren",
    closing: "Freundliche Grüsse",
    signature: "John Doe",
    return_to: "Rücksendeaddresse",
    remark_zone: "Zusatz- und Vermerkzone",

    format: "DIN-5008-A",
    show_puncher_mark: none,
    show_fold_mark: none,
    sender_position: none,
    sender_width: none,
    receiver_position: none,
    receiver_width: none,
    content_start_min: 90mm, // TODO: find a good value for content_start_min
    show_return_to: none,
    show_remark_zone: none,

    // TODO: find out how scrlttr2 in latex handles spacing
    itemspacing: .5cm,
    margin: (
        top: 3cm,
        bottom: 3cm,
        left: 25mm,
        right: 20mm,
    ),

    // The letter's content.
    content
) = {

// Set the default values for the format (unless overridden by user)
let default_values = (
    sender_position: (
        "DIN-5008-A": (left: 125mm, top: 32mm),
        "DIN-5008-B": (left: 125mm, top: 50mm),
        "C5-WINDOW-RIGHT": (left: margin.left, top: margin.top)
    ),
    sender_width: (
        "DIN-5008-A": 75mm,
        "DIN-5008-B": 75mm,
        "C5-WINDOW-RIGHT": 85mm,
    ),
    receiver_position: (
        "DIN-5008-A": (left: 20mm, top: 27mm),
        "DIN-5008-B": (left: 20mm, top: 45mm),
        "C5-WINDOW-RIGHT": (left: 120mm, top: 50mm - 17.7mm) // minus return address and remark_zone
    ),
    receiver_width: (
        "DIN-5008-A": 85mm,
        "DIN-5008-B": 85mm,
        "C5-WINDOW-RIGHT": 75mm,
    ),
    show_return_to: (
        "DIN-5008-A": true,
        "DIN-5008-B": true, // FIXME: this is merged with remark_zone
        "C5-WINDOW-RIGHT": false,
    ),
    show_remark_zone: (
        "DIN-5008-A": true,
        "DIN-5008-B": true,
        "C5-WINDOW-RIGHT": false,
    ),
    show_fold_mark: (
        "DIN-5008-A": true,
        "DIN-5008-B": true,
        "C5-WINDOW-RIGHT": false,
    ),
    show_puncher_mark: (
        "DIN-5008-A": true,
        "DIN-5008-B": true,
        "C5-WINDOW-RIGHT": true,
    ),
)
if sender_position == none {
    sender_position = default_values.at("sender_position").at(format)
}
if sender_width == none {
    sender_width = default_values.at("sender_width").at(format)
}
if receiver_position == none {
    receiver_position = default_values.at("receiver_position").at(format)
}
if receiver_width == none {
    receiver_width = default_values.at("receiver_width").at(format)
}
if show_return_to == none {
    show_return_to = default_values.at("show_return_to").at(format)
}
if show_remark_zone == none {
    show_remark_zone = default_values.at("show_remark_zone").at(format)
}
if show_fold_mark == none {
    show_fold_mark = default_values.at("show_fold_mark").at(format)
}
if show_puncher_mark == none {
    show_puncher_mark = default_values.at("show_puncher_mark").at(format)
}

// Set the body font.
// TODO: check if we can override this
set text(font: "Source Sans Pro", size: 11pt)

// Configure the page.
set page(
    paper: "a4",
    margin: (
        left: margin.left,
        right: margin.right,
        top: margin.top,
        bottom: margin.bottom,
    ),
    header: locate(loc => if loc.page() != 1 {
        // TODO: set color variable
        set text(size: 0.9em, fill: rgb("#777777"))
        title
        line(length: 100%, stroke: 1pt + rgb("#777777"))
    }),
    numbering: "1/1"
)


if show_puncher_mark {
    place(
      dy: 148.5mm - margin.top,
      dx: 0cm - margin.left + 5mm,
      line(length: 0.6cm, stroke: 0.5pt + rgb("#777777"))
    )
}

if show_fold_mark {
    {
        place(
            dy: if format == "DIN-5008-A" {87mm} else {105mm} - margin.top,
            dx: 0cm - margin.left + 7mm,
            line(length: 0.4cm, stroke: 0.5pt + rgb("#777777"))
        )
        place(
            dy: if format == "DIN-5008-A" {87mm + 105mm} else {2*105mm} - margin.top,
            dx: 0cm - margin.left + 7mm,
            line(length: 0.4cm, stroke: 0.5pt + rgb("#777777"))
        )
    }
}

// sender
let sender_rect = rect(
    width: sender_width,
    stroke: if debug {blue} else {none},
    {
        if type(sender) == "content" {
            sender
        } else {
            sender.join(linebreak())
        }
    }
)
place(
    dy: sender_position.top - margin.top,
    dx: sender_position.left - margin.left,
    sender_rect
)

// return address (DIN 5008 Form A only)
if show_return_to {
place(
    dy: receiver_position.top - margin.top,
    dx: receiver_position.left - margin.left,
    rect(
        width: receiver_width,
        height: 5mm,
        stroke: if debug {red} else {none},
        {
            set text(size: 0.75em)
            underline(return_to)
        }
    )
)
}
// remark zone (not quite sure what this is for tbh)
if show_remark_zone {
place(
    dy: receiver_position.top - margin.top + 5mm,
    dx: receiver_position.left - margin.left,
    rect(
        width: receiver_width,
        height: 12.7mm,
        stroke: if debug {green} else {none},
        remark_zone
    )
)
}
// receiver address
place(
    dy: receiver_position.top - margin.top + 5mm + 12.7mm,
    dx: receiver_position.left - margin.left,
    rect(
        width: receiver_width,
        height: 27.3mm,
        stroke: if debug {purple} else {none},
        receiver.join(linebreak())
    )
)


// spacing to content
style(styles => {
    v(calc.max(
        45mm + receiver_position.top - margin.top,
        measure(sender_rect, styles).height + sender_position.top - margin.top,
        content_start_min - margin.top,
    ))
})
v(8.46mm)

// content
{
    set par(justify: true)
        {
            letter_place
            text(", ")
            letter_date
            v(itemspacing)
            text(
                weight: "bold",
                size: 1.0em,
                title
            )
            v(itemspacing)
            opening
            linebreak()
            linebreak()
            content
            v(itemspacing)
            closing
            v(itemspacing)
            signature

        }
}

}
