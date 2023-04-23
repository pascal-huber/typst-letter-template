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

#let lttr_defaults = (
    _page: (
        paper: "a4",
        margin: (
            top: 3cm,
            bottom: 3cm,
            left: 25mm,
            right: 20mm,
        ),
        header: {
            locate(loc => if loc.page() != 1 {
                let state = lttr_data.at(loc);
                set text(size: 0.9em, fill: rgb("#777777"))
                state.title.content
                line(length: 100%, stroke: 1pt + rgb("#777777"))
            })
        },
        numbering: "1/1",
    ),
    _text: (
        font: "Helvetica", 
        size: 11pt,
    ),
    settings: (
        min_content_spacing: 100mm, // TODO: find a good value for min_content_spacing
        content_spacing: 8.46mm, // NOTE: DIN 5008 but okay for all 
        justify_content: true,
    ),
    receiver: (
        remark_zone: none,
        return_to: none,
        address: none,
    ),
    date_place: (
        place: none,
        date: none,
    ),
    title: (
        content: none,
        spacing: 2mm,
    ),
    opening: (
        spacing: 2mm,
        content: none,
    ),
    closing: (
        spacing: 5mm,
        content: none,
    ),
    signature: (
        spacing: 5mm,
        content: none,
    )
)

#let lttr_format_defaults = (
    "DIN-5008-A": (
        sender: (
            position: (left: 125mm, top: 32mm),
            width: 75mm,
        ),
        receiver: (
            return_to_position: (left: 20mm + 5mm, top: 27mm),
            return_to_dimensions: (height: 5mm, width: 85mm),
            remark_zone_position: (left: 20mm + 5mm, top: 27mm + 5mm),
            remark_zone_dimensions: (height: 12.7mm, width: 85mm),
            remark_zone_align: top,
            address_position: (left: 20mm + 5mm, top: 27mm + 17.7mm),
            address_dimensions: (height: 27.3mm, width: 85mm),
            address_align_v: top,
        ),
        indicator_lines: (
            show_puncher_mark: true,
            fold_marks: (87mm, 87mm+105mm),
        ),
        date_place: (
            align: right,
        )
    ),
    "DIN-5008-B": (
        sender: (
            position: (left: 125mm, top: 50mm),
            width: 75mm,
        ),
        receiver: (
            return_to_position: none,
            remark_zone_position: (left: 20mm + 5mm, top: 45mm),
            remark_zone_dimensions: (height: 12.7mm + 5mm, width: 85mm),
            remark_zone_align: bottom,
            address_position: (left: 20mm + 5mm, top: 45mm + 17.7mm),
            address_dimensions: (height: 27.3mm, width: 85mm),
            address_align_v: top,
        ),
        indicator_lines: (
            show_puncher_mark: true,
            fold_marks: (87mm, 87mm+105mm),
        ),
        date_place: (
            align: right,
        )
    ),
    "C5-WINDOW-RIGHT": (
        sender: (
            position: none,
            width: 75mm, // TODO: is this okay, or 85mm?
        ),
        receiver: (
            return_to_position: none,
            remark_zone_position: none,
            address_position: (left: 120mm, top: 50mm),
            address_dimensions: (height: 30mm, width: 75mm),
            address_align_v: horizon,
        ),
        indicator_lines: (
            show_puncher_mark: true,
            // TODO: remove?
            fold_marks: (),
        ),
        date_place: (
            align: left,
        )
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
        if state.receiver.return_to_position != none {
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
                    inset: (left: 0mm, right: 0mm),
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
            {
                set align(state.receiver.address_align_v)
                state.receiver.address.join(linebreak())
            },
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
    show: lttr_date_place
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
    let format_defaults = lttr_format_defaults.at(format)
    let data = (
        debug: debug,
        format: format,
        _page: (
            :..lttr_defaults._page,
            .._page,
        ),
        _text: (
            :..lttr_defaults._text,
            .._text,
        ),
        settings: (
            :..lttr_defaults.settings,
            ..settings,
        ),
        sender: (
            :..format_defaults.sender,
            ..as_content_dict(sender),
        ),
        receiver: (
            :..lttr_defaults.receiver,
            ..format_defaults.receiver,
            ..receiver
        ),
        date_place: if date_place == none { none } else {(
            :..lttr_defaults.date_place,
            ..format_defaults.date_place,
            ..as_content_dict(date_place),
        )},
        title: if title == none { none } else {(
            :..lttr_defaults.title,
            ..as_content_dict(title),
        )},
        opening: if opening == none { none } else {(
            :..lttr_defaults.opening,
            ..as_content_dict(opening),
        )},
        closing: if closing == none { none } else {(
            :..lttr_defaults.closing,
            ..as_content_dict(closing),
        )},
        signature: if signature == none { none } else {(
            :..lttr_defaults.signature,
            ..as_content_dict(signature),
        )},
        indicator_lines: if indicator_lines == none { none } else {(
            :..format_defaults.indicator_lines,
            ..indicator_lines,
        )},
    )
    // merge return_to into remark_zone
    if data.receiver.return_to_position == none and data.receiver.return_to != none {
        data.receiver.remark_zone = {
            {
                underline(data.receiver.return_to)
                linebreak()
                data.receiver.remark_zone
            }
        }
        receiver.return_to = none
    }
    // TODO: find out why moving set page causes a page break
    set page(..data._page)
    set text(..data._text)
    lttr_data.update(x => data)
    style(styles => {
        lttr_update_max_dy(data.settings.min_content_spacing)
    })
    body
}

#let lttr_state() = {
    locate(loc => {
        lttr_data.at(loc);
    })
}