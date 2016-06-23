module Parent exposing (..)

import Child
import Dict exposing (Dict)
import Html exposing (Html, text, h1, h2, h3, div, p, button)
import Html.App as App
import Html.Events exposing (onClick)


type alias Model =
    { money : Float
    , children : Dict String Child.Model
    }


init : Model
init =
    { money = 0
    , children =
        Dict.fromList
            [ ( "Trevor", Child.init )
            , ( "Jane", Child.init )
            , ( "Zort", Child.init )
            ]
    }


type Msg
    = Paycheck Float
    | Allowance
    | ChildMsg String Child.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        Paycheck amount ->
            { model | money = model.money + amount }

        Allowance ->
            let
                perChild =
                    10.0

                total =
                    perChild * (Dict.size model.children |> toFloat)

                giveTo =
                    \_ child -> Child.update (Child.Allowance perChild) child |> fst
            in
                if model.money - total < 0 then
                    model
                else
                    { model
                        | money =
                            model.money - total
                        , children =
                            Dict.map giveTo model.children
                    }

        ChildMsg name msg' ->
            case Dict.get name model.children of
                Nothing ->
                    model

                Just child ->
                    let
                        ( updated, amount ) =
                            Child.update msg' child

                        ( child', money ) =
                            if amount > 0 then
                                ( Child.update (Child.Allowance amount) updated |> fst
                                , model.money - amount
                                )
                            else
                                ( updated, model.money )

                        children =
                            Dict.insert name child' model.children
                    in
                        { model | children = children, money = money }


view : Model -> Html Msg
view model =
    div []
        ([ h1 [] [ text "Parent" ]
         , p [] [ "Money: $" ++ (toString model.money) |> text ]
         , button [ onClick (Paycheck 100) ] [ text "$100 paycheck!" ]
         , button [ onClick Allowance ] [ text "Hand out allowance" ]
         , h2 [] [ text "Children" ]
         ]
            ++ (model.children |> Dict.toList |> List.map wrappedChild)
        )


wrappedChild : ( String, Child.Model ) -> Html Msg
wrappedChild ( name, model ) =
    div []
        [ h3 [] [ text name ]
        , App.map (ChildMsg name) <| Child.view model
        ]
