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


type OutMsg
    = NeedMoney Float


update : Msg -> Model -> ( Model, Maybe OutMsg )
update msg model =
    case msg of
        Allowance amount ->
            ( { model | money = model.money + amount }
            , Nothing
            )

        Candy ->
            let
                money =
                    model.money - 5

                out =
                    if money < 0 then
                        money |> abs |> NeedMoney |> Just
                    else
                        Nothing
            in
                ( { model | money = money }
                , out
                )


view : Model -> Html Msg
view model =
    div []
        [ p [] [ "Allowance money: $" ++ (toString model.money) |> text ]
        , button [ onClick Candy ] [ text "Blow $5 on candy" ]
        ]
