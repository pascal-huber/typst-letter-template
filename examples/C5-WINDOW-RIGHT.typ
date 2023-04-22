#import "../template.typ": letter
#show: letter.with(
    format: "C5-WINDOW-RIGHT",
    _page: (
        header: {
            locate(loc => if loc.page() != 1 {
                align(right)[The cool kids use Typst!]
                line(length: 100%, stroke: 1pt + rgb("#777777"))
            })
        },
    ),
    letter_date: "20.04.2153",
    letter_place: "Weitfortistan",
    signature: "Hanspeter Müller",
    receiver: (
        "Peter Empfänger",
        "Bahnhofsstrasse 16",
        "1234 Nochvielweiterwegstadt",
    ),
    sender: {
        image("logo.png", width: 90%, fit: "contain")
        h(2mm)
        text("Hanspeter Müller")
        linebreak()
        h(2mm)
        text("Sesamstrasse 15")
        linebreak()
        h(2mm)
        text("1234 Einestadt")
        linebreak()
        h(2mm)
        text("Weitfortistan")
    }
)

#lorem(40)

```rust
pub fn f(x: &mut i32) -> i32 {
    3
}
```

#lorem(60)

#lorem(30)

#lorem(530)


