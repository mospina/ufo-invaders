module Example exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (..)
import Test exposing (..)



-- Data definitions examples


tankCenter =
    Tank (gameWidth // 2)


tankLeft =
    Tank 0


tankRigth =
    Tank gameWidth


invader1 =
    Invader 10 10


invader2 =
    Invader (gameHeight // 2) (gameWidth // 2)


invader3 =
    Invader (gameHeight - 30) (gameWidth - 20)


emptyListOfInvaders =
    []


listOfInvaders =
    [ invader1, invader2, invader3 ]


missile1 =
    Missile (gameHeight - 20) 10


missile2 =
    Missile (gameHeight // 2) (gameWidth // 2)


missile3 =
    Missile 10 (gameWidth - 20)


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


suite : Test
suite =
    describe "init"
        [ test "return initial Model" <|
            \_ ->
                let
                    ( model, _ ) =
                        init ()
                in
                model |> Expect.equal initialModel
        ]
