module Parent exposing (..)

import Child
import Dict exposing (Dict)
import Html exposing (Html, text, h1, h2, h3, div, p, button)
import Html exposing (program)
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
                    \_ child -> Child.update (Child.Allowance perChild) child |> Tuple.first
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

        ChildMsg name msg_ ->
            case Dict.get name model.children of
                Nothing ->
                    model

                Just child ->
                    let
                        ( updated, childMsg ) =
                            Child.update msg_ child

                        ( child_, model_ ) =
                            updateFromChild childMsg name updated model

                        children =
                            Dict.insert name child_ model_.children
                    in
                        { model_ | children = children }


updateFromChild : Maybe Child.OutMsg -> String -> Child.Model -> Model -> ( Child.Model, Model )
updateFromChild msg name child model =
    case msg of
        Nothing ->
            ( child, model )

        Just (Child.NeedMoney amount) ->
            if amount > 0 then
                ( Child.update (Child.Allowance amount) child |> Tuple.first
                , { model | money = model.money - amount }
                )
            else
                ( child, model )

        Just Child.BragAboutCandy ->
            let
                showOff =
                    \name_ child ->
                        if name_ == name then
                            child
                        else
                            Child.update Child.SeeOthersCandy child |> Tuple.first
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
        , Html.map (ChildMsg name) <| Child.view model
        ]
