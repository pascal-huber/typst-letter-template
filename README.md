# typst l<sub>e</sub>tt<sub>e</sub>r

A customizable Typst letter template with some presets for DIN 5008 A/B and
Swiss C5 Letter. Please note that the template is still under development and
subject to breaking changes.

![preview](./preview.png)

See the [examples](./examples)

## Templates

- `lttr_init` is responsible to compute all values from the parameters and
  default values for different formats. It also sets the `page` and `text`
  attributes.

- `lttr_preamble` renders:
  - `lttr_sender`
  - `lttr_receiver`
  - `lttr_indicator_lines`
  - `lttr_content_offset`
  - `lttr_horizontal_table`
  - `lttr_date_place`
  - `lttr_title`
  - `lttr_opening`

- `lttr_closing` renders the closing line and the signature.

## Parameters

All Parameters are optional and will override the global defaults and the
defaults of the chosen format. Some of them allow to either specify the content
directly or use a dict if other settings need to be changed also. For example:
`receiver: "x"` is the same as `receiver: (content: "x")`.

### Basics

- `debug` (`[Bool]`)  
  Whether or not to show (colorful) debug lines.

- `format` (`[String]`)  
  Format of the letter (`"DIN-5008-A"`, `"DIN-5008-B"`, `"C5-WINDOW-RIGHT"`,
  `"C5-WINDOW-LEFT"`).

