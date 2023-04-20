#let get_val(name, user_page, default_page, default_value) = {
    if user_page.keys().find({x => x == name}) != none {
        user_page.at(name)
    } else if default_page.keys().find({x => x == name}) != none {
        default_page.at(name)
    } else {
        default_value
    }
}

#let letter(

    // Document settings
    debug: false,
    _page: (:), // NOTE: hack to override page values
    format: none,
    margin: (
        top: 3cm,
        bottom: 3cm,
        left: 25mm,
        right: 20mm,
    ),

    // Sender Field
    sender: none,
    sender_position: none,
    sender_width: none,

    // Receiver Field
    show_return_to: none,
    return_to: none,
    show_remark_zone: none,
    remark_zone: none,
    remark_zone_align: none,
    receiver: none,
    receiver_position: none,
    receiver_width: none,

    // Document start
    content_start_min: 90mm, // TODO: find a good value for content_start_min

    // Date and place line before Title
    letter_date_place_line: none, // TODO: add to README
    letter_date: none,
    letter_place: none,
    letter_date_place_align: none, // TODO: add to README

    // Document Start
    title_spacing: 2mm,
    title: "Briefe mit Typst erstellen",
    opening_spacing: 2mm,
    opening: "Sehr geehrte Damen und Herren,",

    // Document End
    closing_spacing: 5mm,
    closing: "Freundliche Grüsse",
    signature_spacing: 8mm,
    signature: none,

    // Indicator Lines
    show_puncher_mark: none,
    show_fold_mark: none,

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
            "DIN-5008-A": (left: 20mm + 5mm, top: 27mm), // TODO: unsure about those 5mm
            "DIN-5008-B": (left: 20mm + 5mm, top: 45mm), // TODO: unsure about those 5mm
            "C5-WINDOW-RIGHT": (left: 120mm, top: 50mm - 17.7mm) // minus return address and remark_zone
        ),
        receiver_width: (
            "DIN-5008-A": 85mm,
            "DIN-5008-B": 85mm,
            "C5-WINDOW-RIGHT": 75mm,
        ),
        show_return_to: (
            "DIN-5008-A": true,
            "DIN-5008-B": false,
            "C5-WINDOW-RIGHT": false,
        ),
        show_remark_zone: (
            "DIN-5008-A": true,
            "DIN-5008-B": true,
            "C5-WINDOW-RIGHT": false,
        ),
        remark_zone_align: (
            "DIN-5008-A": top,
            "DIN-5008-B": bottom,
            "C5-WINDOW-RIGHT": top,
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
        letter_date_place_align: (
            "DIN-5008-A": right,
            "DIN-5008-B": right,
            "C5-WINDOW-RIGHT": left,
        )
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
    if remark_zone_align == none {
        remark_zone_align = default_values.at("remark_zone_align").at(format)
    }
    if show_fold_mark == none {
        show_fold_mark = default_values.at("show_fold_mark").at(format)
    }
    if show_puncher_mark == none {
        show_puncher_mark = default_values.at("show_puncher_mark").at(format)
    }
    if letter_date_place_align == none {
        letter_date_place_align = default_values.at("letter_date_place_align").at(format)
    }

    // Set the body font.
    // TODO: check if we can override this
    set text(font: "Source Sans Pro", size: 10pt)

    // FIXME: this is a nasty hack because we can not simple set the page on the
    // caller side. Being able to query page properties could maybe help making
    // this hack a bit nicer (https://github.com/typst/typst/issues/763).
    let default_page = (
        paper: "a4",
        margin: (
            left: margin.left,
            right: margin.right,
            top: margin.top,
            bottom: margin.bottom,
        ),
        header: {
            locate(loc => if loc.page() != 1 {
                // TODO: set color variable
                set text(size: 0.9em, fill: rgb("#777777"))
                title
                line(length: 100%, stroke: 1pt + rgb("#777777"))
            })
        },
        numbering: none,
    )
    set page(
        paper: get_val("paper", _page, default_page, "a4"),
        // NOTE: height/width can not be set like as they don't accept "none"
        // width: get_val("width", _page, default_page, none), height:
        // get_val("height", _page, default_page),
        flipped: get_val("flipped", _page, default_page, false),
        margin: get_val("margin", _page, default_page, auto),
        columns: get_val("columns", _page, default_page, 1),
        fill: get_val("fill", _page, default_page, none),
        numbering: get_val("numbering", _page, default_page, none),
        number-align: get_val("number-align", _page, default_page, center),
        header: get_val("header", _page, default_page, none),
        // FIXME: find the default value for header-ascent
        // header-ascent: get_val("header-ascent", _page, default_page, none),
        footer: get_val("footer", _page, default_page, none),
        // FIXME: find the default value for footer-descent
        // footer-descent: get_val("footer-descent", _page, default_page, none),
        background: get_val("background", _page, default_page, none),
        foreground: get_val("foreground", _page, default_page, none),
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
                inset: (bottom: 0pt),
                {
                    set text(size: 0.8em)
                    underline(return_to)
                }
            )
        )
    }

    // remark zone
    if show_remark_zone {
        place(
            dy: receiver_position.top - margin.top + if show_return_to {5mm} else {0mm},
            dx: receiver_position.left - margin.left,
            rect(
                width: receiver_width,
                height: 12.7mm + if show_return_to {0mm} else {5mm},
                stroke: if debug {green} else {none},
                {
                    set align(remark_zone_align)
                    set text(size: 0.8em)
                    if show_return_to == false and return_to != none {
                        underline(return_to)
                        linebreak()
                    }
                    remark_zone
                }
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
            set align(letter_date_place_align)
            if letter_date_place_line == none {
                if letter_place != none {
                    letter_place
                }
                if letter_place != none and letter_date != none {
                    text(", ")
                }
                if letter_date != none {
                    letter_date
                }
            } else {
                letter_date_place_line
            }
        }
        v(title_spacing)
        text(
            weight: "bold",
            size: 1.0em,
            title
        )
        v(opening_spacing)
        opening
        linebreak()
        linebreak()
        content
        v(closing_spacing)
        closing
        v(signature_spacing)
        signature
    }
}
