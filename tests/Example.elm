module Example exposing (testGenerateInvader, testInit, testRenderFunctions, testUpdateFunctions)

import Collage exposing (group, image, shift)
import Collage.Render exposing (svgBox)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (..)
import Random
import Test exposing (..)



-- Data definitions examples


tankCenter =
    Tank 0 0


tankLeft =
    Tank (0 - (gameWidth / 2)) -1


tankRigth =
    Tank (gameWidth / 2) 1


invader1 =
    Invader 0 0 0


invader2 =
    Invader (halfGameWidth / 2) (halfGameHeight / 2) -1


invader3 =
    Invader (0 - halfGameWidth) (0 - halfGameHeight) 1


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
                , test "Pressing right change direction to the right when state is Play" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyDown ArrowRight) updatedModel

                            expectedGame =
                                Game { tankLeft | dir = 1 } listOfInvaders listOfMissiles
                        in
                        model |> Expect.equal { updatedModel | game = expectedGame }
                , test "Pressing left change direction to the left when state is Play" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyDown ArrowLeft) { initialModel | state = Play }

                            expectedGame =
                                Game { tankCenter | dir = -1 } [] []

                            expectedModel =
                                Model Play expectedGame
                        in
                        model |> Expect.equal expectedModel
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
            , describe "KeyUp"
                [ test "Releasing Space does nothing" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyUp Space) updatedModel
                        in
                        model |> Expect.equal updatedModel
                , test "Releasing right change direction to static when state is Play" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyUp ArrowRight) updatedModel

                            expectedGame =
                                Game { tankLeft | dir = 0 } listOfInvaders listOfMissiles
                        in
                        model |> Expect.equal { updatedModel | game = expectedGame }
                , test "Releasing left change direction to static when state is Play" <|
                    \_ ->
                        let
                            ( model, _ ) =
                                update (KeyUp ArrowLeft) { initialModel | state = Play }

                            expectedGame =
                                Game { tankCenter | dir = 0 } [] []

                            expectedModel =
                                Model Play expectedGame
                        in
                        model |> Expect.equal expectedModel
                ]
            , describe "Tick"
                [ test "onTick updates the game physics" <|
                    \_ ->
                        let
                            model =
                                onTick 1 updatedModel

                            updatedTank =
                                { tankLeft | x = tankLeft.x + (tankSpeed * tankLeft.dir) }

                            updatedInvaders =
                                List.map
                                    (\i ->
                                        { i
                                            | y = i.y + invaderYspeed
                                            , x = i.x + (invaderXspeed * i.dir)
                                        }
                                    )
                                    [ invader2, invader3 ]

                            updatedMissiles =
                                List.map (\m -> { m | y = m.y + missileSpeed }) [ missile1, missile3 ]

                            updatedFullGame =
                                Game updatedTank updatedInvaders updatedMissiles

                            expectedModel =
                                { updatedModel | game = updatedFullGame }
                        in
                        model |> Expect.equal expectedModel
                , test "onTick doesn't updates the game when status is Play" <|
                    \_ -> onTick 1 initialModel |> Expect.equal initialModel
                , test "updateTank updates the position of the tank" <|
                    \_ ->
                        let
                            tank =
                                updateTank tankRigth

                            updatedTank =
                                { tankRigth | x = tankRigth.x + (tankSpeed * tankRigth.dir) }
                        in
                        tank |> Expect.equal updatedTank

                --, test "updateTank stop the thank if tank is in the left or right border" <|
                , test "updateMissiles update the position of the missiles and filter them on collision" <|
                    \_ ->
                        let
                            missiles =
                                updateMissiles listOfMissiles listOfInvaders

                            updatedMissiles =
                                List.map (\m -> { m | y = m.y + missileSpeed }) [ missile1, missile3 ]
                        in
                        missiles |> Expect.equal updatedMissiles
                , test "updateMissile update the position of a missile" <|
                    \_ ->
                        let
                            missile =
                                updateMissile missile1
                        in
                        missile |> Expect.equal { missile1 | y = missile1.y + missileSpeed }
                , test "updateInvaders updates the position of the invaders and filter them on collision" <|
                    \_ ->
                        let
                            invaders =
                                updateInvaders listOfInvaders listOfMissiles

                            updatedInvaders =
                                List.map
                                    (\i ->
                                        { i
                                            | y = i.y + invaderYspeed
                                            , x = i.x + (i.dir * invaderXspeed)
                                        }
                                    )
                                    [ invader2, invader3 ]
                        in
                        invaders |> Expect.equal updatedInvaders
                , test "updateInvader update the position of a invader" <|
                    \_ ->
                        let
                            invader =
                                updateInvader invader2
                        in
                        invader
                            |> Expect.equal
                                { invader2
                                    | y = invader2.y + invaderYspeed
                                    , x = invader2.x + (invaderXspeed * invader2.dir)
                                }

                --, test "updateInvader change direction if it gets to the left border" <|
                --, test "updateInvader change direction if it gets to the right border" <|
                --, test "the game end if an invader reach the buttom" <|
                ]
            , describe "Invade"
                [ test "invade add a new Invader to the game" <|
                    \_ ->
                        let
                            newInvader =
                                Invader 0 -halfGameHeight -1

                            game =
                                onInvade fullGame (Just newInvader)

                            updatedGame =
                                { fullGame | invaders = newInvader :: fullGame.invaders }
                        in
                        game |> Expect.equal updatedGame
                , test "invade doesn't do anything when maybe is Nothing" <|
                    \_ -> onInvade fullGame Nothing |> Expect.equal fullGame
                ]
            ]
        ]


testGenerateInvader : Test
testGenerateInvader =
    let
        seed =
            Random.initialSeed 12345

        ( maybeInvader, _ ) =
            Random.step generateInvader seed
    in
    describe "generateInvader"
        [ test "Generated invader has the right y coordinate" <|
            \_ ->
                case maybeInvader of
                    Just invader ->
                        invader.y |> Expect.equal halfGameHeight

                    Nothing ->
                        Expect.pass
        , test "Generated invader has the right x coordinate" <|
            \_ ->
                case maybeInvader of
                    Just invader ->
                        Expect.true "x is not in the range"
                            (invader.x >= -halfGameWidth && invader.x <= halfGameWidth)

                    Nothing ->
                        Expect.pass
        ]
