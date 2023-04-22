// NOTE: letter_data contains all the data to render the letter
#let letter_data = state("letter", none)

// NOTE: max_dy keeps track of the largest offset dy (from the top margin) of
//   absolutely positioned content (sender and receiver fields) such that we
//   know how much vertical offset we need to add at the beginning of the letter
//   content
#let max_dy = state("max_dy", 0cm)
#let update_max_dy(dy) = {
    locate(loc => {
        max_dy.update(x => calc.max(x, dy))
    })
}

#let default_values = (
    sender_position: (
        "DIN-5008-A": (left: 125mm, top: 32mm),
        "DIN-5008-B": (left: 125mm, top: 50mm),
        "C5-WINDOW-RIGHT": none, // NOTE: none means margin.left/margin.top
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
    remark_zone_align: (
        "DIN-5008-A": top,
        "DIN-5008-B": bottom,
        "C5-WINDOW-RIGHT": top,
    ),
    return_to_merge: (
        "DIN-5008-A": false,
        "DIN-5008-B": true,
        "C5-WINDOW-RIGHT": true,
    ),
    // TODO: remove show_puncher_mark from format options
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

#let indicator_lines_t(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        // TODO: refactor this
        if state.indicator_lines != none {
            if state.indicator_lines.show_puncher_mark {
                place(
                    dy: 50% - 0.5 * state._page.margin.top + 0.5 * state._page.margin.bottom,
                    dx: 0cm - state._page.margin.left + 9mm,
                    line(
                        length: 0.4cm, 
                        stroke: 0.25pt + rgb("#777777")
                    )
                )
            }
            if type(state.indicator_lines.fold_marks) == "array" {
                for mark in state.indicator_lines.fold_marks {
                    place(
                        dy: mark - state._page.margin.top,
                        dx: 0cm - state._page.margin.left + 9mm,
                        line(
                            length: 0.2cm, 
                            stroke: 0.25pt + rgb("#777777")
                        )
                    )
                }
            }
        }
    })
    body
}

#let closing(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        if  state.closing.content != none {
            v(state.closing.spacing)
            state.closing.content
        }
        if state.signature.content != none {
            v(state.signature.spacing)
            state.signature.content
        }
    })
    body
}

#let opening(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        if state.opening != none {
            v(state.opening.spacing)
            state.opening.content
        }
    })
    body
}

#let date_place(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        if state.date_place != none {
            set align(state.date_place.align)
            state.date_place.place
            if state.date_place.place != none and state.date_place.date != none {
                text(", ")
            }
            state.date_place.at("date")
        }
    })
    body
}

#let title(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        if state.title != none {
            v(state.title.spacing)
            text(
                weight: "bold",
                size: 1.0em,
                state.title.content
            )
        }
    })
    body
}

#let sender_t(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        let sender_rect = rect(
            width: state.sender.width,
            stroke: if state.debug {blue} else {none},
            {
                if type(state.sender.content) == "content" {
                    state.sender.content
                } else {
                    state.sender.content.join(linebreak())
                }
            }
        )
        let sender_position = if state.sender.position != none {
            state.sender.position
        } else {
            (left: state._page.margin.left, top: state._page.margin.top)
        }
        place(
            dy: sender_position.top - state._page.margin.top,
            dx: sender_position.left - state._page.margin.left,
            sender_rect
        )
        style(styles => {
            update_max_dy(measure(sender_rect, styles).height + sender_position.top + state.settings.content_spacing)
        })
    })
    body
}

