# Typst Letter Template

Template for DIN 5008 and (Swiss) C5 Letter with window.
 
# Parameters

## Misc

| Parameter | Description                  | Supportedl Types | Default |
|-----------|------------------------------|------------------|---------|
| debug     | Whether or not to show lines | Bool             | false   |
 
## Content

| Parameter    | Description                                            | Supportedl Types |
|--------------|--------------------------------------------------------|------------------|
| sender       | Info about the sender of the letter                    | array / content  |
| receiver     | Address of the receiver                                | array            |
| letter_date  | Date of the letter                                     | content          |
| letter_place | Place of the letter                                    | content          |
| title        | Title of the letter                                    | content          |
| opening      | Opening words of the letter (e.g. "Dear Sir or Madam") | content          |
| closing      | Closing words of the letter (e.g. "kind regards")      | content          |
| signature    | Your name                                              | content          |
| return_to    | Line with the return Address                           | content          |
| remark_zone  | Content of the remark zone                             | content          |

## Format

 - If `format` is set, all the others will be set to a default value. 
 - Positions are absolute and independent of the margins.

| Parameter         | Supportedl Types/Values                       |
|-------------------|-----------------------------------------------|
| format            | "DIN-5008-A", "DIN-5008-B", "C5-WINDOW-RIGHT" |
| show_puncher_mark | Bool                                          |
| show_fold_mark    | Bool                                          |
| sender_position   | Dict (top: Length, left: Length)              |
| sender_width      | Length                                        |
| receiver_position | Dict (top: Length, left: Length)              |
| receiver_width    | Length                                        |
| content_start_min | Length                                        |
| show_return_to    | Bool                                          |
| show_remark_zone  | Bool                                          |

Independent fields of the `format`
    
| Parameter   | Supportedl Types/Values                                                            |
|-------------|------------------------------------------------------------------------------------|
| itemspacing | Length                                                                             |
| margin      | Dict (see [doc](https://typst.app/docs/reference/layout/page/#parameters--margin)) |


# Resources

 - [DIN 5008 Form A](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008,_Form_A.svg)
 - [DIN 5008 Form B](https://de.wikipedia.org/wiki/DIN_5008#/media/Datei:DIN_5008_Form_B.svg)
 - [Swiss
   Addressing](https://www.post.ch/-/media/portal-opp/pm/dokumente/briefe-spezifikation-gestaltung.pdf?sc_lang=de&hash=BB181E74C5D3A0D1D49A954793EA670A)


# TODO
 - Add C5 Layout with window on the left side
 - Use datetime type (and today function) as soon as it exists
   [PR](https://github.com/typst/typst/pull/435),
   [discussion](https://github.com/typst/typst/issues/303),
   [issue](https://github.com/typst/typst/issues/204)
