module Main exposing (..)

import Html.App as App
import Parent


main : Program Never
main =
    App.beginnerProgram
        { model = Parent.init
        , view = Parent.view
        , update = Parent.update
        }