#let receiver_t(body) = {
    locate(loc => {
        let state = letter_data.at(loc);
        let receiver = state.receiver

        // NOTE: Merge return_to and remark_zone
        // TODO: create parameters for return_to formatting
        if receiver.return_to_merge == true and receiver.return_to != none {
            receiver.remark_zone = {
                {
                    set text(size: 0.8em)
                    underline(receiver.return_to)
                }
                receiver.remark_zone
            }
            receiver.return_to = none
        } else {
            receiver.return_to = {
                set text(size: 0.8em)
                underline(receiver.return_to)
            }
        }

        // receiver return_to
        if receiver.return_to_merge == false {
            place(
                dy: receiver.position.top - state._page.margin.top,
                dx: receiver.position.left - state._page.margin.left,
                rect(
                    width: receiver.width,
                    height: 5mm, 
                    stroke: if state.debug {red} else {none},
                    inset: (bottom: 0pt),
                    receiver.return_to
                )
            )
        }

        // receiver remark_zone
        place(
            // TODO: refactor this
            dy: receiver.position.top - state._page.margin.top + if receiver.return_to != none {5mm} else {0mm},
            dx: receiver.position.left - state._page.margin.left,
            rect(
                width: receiver.width,
                height: 12.7mm + if receiver.return_to != none {0mm} else {5mm},
                stroke: if state.debug {green} else {none},
                {
                    set align(receiver.remark_zone_align)
                    set text(size: 0.8em)
                    if receiver.return_to != none {
                        underline(receiver.return_to)
                        linebreak()
                    }
                    receiver.remark_zone
                }
            )
        )

        // receiver content
        let receiver_rect = rect(
            width: receiver.width,
            height: 27.3mm,
            stroke: if state.debug {purple} else {none},
            receiver.content.join(linebreak())
        )
        place(
            dy: receiver.position.top - state._page.margin.top + 5mm + 12.7mm,
            dx: receiver.position.left - state._page.margin.left,
            receiver_rect,
        )
        style(styles => {
            update_max_dy(measure(receiver_rect, styles).height + state.receiver.position.top + state.settings.content_spacing)
        })
    })
    body
}

#let init(
    debug: false,
    format: "DIN-5008-B",
    _page: (:),
    _text: (:),
    settings: (:),
    indicator_lines: (:),
    sender: (:),
    receiver: (:),
    title: (:),
    date_place: (:),
    opening: (:),
    closing: (:),
    signature: (:),
    body
) = {
    let as_content_dict = (it) => {
        if type(it) == "string" or type(it) == "content" {
            (content: it)
        } else {
            it
        }
    }
    _page = (
        paper: "a4", // TODO: maybe put paper in format defaults?
        margin: ( // TODO: maybe put margin in format defaults?
            top: 4cm,
            bottom: 3cm,
            left: 25mm,
            right: 20mm,
        ),
        header: {
            locate(loc => if loc.page() != 1 {
                set text(size: 0.9em, fill: rgb("#777777"))
                title
                line(length: 100%, stroke: 1pt + rgb("#777777"))
            })
        },
        numbering: none,
        .._page,
    )
    
    let data = (
        debug: debug,
        format: format,
        _page: _page,
        _text: (
            font: "Helvetica", 
            size: 12pt,
            .._text,
        ),
        settings: (
            min_content_spacing: 100mm, // TODO: find a good value for min_content_spacing
            content_spacing: 8.46mm, // NOTE: DIN 5008 but okay for all 
            justify_content: true,
            ..settings,
        ),
        sender: (
            position: default_values.at("sender_position").at(format),
            width: default_values.at("sender_width").at(format),
            ..as_content_dict(sender),
        ),
        receiver: (
            position: default_values.at("receiver_position").at(format),
            width: default_values.at("receiver_width").at(format),
            remark_zone_align: default_values.at("remark_zone_align").at(format),
            remark_zone: none,
            return_to: none,
            return_to_merge: default_values.at("remark_zone_align").at(format),
            content: none,
            ..receiver
        ),
        date_place: if date_place == none { none } else {(
            align: default_values.at("letter_date_place_align").at(format),
            content: none,
            place: none,
            date: none,
            ..as_content_dict(date_place),
        )},
        title: if title == none { none } else {(
            content: none,
            spacing: 2mm,
            ..as_content_dict(title),
        )},
        opening: if opening == none { none } else {(
            spacing: 2mm,
            content: none,
            ..as_content_dict(opening),
        )},
        closing: if closing == none { none } else {(
            spacing: 5mm,
            content: none,
            ..as_content_dict(closing),
        )},
        signature: if signature == none { none } else {(
            spacing: 5mm,
            content: none,
            ..as_content_dict(signature),
        )},
        indicator_lines: if indicator_lines == none { none } else {(
            show_puncher_mark: default_values.at("show_puncher_mark").at(format),
            fold_marks: default_values.at("fold_marks").at(format),
            ..indicator_lines,
        )},
    )
    set page(..data._page)
    set text(..data._text)
    style(styles => {
        update_max_dy(data.settings.min_content_spacing)
    })
    letter_data.update(x => data)
    show: sender_t
    show: receiver_t
    show: indicator_lines_t.with()
    locate(loc => {
        v(max_dy.at(loc) - data._page.margin.top + data.settings.content_spacing)
        set par(justify: data.settings.justify_content)
    })
    body
}