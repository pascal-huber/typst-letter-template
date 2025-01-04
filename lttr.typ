// NOTE: lttr-data contains all the data to render the letter
#let lttr-data = state("letter", none)

// NOTE: lttr-max-dy keeps track of the largest offset dy (from the top margin)
//   of absolutely positioned content (sender and receiver fields) such that we
//   know how much vertical offset we need to add at the beginning of the letter
//   content. Note that length does not include the value of
//   `settings.content-spacing`.
#let lttr-max-dy = state("lttr-max-dy", 0cm)
#let lttr-update-max-dy(dy) = context {
    lttr-max-dy.update(x => calc.max(x, dy))
}

#let lttr-fmt(it) = {
    if type(it) == array {
        let ctr = 0
        for line in it {
            lttr-fmt(line)
            if ctr != it.len() {
                linebreak()
            }
            ctr += 1
        } 
    } else {
        [#it]
    }
}

#let lttr-defaults = (
    _page: (
        margin: (
            top: 3cm,
            bottom: 3cm,
            left: 25mm,
            right: 20mm,
        ),
    ),
    _text: (
        size: 11pt,
    ),
    settings: (
        content-spacing: 10mm,
        justify-content: true,
    ),
    sender: (
        content: none,
        fmt: (it) => {
            lttr-fmt(it.content)
        },
    ),
    return-to: (
        content: none,
        fmt: (it) => {
            text(size: 0.8em)[#underline({
                lttr-fmt(it.content)
            })]
        },
    ),
    remark-zone: (
        content: none,
        fmt: (it) => {
            set align(it.align)
            text(size: 0.8em)[
                #lttr-fmt(it.content)
            ]
        },
    ),
    receiver: (
        content: none,
        fmt: (it) => {
            lttr-fmt(it.content)
        },
        spacing: 0.65em / 2, // NOTE: half the default spacing between lines
    ),
    date-place: (
        date: none,
        place: none,
    ),
    horizontal-table: (
        content: none,
        fmt: (header, content) => {
            set par(leading: 0.4em)
            text(size: 0.8em)[
                #lttr-fmt(header)
                #linebreak()
            ]
            lttr-fmt(content)
        },
        spacing: 10mm,
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

#let lttr-format-defaults = (
    "DIN-5008-A": (
        _page: (
            paper: "a4",
        ),
        _text: (
            lang: "DE"
        ),
        settings: (
            content-spacing: 8.46mm,
        ),
        horizontal-table: (
            spacing: 8.46mm,
        ),
        sender: (
            position: (left: 125mm, top: 32mm),
            width: 75mm,
        ),
        return-to: (
            position: (left: 20mm + 5mm, top: 27mm),
            dimensions: (height: 5mm, width: 85mm - 5mm),
        ),
        remark-zone: (
            position: (left: 20mm + 5mm, top: 27mm + 5mm),
            dimensions: (height: 12.7mm, width: 85mm - 5mm),
            align: top,
        ),
        receiver: (
            position: (left: 20mm + 5mm, top: 27mm + 17.7mm),
            dimensions: (height: 27.3mm, width: 85mm - 5mm),
            align: top,
        ),
        indicator-lines: (
            show-puncher-mark: true,
            fold-marks: (87mm, 87mm+105mm),
        ),
        date-place: (
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
        settings: (
            content-spacing: 8.46mm,
        ),
        horizontal-table: (
            spacing: 8.46mm,
        ),
        sender: (
            position: (left: 125mm, top: 50mm),
            width: 75mm,
        ),
        return-to: (
            // NOTE: this position overlapps with remark-zone. DIN-5008-B does
            //   not have a dedicated return-to field. If both return-to and
            //   remark-zone have a non-none content, then the remark-zone field
            //   has to be recuced by return-to.dimensions.height
            position: (left: 20mm + 5mm, top: 45mm),
            dimensions: (height: 5mm, width: 85mm - 5mm),
        ),
        remark-zone: (
            position: (left: 20mm + 5mm, top: 45mm),
            dimensions: (height: 12.7mm + 5mm, width: 85mm - 5mm),
            align: bottom,
        ),
        receiver: (
            position: (left: 20mm + 5mm, top: 45mm + 17.7mm),
            dimensions: (height: 27.3mm, width: 85mm - 5mm),
            align: top,
        ),
        indicator-lines: (
            show-puncher-mark: true,
            fold-marks: (105mm, 105mm + 105mm),
        ),
        date-place: (
            align: right,
        )
    ),
    "C5-WINDOW-LEFT": (
        _page: (
            paper: "a4",
        ),
        _text: (
            lang: "CH",
        ),
        settings: (
            content-spacing: 10mm,
        ),
        horizontal-table: (
            spacing: 10mm,
        ),
        sender: (
            // NOTE: position.top is the margin.top
            // NOTE: position.left and width are like DIN5008
            position: (left: 125mm, top: 30mm),
            width: 75mm,
        ),
        return-to: (
            position: none,
        ),
        remark-zone: (
            position: none,
        ),
        receiver: (
            // NOTE: I added a 5mm "padding" on the left here
            position: (left: 20mm + 5mm, top: 52mm),
            // NOTE: height = Window_height - (C5_height - Paper_height)
            //              = 45mm - (162mm - 297mm/2)
            //              = 31.5mm
            // NOTE: width = Window_width - (C5_width - Paper_width)
            //              = 100mm - (229mm - 210mm)
            //              = 81mm
            dimensions: (height: 31.5mm, width: 81mm),
            align: horizon,
        ),
        indicator-lines: (
            fold-marks: (),
            show-puncher-mark: true,
        ),
        date-place: (
            align: left,
        )
    ),
    "C5-WINDOW-RIGHT": (
        _page: (
            paper: "a4",
        ),
        _text: (
            lang: "CH",
        ),
        settings: (
            content-spacing: 10mm,
        ),
        horizontal-table: (
            spacing: 10mm,
        ),
        sender: (
            position: none,
            width: 75mm,
        ),
        return-to: (
            position: none,
        ),
        remark-zone: (
            position: none,
        ),
        receiver: (
            position: (left: 120mm, top: 52mm),
            dimensions: (height: 31.5mm, width: 80mm),
            align: horizon,
        ),
        indicator-lines: (
            fold-marks: (),
            show-puncher-mark: true,
        ),
        date-place: (
            align: left,
        )
    ),
)

#let lttr-indicator-lines(body) = context {
        let state = lttr-data.at(here());
        if state.indicator-lines != none {
            if state.indicator-lines.show-puncher-mark {
                place(
                    dy: 50% - 0.5 * state._page.margin.top + 0.5 * state._page.margin.bottom,
                    dx: 0cm - state._page.margin.left + 9mm,
                    line(
                        length: 0.4cm, 
                        stroke: 0.5pt + rgb("#777777")
                    )
                )
            }
            if type(state.indicator-lines.fold-marks) == array {
                for mark in state.indicator-lines.fold-marks {
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
    body
}

#let lttr-horizontal-table(
    body
) = context {
        let state = lttr-data.at(here());
        if state.horizontal-table.content != none {
            let content = ()
            let ctr = 0
            for entry in state.horizontal-table.content {
                ctr += 1
                content.push({
                    state.horizontal-table.at("fmt")(
                        entry.first(),
                        entry.last(),
                    )
                })
            }
            if ctr > 0 {
                let column-width = 100% / ctr
                let columns = ()
                while ctr > 0 {
                    columns.push(column-width)
                    ctr -= 1
                }
                let tbl = table(
                    columns: columns,
                    inset: 0pt,
                    stroke: if state.debug {red} else {none},
                    align: (left, top),
                    ..content
                )
                let table-rect = rect(
                    outset: 0pt,
                    inset: 0pt,
                    stroke: none,
                    tbl
                )
                let dy = lttr-max-dy.at(here()) + state.horizontal-table.spacing
                place(
                    dy: dy,
                    {
                        table-rect
                        layout(size => {
                            let (height,) = measure(
                                block(width: size.width, table-rect)
                            )
                            lttr-update-max-dy(height + dy)
                        })
                    }
                )
            }
        }
    body
}

#let lttr-closing(body) = context {
        let state = lttr-data.at(here());
        if  state.closing.content != none {
            v(state.closing.spacing)
            state.closing.content
        }
        if state.signature.content != none {
            v(state.signature.spacing)
            state.signature.content
        }
    body
}

#let lttr-opening(body) = context {
        let state = lttr-data.at(here());
        if state.opening != none {
            v(state.opening.spacing)
            state.opening.content
        }
    body
}

