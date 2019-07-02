module Example exposing (testInit, testRenderFunctions)

import Collage exposing (group, image, shift)
import Collage.Render exposing (svgBox)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (..)
import Test exposing (..)



-- Data definitions examples


tankCenter =
    Tank 0


tankLeft =
    Tank (0 - (gameWidth / 2))


tankRigth =
    Tank (gameWidth / 2)


invader1 =
    Invader 0 0 3


invader2 =
    Invader (halfGameHeight / 2) (halfGameWidth / 2) -3


invader3 =
    Invader (0 - halfGameHeight) (0 - halfGameWidth) 3


emptyListOfInvaders =
    []


listOfInvaders =
    [ invader1, invader2, invader3 ]


missile1 =
    Missile -20 10


missile2 =
    Missile 0 0


missile3 =
    Missile 10 -20


emptyListOfMissiles =
    []


listOfMissiles =
    [ missile1, missile2, missile3 ]


initialGame =
    Game tankCenter emptyListOfInvaders emptyListOfMissiles


fullGame =
    Game tankLeft listOfInvaders listOfMissiles


initialModel =
    Model Start initialGame


updatedModel =
    Model Play fullGame


endModel =
    Model GameOver initialGame


testInit : Test
testInit =
    describe "init"
        [ test "return initial Model" <|
            \_ ->
                let
                    ( model, _ ) =
                        init ()
                in
                model |> Expect.equal initialModel
        ]


testRenderFunctions : Test
testRenderFunctions =
    describe "Render functions"
        [ describe "view"
            [ test "return the initial view" <|
                \_ ->
                    let
                        renderedView =
                            view initialModel

                        initialView =
                            svgBox ( gameHeight, gameWidth ) <|
                                group [ image ( tankHeight, tankWidth ) tankImage |> shift ( tankCenter.x, tankY ) ]
                    in
                    renderedView |> Expect.equal initialView
            , test "return a play  view" <|
                \_ ->
                    let
                        renderedView =
                            view updatedModel

                        updatedView =
                            svgBox ( gameHeight, gameWidth ) <|
                                group
                                    [ image ( tankHeight, tankWidth ) tankImage |> shift ( tankLeft.x, tankY )
                                    , image ( invaderHeight, invaderWidth ) invaderImage
                                        |> shift ( invader1.x, invader1.y )
                                    , image ( invaderHeight, invaderWidth ) invaderImage
                                        |> shift ( invader2.x, invader2.y )
                                    , image ( invaderHeight, invaderWidth ) invaderImage
                                        |> shift ( invader3.x, invader3.y )
                                    , image ( missileHeight, missileWidth ) missileImage
                                        |> shift ( missile1.x, missile1.y )
                                    , image ( missileHeight, missileWidth ) missileImage
                                        |> shift ( missile2.x, missile2.y )
                                    , image ( missileHeight, missileWidth ) missileImage
                                        |> shift ( missile3.x, missile3.y )
                                    ]
                    in
                    renderedView |> Expect.equal updatedView
            ]
        , describe "render"
            [ test "create a collage with the game" <|
                \_ ->
                    let
                        returnedGameCollage =
                            render fullGame

                        fullGameCollage =
                            group
                                [ image ( tankHeight, tankWidth ) tankImage |> shift ( tankLeft.x, tankY )
                                , image ( invaderHeight, invaderWidth ) invaderImage
                                    |> shift ( invader1.x, invader1.y )
                                , image ( invaderHeight, invaderWidth ) invaderImage
                                    |> shift ( invader2.x, invader2.y )
                                , image ( invaderHeight, invaderWidth ) invaderImage
                                    |> shift ( invader3.x, invader3.y )
                                , image ( missileHeight, missileWidth ) missileImage
                                    |> shift ( missile1.x, missile1.y )
                                , image ( missileHeight, missileWidth ) missileImage
                                    |> shift ( missile2.x, missile2.y )
                                , image ( missileHeight, missileWidth ) missileImage
                                    |> shift ( missile3.x, missile3.y )
                                ]
                    in
                    returnedGameCollage |> Expect.equal fullGameCollage
            ]
        , describe "renderTank"
            [ test "return a Collage of a tank" <|
                \_ ->
                    let
                        returnedTankCollage =
                            renderTank tankLeft

                        tankLeftCollage =
                            image ( tankHeight, tankWidth ) tankImage |> shift ( tankLeft.x, tankY )
                    in
                    returnedTankCollage |> Expect.equal tankLeftCollage
            ]
        , describe "render Lists"
            [ test "render list of invaders" <|
                \_ ->
                    let
                        returnedCollageList =
                            renderListOfInvaders listOfInvaders

                        invadersCollageList =
                            [ image ( invaderHeight, invaderWidth ) invaderImage
                                |> shift ( invader1.x, invader1.y )
                            , image ( invaderHeight, invaderWidth ) invaderImage
                                |> shift ( invader2.x, invader2.y )
                            , image ( invaderHeight, invaderWidth ) invaderImage
                                |> shift ( invader3.x, invader3.y )
                            ]
                    in
                    returnedCollageList |> Expect.equal invadersCollageList
            , test "render lists of missiles" <|
                \_ ->
                    let
                        returnedCollageList =
                            renderListOfMissiles listOfMissiles

                        missilesCollageList =
                            [ image ( missileHeight, missileWidth ) missileImage
                                |> shift ( missile1.x, missile1.y )
                            , image ( missileHeight, missileWidth ) missileImage
                                |> shift ( missile2.x, missile2.y )
                            , image ( missileHeight, missileWidth ) missileImage
                                |> shift ( missile3.x, missile3.y )
                            ]
                    in
                    returnedCollageList |> Expect.equal missilesCollageList
            , test "render invader" <|
                \_ ->
                    let
                        returnedCollage =
                            renderInvader invader1

                        invaderCollage =
                            image ( invaderHeight, invaderWidth ) invaderImage
                                |> shift ( invader1.x, invader1.y )
                    in
                    returnedCollage |> Expect.equal invaderCollage
            , test "render missile" <|
                \_ ->
                    let
                        returnedCollage =
                            renderMissile missile1

                        missileCollage =
                            image ( missileHeight, missileWidth ) missileImage
                                |> shift ( missile1.x, missile1.y )
                    in
                    returnedCollage |> Expect.equal missileCollage
            ]
        ]
