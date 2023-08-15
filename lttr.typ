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

// takes an array of dictionaries and merges them where later dictionaries
// overwrite the values of the ones before
#let lttr_deep_dict_merge(dictionaries) = {
    if dictionaries.len() == 0 {
        return (:)
    } else if dictionaries.len() == 1 {
        return dictionaries.first()
    }

    // helper function to deeply merge d1 and d2 (d2 overwrites d1)
    let deep_merge(d1, d2) = {
        let keys = (
            ..d1.keys(),
            ..d2.keys(),
        )
        for k in keys {
            if d1.keys().contains(k) and d2.keys().contains(k) {
                let d1_val = d1.at(k)
                let d2_val = d2.at(k)
                if type(d1_val) == "dictionary" and type(d2_val) == "dictionary" {
                    // both d1 and d2 contain key k
                    // both d1.at(k) and d2.at(k) are dictionaries, merge them
                    d2.insert(k, deep_merge(d1_val, d2_val))
                } 
            } else if d1.keys().contains(k) {
                //  key only exists in d1, add it to d2
                d2.insert(k, d1.at(k))
            }
        }
        return d2
    }

    let result = none
    for dict in dictionaries {
        if result == none {
            result = dict
        } else {
            result = deep_merge(result, dict)
        }
    }
    return result
}

#let lttr_fmt(it) = {
    if type(it) == "array" {
        let ctr = 0
        for line in it {
            lttr_fmt(line)
            if ctr != it.len() {
                linebreak()
            }
            ctr += 1
        } 
    } else {
        [#it]
    }
}

#let lttr_defaults = (
    _page: (
        margin: (
            top: 3cm,
            bottom: 3cm,
            left: 25mm,
            right: 20mm,
        ),
        numbering: "1/1",
    ),
    _text: (
        size: 11pt,
    ),
    settings: (
        // NOTE: this is a DIN 5008 setting (but okay for all)
        min_content_offset: 90mm,
        content_spacing: 8.46mm, 
        justify_content: true,
    ),
    sender: (
        content: none,
        fmt: (it) => {
            lttr_fmt(it.content)
        },
    ),
    return_to: (
        content: none,
        fmt: (it) => {
            text(size: 0.8em)[#underline({
                lttr_fmt(it.content)
            })]
        },
    ),
    remark_zone: (
        content: none,
        fmt: (it) => {
            set align(it.align)
            text(size: 0.8em)[
                lttr_fmt(it.content)
            ]
        },
    ),
    receiver: (
        content: none,
        fmt: (it) => {
            lttr_fmt(it.content)
        },
        spacing: 0.65em / 2, // NOTE: half the default spacing between lines
    ),
    date_place: (
        date: none,
        place: none,
    ),
    horizontal_table: (
        content: none,
        fmt: (header, content) => {
            set par(leading: 0.4em)
            text(size: 0.8em)[
                #lttr_fmt(header)
                #linebreak()
            ]
            lttr_fmt(content)
        },
        spacing: 8.46mm // NOTE: like DIN-5008-B spacing
    ),
    title: (
        content: none,
        spacing: 2mm,
    ),
    opening: (
        content: none,
        spacing: 2mm,
    ),
    closing: (
        content: none,
        spacing: 5mm,
    ),
    signature: (
        content: none,
        spacing: 5mm,
    )
)