#let lttr-date-place(body) = context {
        let state = lttr-data.at(here());
        if state.date-place != none {
            set align(state.date-place.align)
            state.date-place.place
            if state.date-place.place != none and state.date-place.date != none {
                text(", ")
            }
            state.date-place.date
        }
    body
}

#let lttr-title(body) = context {
        let state = lttr-data.at(here());
        if state.title != none {
            v(state.title.spacing)
            text(
                weight: "bold",
                size: 1.0em,
                state.title.content
            )
        }
    body
}

#let lttr-sender(body) = context {
        let state = lttr-data.at(here());
        let sender-rect = rect(
            width: state.sender.width,
            inset: 0pt,
            outset: 0pt,
            stroke: if state.debug {blue} else {none},
            {
                state.sender.at("fmt")(state.sender)
            }
        )
        let sender-position = if state.sender.position != none {
            state.sender.position
        } else {
            (left: state._page.margin.left, top: state._page.margin.top) 
        }
        let dy = sender-position.top - state._page.margin.top
        let dx = sender-position.left - state._page.margin.left
        place(
            dy: dy,
            dx: dx,
            sender-rect
        )
        // TODO: add layout here
        lttr-update-max-dy(measure(sender-rect).height + dy)
    body
}

#let lttr-receiver-return-to(body) = context {
        let state = lttr-data.at(here());
        if state.return-to.position != none {
            let dy = state.return-to.position.top - state._page.margin.top
            let dx = state.return-to.position.left - state._page.margin.left
            place(
                dy: dy,
                dx: dx,
                rect(
                    width: state.return-to.dimensions.width,
                    height: 5mm, 
                    stroke: if state.debug {red} else {none},
                    inset: (left: 0mm, right: 0mm),
                    outset: 0cm,
                    {
                        state.return-to.at("fmt")(state.return-to)
                    }
                )
            )
        }
    body
}

