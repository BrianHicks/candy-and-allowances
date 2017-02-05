module Main exposing (..)

import Html exposing (beginnerProgram)
import Parent


--main : Program Never
main =
    beginnerProgram
        { model = Parent.init
        , view = Parent.view
        , update = Parent.update
        }
