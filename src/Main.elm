module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}
    , Cmd.none
    )



-- UPDATE


type Msg
    = Left
    | Right


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Left ->
            ( {}
            , Cmd.none
            )

        Right ->
            ( {}
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    h1 [] [ text "Output goes here" ]