#let lttr-receiver-remark-zone(body) = context {
    let state = lttr-data.at(here());
        if state.remark-zone.position != none {
            let dy = state.remark-zone.position.top - state._page.margin.top
            let dx = state.remark-zone.position.left - state._page.margin.left
            place(
                dy: dy,
                dx: dx,
                rect(
                    width: state.remark-zone.dimensions.width,
                    height: state.remark-zone.dimensions.height,
                    stroke: if state.debug {green} else {none},
                    inset: (left: 0mm, right: 0mm),
                    outset: 0pt,
                    {
                        state.remark-zone.at("fmt")(state.remark-zone)
                    }
                )
            )
        }
    body
}

#let lttr-receiver-address(body) = {
    context {
        let state = lttr-data.at(here());
        let receiver-rect = rect(
            width: state.receiver.dimensions.width,
            height: state.receiver.dimensions.height,
            stroke: if state.debug {purple} else {none},
            inset: (left: 0mm, right: 0mm, top: 0mm),
            outset: 0pt,
            {
                v(state.receiver.spacing)
                set align(state.receiver.align)
                state.receiver.at("fmt")(state.receiver)
            },
        )
        let dy = state.receiver.position.top - state._page.margin.top
        let dx = state.receiver.position.left - state._page.margin.left
        place(
            dy: dy,
            dx: dx,
            receiver-rect,
        )
        // TODO: add layout here
        let rect-height =  measure(receiver-rect).height
        lttr-update-max-dy(rect-height + dy)
    }
    body
}

#let lttr-receiver(body) = {
    show: lttr-receiver-return-to
    show: lttr-receiver-remark-zone
    show: lttr-receiver-address
    body
}

