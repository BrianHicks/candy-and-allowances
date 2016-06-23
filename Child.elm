module Child exposing (..)

import Html exposing (Html, div, p, text, button)
import Html.Events exposing (onClick)


type alias Model =
    { money : Float }


init : Model
init =
    { money = 0 }


type Msg
    = Allowance Float
    | Candy


update : Msg -> Model -> ( Model, Float )
update msg model =
    case msg of
        Allowance amount ->
            ( { model | money = model.money + amount }
            , 0
            )

        Candy ->
            let
                money =
                    model.money - 5
            in
                ( { model | money = money }
                , min money 0 |> abs
                )


view : Model -> Html Msg
view model =
    div []
        [ p [] [ "Allowance money: $" ++ (toString model.money) |> text ]
        , button [ onClick Candy ] [ text "Blow $5 on candy" ]
        ]
