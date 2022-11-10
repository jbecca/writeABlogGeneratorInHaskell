module Html.Internal where

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

instance Semigroup Structure where
    (<>) c1 c2 = 
        Structure (getStructureString c1 <> getStructureString c2)

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
        concatMap escapeChar

ul_ :: [Structure] -> Structure
ul_ = Structure . el "ul" . concatMap (el "li" . getStructureString) 

ol_ :: [Structure] -> Structure
ol_ = Structure . el "ol" . concatMap (el "li" . getStructureString) 

code_ :: String -> Structure
code_ = Structure . el "pre" . escape
