module Example exposing (testInit, testRenderFunctions, testUpdateFunctions)

import Collage exposing (group, image, shift)
import Collage.Render exposing (svgBox)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (..)
import Test exposing (..)



-- Data definitions examples


tankCenter =
    Tank 0 0


tankLeft =
    Tank (0 - (gameWidth / 2)) -1


tankRigth =
    Tank (gameWidth / 2) 1


invader1 =
    Invader 0 0 3


invader2 =
    Invader (halfGameWidth / 2) (halfGameHeight / 2) -3


invader3 =
    Invader (0 - halfGameWidth) (0 - halfGameHeight) 3


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
                            svgBox ( gameWidth, gameHeight ) <|
                                group [ image ( tankWidth, tankHeight ) tankImage |> shift ( tankCenter.x, tankY ) ]
                    in
                    renderedView |> Expect.equal initialView
            , test "return a play  view" <|
                \_ ->
                    let
                        renderedView =
                            view updatedModel

                        updatedView =
                            svgBox ( gameWidth, gameHeight ) <|
                                group
                                    [ image ( tankWidth, tankHeight ) tankImage |> shift ( tankLeft.x, tankY )
                                    , image ( invaderWidth, invaderHeight ) invaderImage
                                        |> shift ( invader1.x, invader1.y )
                                    , image ( invaderWidth, invaderHeight ) invaderImage
                                        |> shift ( invader2.x, invader2.y )
                                    , image ( invaderWidth, invaderHeight ) invaderImage
                                        |> shift ( invader3.x, invader3.y )
                                    , image ( missileWidth, missileHeight ) missileImage
                                        |> shift ( missile1.x, missile1.y )
                                    , image ( missileWidth, missileHeight ) missileImage
                                        |> shift ( missile2.x, missile2.y )
                                    , image ( missileWidth, missileHeight ) missileImage
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
                                [ image ( tankWidth, tankHeight ) tankImage |> shift ( tankLeft.x, tankY )
                                , image ( invaderWidth, invaderHeight ) invaderImage
                                    |> shift ( invader1.x, invader1.y )
                                , image ( invaderWidth, invaderHeight ) invaderImage
                                    |> shift ( invader2.x, invader2.y )
                                , image ( invaderWidth, invaderHeight ) invaderImage
                                    |> shift ( invader3.x, invader3.y )
                                , image ( missileWidth, missileHeight ) missileImage
                                    |> shift ( missile1.x, missile1.y )
                                , image ( missileWidth, missileHeight ) missileImage
                                    |> shift ( missile2.x, missile2.y )
                                , image ( missileWidth, missileHeight ) missileImage
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
                            image ( tankWidth, tankHeight ) tankImage |> shift ( tankLeft.x, tankY )
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
                            [ image ( invaderWidth, invaderHeight ) invaderImage
                                |> shift ( invader1.x, invader1.y )
                            , image ( invaderWidth, invaderHeight ) invaderImage
                                |> shift ( invader2.x, invader2.y )
                            , image ( invaderWidth, invaderHeight ) invaderImage
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
                            [ image ( missileWidth, missileHeight ) missileImage
                                |> shift ( missile1.x, missile1.y )
                            , image ( missileWidth, missileHeight ) missileImage
                                |> shift ( missile2.x, missile2.y )
                            , image ( missileWidth, missileHeight ) missileImage
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
                            image ( invaderWidth, invaderHeight ) invaderImage
                                |> shift ( invader1.x, invader1.y )
                    in
                    returnedCollage |> Expect.equal invaderCollage
            , test "render missile" <|
                \_ ->
                    let
                        returnedCollage =
                            renderMissile missile1

                        missileCollage =
                            image ( missileWidth, missileHeight ) missileImage
                                |> shift ( missile1.x, missile1.y )
                    in
                    returnedCollage |> Expect.equal missileCollage
            ]
        ]


testUpdateFunctions : Test
testUpdateFunctions =
    describe "Update functions"
        [ describe "Update"
            [ describe "KeyDown"
                [ test "Pressing Space start a game when state is Start or GameOver" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyDown Space) initialModel
                        in
                        model |> Expect.equal { initialModel | state = Play }
                , test "Pressing Space shoot a missile when state is Play" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyDown Space) updatedModel

                            newMissile =
                                Missile tankLeft.x tankY

                            updatedGame =
                                Game fullGame.tank fullGame.invaders (newMissile :: fullGame.missiles)
                        in
                        model |> Expect.equal { updatedModel | game = updatedGame }

                -- , test "Pressing left move the tank to the left when state is Play"
                -- , test "Pressing right move the tank to the right when state is Play"
                , test "shootMissile add a new missile to the game" <|
                    \_ ->
                        let
                            returnedGame =
                                shootMissile initialGame

                            newMissile =
                                Missile initialGame.tank.x tankY
                        in
                        returnedGame |> Expect.equal { initialGame | missiles = newMissile :: initialGame.missiles }
                ]

            -- , describe "KeyUp" []
            -- , describe "Tick" []
            ]
        ]
