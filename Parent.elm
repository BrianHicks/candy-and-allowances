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
                        ( updated, childMsg ) =
                            Child.update msg' child

                        ( child', model' ) =
                            updateFromChild childMsg name updated model

                        children =
                            Dict.insert name child' model'.children
                    in
                        { model' | children = children }


updateFromChild : Maybe Child.OutMsg -> String -> Child.Model -> Model -> ( Child.Model, Model )
updateFromChild msg name child model =
    case msg of
        Nothing ->
            ( child, model )

        Just (Child.NeedMoney amount) ->
            if amount > 0 then
                ( Child.update (Child.Allowance amount) child |> fst
                , { model | money = model.money - amount }
                )
            else
                ( child, model )

        Just Child.BragAboutCandy ->
            let
                showOff =
                    \name' child ->
                        if name' == name then
                            child
                        else
                            Child.update Child.SeeOthersCandy child |> fst
            in
                ( child
                , { model | children = Dict.map showOff model.children })


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
