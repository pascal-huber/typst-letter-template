# Typst Letter Template

A customizable Typst letter template with some presets for DIN 5008 A/B and
Swiss C5 Letter.

![preview](./preview.png)

# Letter Structure

 - The sender field is a rectangle positioned absolutely.
 - The receiver field is a rectangle positioned absolutely right after the
   `return_to` and `remark_zone`. In DIN 5008 B, `return_to` content is rendered
   inside the `remark_zone`
 - The remaining content of the letter is as follows:
   - Date and Place Line
   - Title
   - Opening
   - Body (your content)
   - Closing
   - Signature
 
# Letter Parameters

## Letter Settings

 - `debug` [Bool] (default=false)  
   Whether or not to show the debug lines.
 - `_page` [Dict] (default=(:))  
   Overwrite page settings.
 - `_text` [Dict] (default=(:))  
   Overwrite text settings.
 - `format` [String] (default="DIN-5008-B")  
   Format of the letter. Must be one of "DIN-5008-A", "DIN-5008-B", "C5-WINDOW-RIGHT"
 - `margin` [Dict]  
   Margins of the document. [doc](https://typst.app/docs/reference/layout/page/#parameters--margin)
 - `content_start_min` [Length]  
   Minimum space between top margin and beginning of the letter content.
 - `content_spacing` [Length]  
   Minimum spacing between sender/receiver and letter content.
 - `justify_content` [Bool]  
   Wheter or not to justify the content.

## Indicator Lines
 - `show_puncher_mark` [Bool]  
   Wheter or not to show the puncher mark.
 - `fold_marks` [Array]  
   Lenghts from top of page of the fold marks. Note that `fold_marks: (1cm)` is invalid as `(1cm)` has type length use `fold_marks: (1cm,)` instead.

   
## Sender

 - `sender` [Array, Content] (default: none)  
   Content or array of lines for the sender field. 
 - `sender_position` [Dict] (default: none)  
   Position of the sender field.
 - `sender_width` [Length]  
   Width of the sender field.

## Receiver

 - `show_return_to` [Bool]  
   Whether or not to show the return_to field.
 - `return_to` [Content]  
   Content of the return_to field.
 - `show_remark_zone` [Bool]  
   Whether or not to show the remark_zone field.
 - `remark_zone` [Content]  
   Content of the remark_zone field.
 - `remark_zone_align` [Align]  
   Alignment of the remark_zone.
 - `receiver` [Content]  
   Content of the receiver field.
 - `receiver_position` [Dict]  
   Position of the receiver fields (`top: [Length]`, `left: [Length]`) 
 - `receiver_width` [Length]  
   Width of the receiver fields

## Date and Place

 - `show_date_place` [Bool]  
   Wheter or not to show the date/place
 - `letter_date_place_line` [Content]  
   Specify a custom line to go above the letter title instead of the following.
 - `letter_date` [Content]  
   Date of the letter.
 - `letter_place` [Content]  
   Place of the letter.
 - `letter_date_place_align` [Align]  
   Alignment of the place and date
   
## Document Start

 - `show_title` [Bool]  
   Whether or not to show the title.
 - `title_spacing` [Length]  
   Spacing before the title.
 - `title` [Content]  
   Content of the title.
 - `show_opening` [Bool]  
   Whether or not to show the opening.
 - `opening_spacing` [Length]  
   Spacing before the letter opening.
 - `opening` [Content]  
   Content of the opening (e.g. "Dear Sir....").
 - `body_spacing` [Lenght]  
   Spacing before the body of the letter.
   
## Document End
 - `show_closing` [Bool]  
   Wheter or not to show the closing line.
 - `closing_spacing` [Length]  
   Spacing before the closing.
 - `closing` [Content]  
   Content of the closing (e.g. "kind regards").
 - `show_signature` [Bool]  
   Wheter or not to show the signature line.
 - `signature_spacing` [Length]  
   Spacing before the signature.
 - `signature` [Content]  
   Content of the signature

# Resources

 - [DIN 5008 Form A](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008,_Form_A.svg)
 - [DIN 5008 Form B](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008_Form_B.svg)
 - [Swiss
   Addressing](https://www.post.ch/-/media/portal-opp/pm/dokumente/briefe-spezifikation-gestaltung.pdf?sc_lang=de&hash=BB181E74C5D3A0D1D49A954793EA670A)

# Similar Projects

 - [dvdvgt/typst-letter](https://github.com/dvdvgt/typst-letter): A typst
   template for a DIN 5008 inspired letter with the goal to fit nicely into C6/5
   envelops.
 - [qjcq/awesome-typst](https://github.com/qjcg/awesome-typst): Awesome Typst
   Links 


# TODO
 - [ ] Refactor Hard
 - [ ] Use document properties
 - [ ] Make remaining settings customizable
 - [ ] Add C5 Layout with window on the left side
 - [ ] Use datetime type (and today function) as soon as it exists
   [PR](https://github.com/typst/typst/pull/435),
   [discussion](https://github.com/typst/typst/issues/303),
   [issue](https://github.com/typst/typst/issues/204)
 - [ ] Put `margin` into format defaults
 - [ ] Load data from json/yaml files
