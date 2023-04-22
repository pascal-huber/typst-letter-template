#import "../template.typ": *
#show: init.with(
    format: "C5-WINDOW-RIGHT",
    title: "Writing Letters in Typst is Easy",
    opening: "Dear Sir, Madam or Mother,",
    closing: "Peace, I'm out",
    signature: "Hansli",
    date_place: (
        date: "20.04.2023",
        place: "Weitfortistan",
    ),
    receiver: (
        content: (
            "Peter Empfänger",
            "Bahnhofsstrasse 16",
            "1234 Nochvielweiterwegstadt",
        ),
    ),
    sender: (
        content: (
            "Hanspeter Müller",
            "Sesamstrasse 15",
            "1234 Einestadt",
            "Weitfortistan",
        )
    )
)

#show: date_place
#show: title
#show: opening

#lorem(50)

```rust
pub fn f(x: &mut i32) -> i32 {
    3
}
```

#lorem(80)
#lorem(20)

#show: closing