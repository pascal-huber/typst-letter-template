#let letter(

    // Letter Settings
    debug: false,
    _page: (:),
    _text: (:),
    format: "DIN-5008-B",
    // TODO: Maybe put margin into the defaults for each format.
    margin: (
        top: 4cm,
        bottom: 3cm,
        left: 25mm,
        right: 20mm,
    ),
    content_start_min: 100mm, // TODO: find a good value for content_start_min
    content_spacing: 8.46mm, // NOTE: DIN 5008 but okay for all 
    justify_content: true,

    // Indicator Lines
    show_puncher_mark: true,
    // NOTE: `fold_marks: (1cm)` is invalid as `(1cm)` has type length use
    //  `fold_marks: (1cm,)` instead
    // NOTE: "none_at_all" allows the user to set it to `none` or `()` to
    //  disable it.
    fold_marks: "none_at_all", 

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

    // Date and place line before Title
    show_date_place: true,
    letter_date_place_line: none,
    letter_date: none,
    letter_place: none,
    letter_date_place_align: none,

    // Document Start
    show_title: true,
    title_spacing: 2mm,
    title: "Briefe mit Typst erstellen",
    show_opening: true,
    opening_spacing: 2mm,
    opening: "Sehr geehrte Damen und Herren,",
    body_spacing: 2mm,

    // Document End
    show_closing: true,
    closing_spacing: 5mm,
    closing: "Freundliche Grüsse",
    show_signature: true,
    signature_spacing: 8mm,
    signature: none,

    // The letter body.
    body
) = {

    // #####################################################
    // Default Values Definition
    // #####################################################
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
            "DIN-5008-A": (left: 20mm + 5mm, top: 27mm), // NOTE: 5mm are "padding"
            "DIN-5008-B": (left: 20mm + 5mm, top: 45mm), // NOTE: 5mm are "padding"
            "C5-WINDOW-RIGHT": (left: 120mm, top: 50mm - 17.7mm) // NOTE: 17.7mm because no return_to and remark_zone
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
        show_puncher_mark: (
            "DIN-5008-A": true,
            "DIN-5008-B": true,
            "C5-WINDOW-RIGHT": true,
        ),
        fold_marks: (
            "DIN-5008-A": (87mm, 87mm+105mm),
            "DIN-5008-B": (105mm, 2*105mm),
            "C5-WINDOW-RIGHT": (),
        ),
        letter_date_place_align: (
            "DIN-5008-A": right,
            "DIN-5008-B": right,
            "C5-WINDOW-RIGHT": left,
        ),
    )

    // #####################################################
    // Set Default Format Values
    // #####################################################
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
    if show_puncher_mark == none {
        show_puncher_mark = default_values.at("show_puncher_mark").at(format)
    }
    if fold_marks == "none_at_all" {
        fold_marks = default_values.at("fold_marks").at(format)
    }
    if letter_date_place_align == none {
        letter_date_place_align = default_values.at("letter_date_place_align").at(format)
    }

    // #####################################################
    // Set Page
    // #####################################################
    set page(
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
    set page(.._page)

    // #####################################################
    // Set Text
    // #####################################################
    set text(
        font: "Helvetica", 
        size: 12pt,
    );
    set text(.._text)

    // #####################################################
    // Puncher Mark
    // #####################################################
    if show_puncher_mark {
        place(
            dy: 50% - 0.5*margin.top + 0.5*margin.bottom,
            dx: 0cm - margin.left + 9mm,
            line(
                length: 0.4cm, 
                stroke: 0.25pt + rgb("#777777")
            )
        )
    }

    // #####################################################
    // Fold Marks
    // #####################################################
    if type(fold_marks) == "array" {
        for mark in fold_marks {
            place(
                dy: mark - margin.top,
                dx: 0cm - margin.left + 9mm,
                line(
                    length: 0.2cm, 
                    stroke: 0.25pt + rgb("#777777")
                )
            )
        }
    }

    // #####################################################
    // Sender
    // #####################################################
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

    // #####################################################
    // Receiver - Return To
    // #####################################################
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

    // #####################################################
    // Receiver - Remark Zone
    // #####################################################
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

    // #####################################################
    // Receiver - Address
    // #####################################################
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

    // #####################################################
    // Spacing To Content
    // #####################################################
    style(styles => {
        v(calc.max(
            45mm + receiver_position.top,
            measure(sender_rect, styles).height + sender_position.top,
            content_start_min,
        ) - margin.top + content_spacing)
    })

    // #####################################################
    // Content
    // #####################################################
    {
        set par(justify: justify_content)
        if show_date_place {
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
        if show_title {
            v(title_spacing)
            text(
                weight: "bold",
                size: 1.0em,
                title
            )
        }
        if show_opening {
            v(opening_spacing)
            opening
        }
        v(body_spacing)
        body
        if show_closing {
            v(closing_spacing)
            closing
        }
        if show_signature {
            v(signature_spacing)
            signature
        }
    }
}
