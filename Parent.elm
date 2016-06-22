module Parent exposing (..)

import Html exposing (Html, text, h1, div, p, button)
import Html.Events exposing (onClick)


type alias Model =
    { money : Float }


init : Model
init =
    { money = 0 }


type Msg
    = Paycheck Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        Paycheck amount ->
            { model | money = model.money + amount }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Parent" ]
        , p [] [ "Money: " ++ (toString model.money) |> text ]
        , button [ onClick (Paycheck 100) ] [ text "$100 paycheck!" ]
        ]