- `_page` (`[Dict]`)  
  Set page settings ([docs](https://typst.app/docs/reference/layout/page/)).

- `_text` (`[Dict]`)  
  Set text settings ([docs](https://typst.app/docs/reference/text/text/)).

- `settings` (`[Dict]`)
  Basic settings.
  - `content_spacing` (`[Length]`)  
    Minimum spacing between sender/receiver and letter content (or the
    horizontal table if present) and also the spacing after the horizontal
    table.
  - `justify_content` (`[Bool]`)  
    Wheter or not to justify the content.

  Example:

  ```typst
  settings: (
    content_spacing: 8.46mm,
    justify_content: true,
  ),
  ```

- `indicator_lines` (`[Dict]`)  
  Info to render lines for the hole puncher and folding ([see below](#indicator-lines)).
  - `fold_marks` (`[Array]`)  
     Lenghts (`[Length]`) from top of page of the fold marks
  - `show_puncher_mark` (`[Bool]`)  
     Whether or not to show the puncher mark.

  Example:

  ```typst
  indicator_lines: (
    fold_marks: (87mm, 87mm+105mm),
    show_puncher_mark: true,
  )
  ```

### Sender and Receiver

- `receiver` (`[Array, Content, Dict]`)  
   Info to render the receiver fields.
  - `content` (`[Array, Content]`)  
    Content of the receiver field.
  - `dimensions` (`[Dict]`)  
    Dimensions of the address field (`width: [Length]`, `height: [Length]`)
  - `fmt` (`[Function]`)  
    Rendering function which takes the receiver (`[Dict]`) to format and show
    it.
  - `position` (`[Dict]`)  
    Position of the address field (`top: [Length]`, `left: [Length]`)
  - `spacing` (`[Length]`)  
    Spacing before the content.
  - `align` (`[Align]`)
    Alignment of the receiver field.

  Example:

  ```typst
  receiver: (
    position: (top: 5cm)
    content: (
      "Peter Doe",
      "Somestreet 16",
      "1234 New York",
    ),
  ),
  ```

- `return_to` (`[Array, Content, Dict, String]`)  
   The returning address.
  - `content` (`[Array, Content]`)  
    Content of the return_to field.
  - `dimensions` (`[Dict]`)  
    Dimensions of the return_to field (`width: [Length]`, `height: [Length]`)
  - `fmt` (`[Function]`)  
    Rendering function which takes the return_to (`[Dict]`) to format and show
    it.
  - `position` (`[Dict]`)  
    Position of the return_to field (`top: [Length]`, `left: [Length]`)

  Example:

  ```typst
  return_to: "Some Address, I don't care...",
  ```

- `remark_zone` (`[Array, Content, Dict, String]`)  
   The remark zone.
  - `align` (`[Align]`)  
    Alignment of the remark_zone.
  - `content` (`[Array, Content, String]`)  
    Content of the remark_zone field.
  - `dimensions` (`[Dict]`)  
    Dimensions of the remark_zone field (`width: [Length]`, `height: [Length]`)
  - `fmt` (`[Function]`)  
    Rendering function which takes the remark_zone (`[Dict]`) to format and show
    it.
  - `position` (`[Dict]`)  
    Position of the remark_zone field (`top: [Length]`, `left: [Length]`) 

  ```typst
  remark_zone: (
    "This is a",
    "multiline remark",
  )
  ```

- `sender` (`[Array, Content, Dict]`)  
   Info to render the sender fields.
  - `content` (`[Array, Content]`)
    Content or array of lines for the sender field.
  - `fmt` [Function]  
    Rendering function which takes the sender (`[Dict]`) to format and show it.
  - `position` (`[Dict]`)  
    Position of the sender field.
  - `width` (`[Length]`)  
    Width of the sender field.

  Example:

  ```typst
  sender: (
    content: (
      "John Doe",
      "Somestreet 15",
      "1234 New York",
    )
    position: (left: 110mm, top: 20mm),
    width: 80mm,
  ),
  ```

- `horizontal_table` (`[Dict, Array]`)  
  A table to add before the date, time and title.
  - `content` (`[Array]`)  
    Array of of entries for the table where each entry is itself an array of
    exactly two items for title and body (`[Content, String]`)
  - `fmt` (`[Function]`)  
    Formatting function which takes the title and body of a cell to format and
    show it.
  - `spacing` (`[Lenght]`)
    Spacing before the horizontal table.

  Example:

  ```typst
  horizontal_table: (
    ("Ihr Zeichen", "Bananalover149"),
    ("Ihre Nachricht vom", "12.12.2022"),
    ("Unser Zeichen", "Bananenfabrik"),
    ("Datum", "12.08.2023"),
  )
  ```

### Letter Beginning

- `opening` (`[Content, Dict, String]`)  
  Info to render the `title` template ([see below](#opening)).
  - `content` (`[Content, String]`)  
    Content of the opening (e.g. "Dear Sir....").
  - `spacing` (`[Length]`)  
   Spacing before the letter opening.

  Example:

  ```typst
  opening: (
    content: "Dear Sir or Madam,",
    spacing: 2mm,
  )
  ```

- `date_place` (`[Content, Dict, String]`)  
  Info to render the `date_place` template ([see below](#date-place)).
  - `align` (`[Align]`)  
    Alignment of the place and date
  - `date` (`[Content, String]`)  
    Date of the letter.
  - `place` (`[Content, String]`)  
    Place of the letter.

  Example:

  ```typst
  date_place: (
    align: left,
    date: "20.04.2023",
    place: "Weitfortistan",
  ),
  ```

- `title` (`[Content, Dict, String]`)  
  Info to render the `title` template. The title is also set as document
  property.
  - `content` (`[Content, String]`)  
    Content of the title.
  - `spacing` (`[Length]`)  
    Spacing before the title.

  Example:

  ```typst
  title: (
    content: "Writing Letters in Typst is Easy",
    spacing: 2mm,
  )
  ```

### Letter Ending

- `closing` (`[Content, Dict, String]`)  
  Info to render the closing
  - `content` (`[Content, String]`)  
    Content of the closing (e.g. "kind regards").
  - `spacing` (`[Length]`)  
    Spacing before the closing.

  Example:

  ```typst
  closing: "kind regards"
  ```

- `signature` (`[Dict, none]`)  
  Info to render the signature.
  - `content` (`[Content]`)  
    Content of the signature
  - `spacing` (`[Length]`)  
    Spacing before the signature.

  Example:

  ```typst
  signature: (
    content: "Peter Pan (with the big Signature)",
    spacing: 16mm,
  )
  ```

## Other functions

- `lttr_state` prints the entire state used to render the components. This can
  be useful for debugging purposes.

## Resources

- [DIN 5008 Form A](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008,_Form_A.svg)
- [DIN 5008 Form B](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008_Form_B.svg)
- [Swiss
  Addressing](https://www.post.ch/-/media/portal-opp/pm/dokumente/briefe-spezifikation-gestaltung.pdf?sc_lang=de&hash=BB181E74C5D3A0D1D49A954793EA670A)

## Similar Projects

- [dvdvgt/typst-letter](https://github.com/dvdvgt/typst-letter): A typst
  template for a DIN 5008 inspired letter with the goal to fit nicely into C6/5
  envelops.
- [qjcq/awesome-typst](https://github.com/qjcg/awesome-typst): Awesome Typst
  Links

## Development Setup

Currently, I just create a symlink such that I can import it with `#import
"@local/lttr:0.1.0": *` as follows.

```bash
mkdir -p ${XDG_DATA_HOME}/typst/packages/local/lttr/
ln -s /path/to/this/repo ${XDG_DATA_HOME}/typst/packages/local/lttr/0.1.0
```

## Installation

While there exists a first version of typst packages, they do not yet accept
custom templates (afaik). For the meantime, you can download and extract the
release tarball to `${XDG_DATA_HOME}/typst/packages/local/lttr/<version>` and
import it as described in [Development Setup](#development-setup).

## Roadmap

There are a couple of limitations in typst which I hope will be addressed.

- [ ] There is currently no way to query properties set with `set`. This would
  be nice to query the document title and author names
  [issue](https://github.com/typst/typst/issues/763). Forthermore, it is not
  possible to call `set` after the first lttr function has been called (even if
  no content was rendered added). 
- [ ] datetime with locales settings

Other things:

- [ ] Add  more  layouts including (us letter, ?)
- [ ] Vertical table for sender field as for example
  [here](https://www.onlineprinters.de/magazin/wp-content/uploads/2021/07/Vorlage_Geschaeftsbrief_DIN-5008_Form-A.jpg)
- [ ] Maybe add lines with labels to display measurements/sizes in debug mode
- [ ] Add this to the typst preview packages. Currently, they apparently do not
  accept packages.