#let lttr_format_defaults = (
    "DIN-5008-A": (
        _page: (
            paper: "a4",
        ),
        _text: (
            lang: "DE"
        ),
        sender: (
            position: (left: 125mm, top: 32mm),
            width: 75mm,
        ),
        return_to: (
            position: (left: 20mm + 5mm, top: 27mm),
            dimensions: (height: 5mm, width: 85mm),
        ),
        remark_zone: (
            position: (left: 20mm + 5mm, top: 27mm + 5mm),
            dimensions: (height: 12.7mm, width: 85mm),
            align: top,
        ),
        receiver: (
            position: (left: 20mm + 5mm, top: 27mm + 17.7mm),
            dimensions: (height: 27.3mm, width: 85mm),
            align: top,
        ),
        indicator_lines: (
            show_puncher_mark: false,
            fold_marks: (87mm, 87mm+105mm),
        ),
        date_place: (
            align: right,
        )
    ),
    "DIN-5008-B": (
        _page: (
            paper: "a4",
        ),
        _text: (
            lang: "DE"
        ),
        sender: (
            position: (left: 125mm, top: 50mm),
            width: 75mm,
        ),
        return_to: (
            // NOTE: this position overlapps with remark_zone DIN-5008-B does
            //   not have a dedicated return_to field. If both return_to and
            //   remark_zone have a non-none content, then the remark_zone field
            //   has to be recuced by return_to.dimensions.height
            position: (left: 20mm + 5mm, top: 45mm),
            dimensions: (height: 5mm, width: 85mm),
        ),
        remark_zone: (
            position: (left: 20mm + 5mm, top: 45mm),
            dimensions: (height: 12.7mm + 5mm, width: 85mm),
            align: bottom,
        ),
        receiver: (
            position: (left: 20mm + 5mm, top: 45mm + 17.7mm),
            dimensions: (height: 27.3mm, width: 85mm),
            align: top,
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
        _page: (
            paper: "a4",
        ),
        _text: (
            lang: "CH",
        ),
        sender: (
            position: none,
            width: 75mm, // TODO: is this okay, or 85mm?
        ),
        return_to: (
            position: none,
        ),
        remark_zone: (
            position: none,
        ),
        receiver: (
            align: horizon,
            position: (left: 120mm, top: 50mm),
            dimensions: (height: 30mm, width: 75mm),
        ),
        indicator_lines: (
            fold_marks: (),
            show_puncher_mark: true,
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
                        stroke: 0.5pt + rgb("#777777")
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
                            stroke: 0.5pt + rgb("#777777")
                        )
                    )
                }
            }
        }
    })
    body
}

#let lttr_horizontal_table(
    body
) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        if state.horizontal_table.content != none {
            let content = ()
            let ctr = 0
            for entry in state.horizontal_table.content {
                ctr += 1
                content.push({
                    state.horizontal_table.at("fmt")(
                        entry.first(),
                        entry.last(),
                    )
                })
            }
            if ctr > 0 {
                let column_width = 100% / ctr
                let columns = ()
                while ctr > 0 {
                    columns.push(column_width)
                    ctr -= 1
                }
                let tbl = table(
                    columns: columns,
                    inset: 0pt,
                    stroke: if state.debug {red} else {none},
                    align: (left, top),
                    ..content
                )
                let table_rect = rect(
                    outset: 0pt,
                    inset: 0pt,
                    tbl
                )
                let dy = lttr_max_dy.at(loc) + state.horizontal_table.spacing
                place(
                    dy: dy,
                    {
                        table_rect
                        layout(size => style(styles => {
                            let (height,) = measure(
                                block(width: size.width, table_rect),
                                styles
                            )
                            lttr_update_max_dy(height + dy)
                        }))
                    }
                )
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
            inset: 0pt,
            outset: 0pt,
            stroke: if state.debug {blue} else {none},
            {
                state.sender.at("fmt")(state.sender)
            }
        )
        let sender_position = if state.sender.position != none {
            state.sender.position
        } else {
            (left: state._page.margin.left, top: state._page.margin.top) 
        }
        let dy = sender_position.top - state._page.margin.top
        let dx = sender_position.left - state._page.margin.left
        place(
            dy: dy,
            dx: dx,
            sender_rect
        )
        style(styles => {
            lttr_update_max_dy(measure(sender_rect, styles).height + dy)
        })
    })
    body
}

