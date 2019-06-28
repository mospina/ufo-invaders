module Main exposing (Game, Invader, Missile, Model, Msg(..), State(..), Tank, assetsDir, gameHeight, gameWidth, hitRange, init, invaderImage, invaderRate, invaderXspeed, invaderYspeed, main, missileImage, missileSpeed, subscriptions, tankImage, tankSpeed, tankY, update, view)

import Browser
import Collage exposing (image)
import Collage.Render exposing (svgBox)
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
-- Constants:
-- speed values (not velocities) are given in pixels per tick


gameWidth =
    400


gameHeight =
    600


assetsDir =
    "../assets/"


tankY =
    gameHeight - 50


tankImage =
    assetsDir ++ "Starfighter.png"


tankSpeed =
    2


missileImage =
    assetsDir ++ "Missile.png"


missileSpeed =
    5


invaderImage =
    assetsDir ++ "Nave.png"


invaderXspeed =
    1.5


invaderYspeed =
    1.5


invaderRate =
    100


hitRange =
    10



-- Data definitions:


type alias Tank =
    { x : Int }


initialTank : Tank
initialTank =
    Tank (gameWidth // 2)



{-
   -- Tank is: Tank x
   -- interp. a tank at position x, tankY
              tank move at speed tankSpeed pixels per clock-tick
              direction is given by the arrow key < or >
           NOTE: the starter file declares a direction dir as Integer[-1 1]

   tank  = Tank 6

   fnForTank : Tank -> ...
   fnForTank tank =
     ... tank.x  -- number

   -- Template rules used:
   --   - compound: 1 fields
-}


type alias Invader =
    { x : Int
    , y : Int
    }



{-
   -- Invader is: Invader x y
   -- interp. a invader at position x y
            NOTE: the starter file declares dx: the invader along x by dx pixels per clock tick

   invader  = Invader 6 16

   fnForInvader : Invader -> ...
   fnForInvader invader =
     ... invader.x  -- number
         invader.y  -- number

   -- Template rules used:
   --   - compound: 2 fields
-}
{-
   -- [Invader] is one of:
   --   - []
   --   - Invader :: [Invader]
   -- interp. a list of Invader
   invader0 = []
   invader1 = [Invader 10 20, Invader 20 20]

   fnForListOfInvaders : [Invader] -> ...
   fnForListOfInvaders invaders =
     case invaders of
       [] -> []
       (first:rest) -> (fnForInvader first) :: (fnForListOfInvaders rest)

   -- Template rules used:
   --   - one of: 2 cases
   --   - atomic distinct: empty
   --   - compound: Invader :: ListOfInvader
   --   - reference: first is Invader
   --   - self-reference: rest is [Invader]
-}


type alias Missile =
    { x : Int
    , y : Int
    }



{-
   -- Missile is: Missile x y
   -- interp. a missile at position x y

   missile  = Missile 6 16

   fnForMissile : Missile -> ...
   fnForMissile missile =
     ... missile.x  -- number
         missile.y  -- number

   -- Template rules used:
   --   - compound: 2 fields
-}
{-
   -- [Missile] is one of:
   --   - []
   --   - Missile :: [Missile]
   -- interp. a list of Missile
   missile0 = []
   missile1 = [Missile 10 20, Missile 20 20]

   fnForListOfMissiles : [Missile] -> ...
   fnForListOfMissiles missiles =
     case missiles of
       [] -> []
       (first:rest) -> (fnForMissile first) :: (fnForListOfMissiles rest)

   -- Template rules used:
   --   - one of: 2 cases
   --   - atomic distinct: empty
   --   - compound: Missile :: ListOfMissile
   --   - reference: first is Missile
   --   - self-reference: rest is [Missile]
-}


type alias Game =
    { tank : Tank
    , invaders : List Invader
    , missiles : List Missile
    }


initialGame : Game
initialGame =
    Game initialTank [] []



{-
   -- Game is: Game Tank [Invader] [Missile]
   -- interp. a game with the defending tank, the current invaders and fired missiles

   game  = Game (Tank 8) [Invader 5 10] [Missile 10 20]

   fnForGame : Game -> ...
   fnForGame game =
     ... fnForTank game.tank      -- number
         fnForListOfInvaders game.invaders  -- listOfInvaders
         fnForListOfMissiles game.missiles  -- listOfMissiles

   -- Template rules used:
   --   - compound: 3 fields
   --   - references:
   --     - tank field is Tank
   --     - invaders is [Invaders]
   --     - missiles is [Missile]
-}


type State
    = Start
    | Play
    | GameOver



{- State is one of:
       - Start
       - Play
       - GameOver
     interp. the state of the curent game
     -- <examples are redundant for enumerations>

   fnForState : State -> ...
   fnForState state =
     case state of
       Red -> ...
       Yellow -> ...
       Green -> ...

   -- Template rules used:
   --  - one of: 3 cases
   --    - atomic distinct: Red
   --    - atomic distinct: Yellow
   --    - atomic distinct: Green
-}


type alias Model =
    { state : State
    , game : Game
    }


initialModel =
    Model Start initialGame



{-
   -- Model is: Model State Game
   -- interp. a model with the state of the game and the game itself

   model  = Model Start <| Game (Tank 8) [] []

   fnForModel : Model -> ...
   fnForModel model =
     ... fnForState model.state              -- State
         fnForGame  model.game               -- Game

   -- Template rules used:
   --   - compound: 2 fields
   --   - references:
   --     - state field is State
   --     - game field is Game
-}


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
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
            ( initialModel
            , Cmd.none
            )

        Right ->
            ( initialModel
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
