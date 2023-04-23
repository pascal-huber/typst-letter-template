// NOTE: lttr_data contains all the data to render the letter
#let lttr_data = state("letter", none)

// NOTE: lttr_max_dy keeps track of the largest offset dy (from the top margin) of
//   absolutely positioned content (sender and receiver fields) such that we
//   know how much vertical offset we need to add at the beginning of the letter
//   content
#let lttr_max_dy = state("lttr_max_dy", 0cm)
#let lttr_update_max_dy(dy) = {
    locate(loc => {
        lttr_max_dy.update(x => calc.max(x, dy))
    })
}

#let lttr_format_values = (
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
    receiver_return_to_position: (
        "DIN-5008-A": (left: 20mm + 5mm, top: 27mm),
        "DIN-5008-B": none,
        "C5-WINDOW-RIGHT": none,
    ),
    receiver_return_to_dimensions: (
        "DIN-5008-A": (height: 5mm, width: 85mm),
        "DIN-5008-B": none,
        "C5-WINDOW-RIGHT": none,
    ),
    receiver_remark_zone_position: (
        "DIN-5008-A": (left: 20mm + 5mm, top: 27mm + 5mm),
        "DIN-5008-B": (left: 20mm + 5mm, top: 45mm),
        "C5-WINDOW-RIGHT": none,
    ),
    receiver_remark_zone_dimensions: (
        "DIN-5008-A": (height: 12.7mm, width: 85mm),
        "DIN-5008-B": (height: 12.7mm + 5mm, width: 85mm),
        "C5-WINDOW-RIGHT": none,
    ),
    receiver_address_position: (
        "DIN-5008-A": (left: 20mm + 5mm, top: 27mm + 17.7mm),
        "DIN-5008-B": (left: 20mm + 5mm, top: 45mm + 17.7mm),
        "C5-WINDOW-RIGHT": (left: 120mm, top: 50mm)
    ),
    receiver_address_dimensions: (
        "DIN-5008-A": (height: 27.3mm, width: 85mm),
        "DIN-5008-B": (height: 27.3mm, width: 85mm),
        "C5-WINDOW-RIGHT": (height: 27.3mm, width: 85mm),
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

#let lttr_indicator_lines(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
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

#let lttr_closing(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
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

#let lttr_opening(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        if state.opening != none {
            v(state.opening.spacing)
            state.opening.content
        }
    })
    body
}

#let lttr_date_place(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        if state.date_place != none {
            set align(state.date_place.align)
            state.date_place.place
            if state.date_place.place != none and state.date_place.date != none {
                text(", ")
            }
            state.date_place.date
        }
    })
    body
}

#let lttr_title(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
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

#let lttr_sender(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        let sender_rect = rect(
            width: state.sender.width,
            inset: 0cm,
            outset: 0cm,
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
            (left: state._page.margin.left, top: state._page.margin.top) //state._page.margin.top)
        }
        place(
            dy: sender_position.top - state._page.margin.top,
            dx: sender_position.left - state._page.margin.left,
            sender_rect
        )
        style(styles => {
            lttr_update_max_dy(measure(sender_rect, styles).height + sender_position.top + state.settings.content_spacing)
        })
    })
    body
}

#let lttr_receiver_return_to(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        if state.receiver.return_to != none {
            place(
                dy: state.receiver.return_to_position.top - state._page.margin.top,
                dx: state.receiver.return_to_position.left - state._page.margin.left,
                rect(
                    width: state.receiver.return_to_dimensions.width,
                    height: 5mm, 
                    stroke: if state.debug {red} else {none},
                    inset: (left: 0mm, right: 0mm),
                    outset: 0cm,
                    {
                        set text(size: 0.8em)
                        underline(state.receiver.return_to)
                    }
                )
            )
        }
    })
    body
}


#let lttr_receiver_remark_zone(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        if state.receiver.remark_zone_position != none {
            place(
                dy: state.receiver.remark_zone_position.top - state._page.margin.top,
                dx: state.receiver.remark_zone_position.left - state._page.margin.left,
                rect(
                    width: state.receiver.remark_zone_dimensions.width,
                    height: state.receiver.remark_zone_dimensions.height,
                    stroke: if state.debug {green} else {none},
                    inset: (left: 0mm, right: 0mm, top: 0mm),
                    outset: 0pt,
                    {
                        set align(state.receiver.remark_zone_align)
                        set text(size: 0.8em)
                        state.receiver.remark_zone
                    }
                )
            )
        }
    })
    body
}

#let lttr_receiver_address(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        let receiver_rect = rect(
            width: state.receiver.address_dimensions.width,
            height: state.receiver.address_dimensions.height,
            stroke: if state.debug {purple} else {none},
            inset: (left: 0mm, right: 0mm, top: 0mm),
            outset: 0pt,
            state.receiver.address.join(linebreak()),
        )
        place(
            dy: state.receiver.address_position.top - state._page.margin.top,
            dx: state.receiver.address_position.left - state._page.margin.left,
            receiver_rect,
        )
        style(styles => {
            lttr_update_max_dy(
                measure(receiver_rect, styles).height
                 + state.receiver.address_position.top
                 + state.settings.content_spacing
                )
        })
    })
    body
}

#let lttr_receiver(body) = {
    show: lttr_receiver_return_to
    show: lttr_receiver_remark_zone
    show: lttr_receiver_address
    body
}

#let lttr_content_offset(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        v(lttr_max_dy.at(loc) - state._page.margin.top + state.settings.content_spacing)
        set par(justify: state.settings.justify_content)
        body
    })
}

#let lttr_preamble(body) = {
    show: lttr_sender
    show: lttr_receiver
    show: lttr_indicator_lines
    show: lttr_content_offset
    show: lttr_title
    show: lttr_opening
    body
}

#let lttr_init(
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
            top: 3cm,
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
    let receiver = (
        return_to_position: lttr_format_values.at("receiver_return_to_position").at(format),
        return_to_dimensions: lttr_format_values.at("receiver_return_to_dimensions").at(format),
        remark_zone_position: lttr_format_values.at("receiver_remark_zone_position").at(format),
        remark_zone_dimensions: lttr_format_values.at("receiver_remark_zone_dimensions").at(format),
        address_position: lttr_format_values.at("receiver_address_position").at(format),
        address_dimensions: lttr_format_values.at("receiver_address_dimensions").at(format),
        remark_zone_align: lttr_format_values.at("remark_zone_align").at(format),
        remark_zone: none,
        return_to: none,
        address: none,
        ..receiver
    )

    // merge return_to into remark_zone
    if receiver.return_to_position == none and receiver.return_to != none {
        receiver.remark_zone = {
            {
                underline(receiver.return_to)
                linebreak()
                receiver.remark_zone
            }
        }
        receiver.return_to = none
    }
    
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
            position: lttr_format_values.at("sender_position").at(format),
            width: lttr_format_values.at("sender_width").at(format),
            ..as_content_dict(sender),
        ),
        receiver: receiver,
        date_place: if date_place == none { none } else {(
            align: lttr_format_values.at("letter_date_place_align").at(format),
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
            show_puncher_mark: lttr_format_values.at("show_puncher_mark").at(format),
            fold_marks: lttr_format_values.at("fold_marks").at(format),
            ..indicator_lines,
        )},
    )
    // TODO: find out why I need to set page/text here
    set page(..data._page)
    set text(..data._text)
    style(styles => {
        lttr_update_max_dy(data.settings.min_content_spacing)
    })
    lttr_data.update(x => data)
    body
}

#let lttr_state() = {
    locate(loc => {
        lttr_data.at(loc);
    })
}