#let lttr-content-offset(body) = context {
        let state = lttr-data.at(here());
        v(lttr-max-dy.at(here()) + state.settings.content-spacing)
        set par(justify: state.settings.justify-content)
        body
}

#let lttr-preamble(body) = {
    show: lttr-sender
    show: lttr-receiver
    show: lttr-horizontal-table
    show: lttr-indicator-lines
    show: lttr-content-offset
    show: lttr-date-place
    show: lttr-title
    show: lttr-opening
    body
}

#let lttr-init(
    _page: (:),
    _text: (:),
    debug: false,
    format: "DIN-5008-A",
    settings: (:),
    indicator-lines: (:),
    sender: (:),
    return-to: (:),
    remark-zone: (:),
    receiver: (:),
    horizontal-table: (:),
    title: (:),
    date-place: (:),
    opening: (:),
    closing: (:),
    signature: (:),
    body,
) = {
    let format-defaults = lttr-format-defaults.at(format)

    // Takes an array of dictionaries and merges them where later dictionaries
    // overwrite the values of the ones before
    let lttr-deep-dict-merge(dictionaries) = {
        if dictionaries.len() == 0 {
            return (:)
        } else if dictionaries.len() == 1 {
            return dictionaries.first()
        }

        // helper function to deeply merge d1 and d2 (d2 overwrites d1)
        let deep-merge(d1, d2) = {
            let keys = (..d1.keys(), ..d2.keys())
            for k in keys {
                if d1.keys().contains(k) and d2.keys().contains(k) {
                    let d1-val = d1.at(k)
                    let d2-val = d2.at(k)
                    if type(d1-val) == dictionary and type(d2-val) == dictionary {
                        // both d1 and d2 contain key k both d1.at(k) and
                        // d2.at(k) are dictionaries, merge them
                        d2.insert(k, deep-merge(d1-val, d2-val))
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
                result = deep-merge(result, dict)
            }
        }
        return result
    }

    let merge-arg-dicts = (item-name, item) => {
        if item == none {
            none
        } else {
            lttr-deep-dict-merge((
                lttr-defaults.at(item-name, default: (:)),
                format-defaults.at(item-name, default: (:)),
                if type(item) != dictionary {
                    (content: item)
                } else {
                    item
                }
            ))
        }
    }

    let data = (
        _page: merge-arg-dicts("_page", _page),
        _text: merge-arg-dicts("_text", _text),
        closing: merge-arg-dicts("closing", closing),
        date-place: merge-arg-dicts("date-place", date-place),
        debug: debug,
        format: format,
        horizontal-table: merge-arg-dicts("horizontal-table", horizontal-table),
        indicator-lines: merge-arg-dicts("indicator-lines", indicator-lines),
        opening: merge-arg-dicts("opening", opening),
        receiver: merge-arg-dicts("receiver", receiver),
        remark-zone: merge-arg-dicts("remark-zone", remark-zone),
        return-to: merge-arg-dicts("return-to", return-to),
        sender: merge-arg-dicts("sender", sender),
        settings: merge-arg-dicts("settings", sender),
        signature: merge-arg-dicts("signature", signature),
        title: merge-arg-dicts("title", title),
    )

    // NOTE: This is a special case for DIN-5008-B as described in the format
    // defaults
    if data.format == "DIN-5008-B" {
        if data.return-to.content != none and data.remark-zone.content != none {
            // we have both return-to and remark-zone, reduce the size of
            // remark-zone and shift it down
            data.remark-zone.dimensions.height = data.remark-zone.dimensions.height - data.return-to.dimensions.height
            data.remark-zone.position.top = data.remark-zone.position.top + data.return-to.dimensions.height
        } else if  data.return-to.content != none {
            // there is no remark-zone, shift the return-to down
            data.return-to.position.top = data.receiver.position.top - data.return-to.dimensions.height
        }
    }

    // FIXME: find a better way to (not) set document attributes
    set page(..data._page)
    set text(..data._text)
    lttr-data.update(x => data)
    body
}

#let lttr-state() = context {
    lttr-data.at(here());
}
