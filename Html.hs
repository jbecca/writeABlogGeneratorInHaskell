module Html
    ( Html
    , Title
    , Structure
    , html_
    , p_
    , h1_ 
    , append_ 
    , render 
    )
    where

newtype Html 
    = Html String

newtype Structure 
    = Structure String

type Title 
    = String

html_ :: Title -> Structure -> Html
html_ title content = 
    Html
        ( el "html"
            ( el "head" (el "title" (escape title))
                <> el "body" (getStructureString content)
            )
        )

p_ :: String -> Structure
p_ = Structure . el "p" . escape

h1_ :: String -> Structure
h1_ = Structure . el "h1" . escape

el :: String -> String -> String
el tag content =
    "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

append_ :: Structure -> Structure -> Structure
append_ (Structure a) (Structure b) =
    Structure $ a <> b 

render :: Html -> String
render (Html a) = a

getStructureString :: Structure -> String
getStructureString content =
    case content of
        Structure str -> str

escape :: String -> String
escape =
    let 
        escapeChar c =
            case c of
                '<' -> "&lt;"
                '>' -> "&gt;"
                '&' -> "&amp;"
                '"' -> "&quot;"
                '\'' -> "&#39;"
                _ -> [c]
    in
        concat . map escapeChar
