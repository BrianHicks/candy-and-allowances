module Child exposing (..)

import Html exposing (Html, div, p, text, button)
import Html.Events exposing (onClick)


type alias Model =
    { money : Float
    , jealousy : Float
    }


init : Model
init =
    { money = 0
    , jealousy = 0
    }


type Msg
    = Allowance Float
    | Candy
    | SeeOthersCandy
    | ShowOffCandy


type OutMsg
    = NeedMoney Float
    | BragAboutCandy


update : Msg -> Model -> ( Model, Maybe OutMsg )
update msg model =
    case msg of
        Allowance amount ->
            ( { model | money = model.money + amount }
            , Nothing
            )

        SeeOthersCandy ->
            ( { model | jealousy = model.jealousy + 1 }
            , Nothing
            )

        ShowOffCandy ->
            ( model
            , Just BragAboutCandy
            )

        Candy ->
            let
                money =
                    model.money - 5

                moneyMessage =
                    if money < 0 then
                        Just (NeedMoney (abs money))
                    else
                        Nothing
            in
                ( { model | money = money, jealousy = 0 }
                , moneyMessage
                )


view : Model -> Html Msg
view model =
    div []
        [ p [] [ "Allowance money: $" ++ (toString model.money) |> text ]
        , p [] [ "Jealousy: " ++ (toString model.jealousy) |> text ]
        , button [ onClick Candy ] [ text "Blow $5 on candy" ]
        , button [ onClick ShowOffCandy ] [ text "Show off sweet candy stash" ]
        ]