#let lttr_receiver_return_to(body) = {
    locate(loc => {
        let state = lttr_data.at(loc);
        if state.return_to.position != none {
            let dy = state.return_to.position.top - state._page.margin.top
            let dx = state.return_to.position.left - state._page.margin.left
            place(
                dy: dy,
                dx: dx,
                rect(
                    width: state.return_to.dimensions.width,
                    height: 5mm, 
                    stroke: if state.debug {red} else {none},
                    inset: (left: 0mm, right: 0mm),
                    outset: 0cm,
                    {
                        state.return_to.at("fmt")(state.return_to)
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
        if state.remark_zone.position != none {
            let dy = state.remark_zone.position.top - state._page.margin.top
            let dx = state.remark_zone.position.left - state._page.margin.left
            place(
                dy: dy,
                dx: dx,
                rect(
                    width: state.remark_zone.dimensions.width,
                    height: state.remark_zone.dimensions.height,
                    stroke: if state.debug {green} else {none},
                    inset: (left: 0mm, right: 0mm),
                    outset: 0pt,
                    {
                        state.remark_zone.at("fmt")(state.remark_zone)
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
            width: state.receiver.dimensions.width,
            height: state.receiver.dimensions.height,
            stroke: if state.debug {purple} else {none},
            inset: (left: 0mm, right: 0mm, top: 0mm),
            outset: 0pt,
            {
                v(state.receiver.spacing)
                state.receiver.at("fmt")(state.receiver)
            },
        )
        let dy = state.receiver.position.top - state._page.margin.top
        let dx = state.receiver.position.left - state._page.margin.left
        place(
            dy: dy,
            dx: dx,
            receiver_rect,
        )
        style(styles => {
            lttr_update_max_dy(
                measure(receiver_rect, styles).height
                 + dy
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
        v(lttr_max_dy.at(loc) + state.settings.content_spacing)
        set par(justify: state.settings.justify_content)
        body
    })
}

#let lttr_preamble(body) = {
    show: lttr_sender
    show: lttr_receiver
    show: lttr_horizontal_table
    show: lttr_indicator_lines
    show: lttr_content_offset
    show: lttr_date_place
    show: lttr_title
    show: lttr_opening
    body
}

#let lttr_init(
    _page: (:),
    _text: (:),
    debug: false,
    format: "DIN-5008-A",
    settings: (:),
    indicator_lines: (:),
    author: (),
    sender: (:),
    return_to: (:),
    remark_zone: (:),
    receiver: (:),
    horizontal_table: (:),
    title: (:),
    date_place: (:),
    opening: (:),
    closing: (:),
    signature: (:),
    body,
) = {
    let as_content_dict = (it) => {
        if type(it) != "dictionary" {
            (content: it)
        } else {
            it
        }
    }
    let format_defaults = lttr_format_defaults.at(format)

    let data = (
        debug: debug,
        format: format,
        _page: lttr_deep_dict_merge((
            lttr_defaults._page,
            format_defaults._page,
            _page,
        )),
        _text: lttr_deep_dict_merge((
            lttr_defaults._text,
            format_defaults._text,
            _text,
        )),
        settings: lttr_deep_dict_merge((
            lttr_defaults.settings,
            settings,
        )),
        sender: lttr_deep_dict_merge((
            lttr_defaults.sender,
            format_defaults.sender,
            as_content_dict(sender),
        )),
        return_to: lttr_deep_dict_merge((
            lttr_defaults.return_to,
            format_defaults.return_to,
            as_content_dict(return_to),
        )),
        remark_zone: lttr_deep_dict_merge((
            lttr_defaults.remark_zone,
            format_defaults.remark_zone,
            as_content_dict(remark_zone),
        )),
        receiver: lttr_deep_dict_merge((
            lttr_defaults.receiver,
            format_defaults.receiver,
            as_content_dict(receiver),
        )),
        date_place: if date_place == none { none } else {
            lttr_deep_dict_merge((
                lttr_defaults.date_place,
                format_defaults.date_place,
                as_content_dict(date_place),
            ))
        },
        title: if title == none { none } else {
            lttr_deep_dict_merge((
                lttr_defaults.title,
                as_content_dict(title),
            ))
        },
        author: author,
        horizontal_table: lttr_deep_dict_merge((
            lttr_defaults.horizontal_table,
            as_content_dict(horizontal_table),
        )),
        opening: if opening == none { none } else {
            lttr_deep_dict_merge((
                lttr_defaults.opening,
                as_content_dict(opening),
            ))
        },
        closing: if closing == none { none } else {
            lttr_deep_dict_merge((
                lttr_defaults.closing,
                as_content_dict(closing),
            ))
        },
        signature: if signature == none { none } else {
            lttr_deep_dict_merge((
                lttr_defaults.signature,
                as_content_dict(signature),
            ))
        },
        indicator_lines: if indicator_lines == none { none } else {
            lttr_deep_dict_merge((
                format_defaults.indicator_lines,
                indicator_lines,
            ))
        },
    )

    // NOTE: This is a special case for DIN-5008-B as described in the format
    // defaults
    if data.format == "DIN-5008-B" {
        if data.return_to.content != none and data.remark_zone.content != none {
            // we have both return_to and remark_zone, reduce the size of
            // remark_zone and shift it down
            data.remark_zone.dimensions.height = data.remark_zone.dimensions.height - data.return_to.dimensions.height
            data.remark_zone.position.top = data.remark_zone.position.top + data.return_to.dimensions.height
        } else if  data.return_to.content != none {
            // there is no remark_zone, shift the return_to down
            data.return_to.position.top = data.receiver.position.top - data.return_to.dimensions.height
        }
    }

    // FIXME: find a better way to (not) set document attributes
    set page(..data._page)
    set text(..data._text)
    lttr_data.update(x => data)

    style(styles => {
        lttr_update_max_dy(
            data.settings.min_content_offset - data._page.margin.top
        )
    })
    body
}

#let lttr_state() = {
    locate(loc => {
        lttr_data.at(loc);
    })
}
