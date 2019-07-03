module Main exposing (Game, Invader, Key(..), Missile, Model, Msg(..), State(..), Tank, assetsDir, fromCode, gameHeight, gameWidth, halfGameHeight, halfGameWidth, hitRange, init, initialGame, initialModel, initialTank, invaderHeight, invaderImage, invaderRate, invaderWidth, invaderXspeed, invaderYspeed, keyDecoder, main, missileHeight, missileImage, missileSpeed, missileWidth, render, renderInvader, renderListOfInvaders, renderListOfMissiles, renderMissile, renderTank, shootMissile, subscriptions, tankHeight, tankImage, tankSpeed, tankWidth, tankY, update, view)

import Browser
import Browser.Events as Events
import Collage exposing (Collage, group, image, shift)
import Collage.Render exposing (svgBox)
import Html exposing (..)
import Json.Decode as Decode



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


halfGameWidth =
    gameWidth / 2


halfGameHeight =
    gameHeight / 2


assetsDir =
    "../assets/"


tankWidth =
    20


tankHeight =
    20


tankY =
    -1 * (halfGameHeight - tankHeight)


tankImage =
    assetsDir ++ "Starfighter.png"


tankSpeed =
    2


missileHeight =
    15


missileWidth =
    5


missileImage =
    assetsDir ++ "Missile.png"


missileSpeed =
    5


invaderHeight =
    15


invaderWidth =
    20


invaderImage =
    assetsDir ++ "Nave.png"


invaderXspeed =
    -- I may don't need this one
    1.5


invaderYspeed =
    1.5


invaderRate =
    100


hitRange =
    10



-- Data definitions:


type alias Tank =
    { x : Float
    , dir : Float
    }


initialTank : Tank
initialTank =
    Tank 0 0



{-
   -- Tank is: Tank Float Float[-1, 1]
   -- interp. a tank at position x, (tankY)
              with a direction dir (left -1, right 1, no movement 0)
              tank move at speed (tankSpeed * dir) pixels per clock-tick

   tank  = Tank 6 1  -- going right
   tank  = Tank 6 -1 -- going left

   fnForTank : Tank -> ...
   fnForTank tank =
     ... tank.x    -- number
     ... tank.dir  -- number

   -- Template rules used:
   --   - compound: 2 fields
-}


type alias Invader =
    { x : Float
    , y : Float
    , speedX : Float
    }



{-
   -- Invader is: Invader x y
   -- interp. a invader at position x y,
              and speedX per clock tick along x axis (negative number left, positive number right)
            NOTE: the starter file declares dx: the invader along x by dx pixels per clock tick

   invader  = Invader 6 16 -3

   fnForInvader : Invader -> ...
   fnForInvader invader =
     ... invader.x   -- number
         invader.y   -- number
         invader.speedX -- number [-1,1]

   -- Template rules used:
   --   - compound: 3 fields
-}
{-
   -- [Invader] is one of:
   --   - []
   --   - Invader :: [Invader]
   -- interp. a list of Invader
   invader0 = []
   invader1 = [Invader 10 20 3, Invader 20 20 -3]

   fnForListOfInvaders : [Invader] -> ...
   fnForListOfInvaders invaders =
     case invaders of
       [] -> []
       first::rest -> (fnForInvader first) :: (fnForListOfInvaders rest)

   -- Template rules used:
   --   - one of: 2 cases
   --   - atomic distinct: empty
   --   - compound: Invader :: ListOfInvader
   --   - reference: first is Invader
   --   - self-reference: rest is [Invader]
-}


type alias Missile =
    { x : Float
    , y : Float
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

   game  = Game (Tank 8 -1) [Invader 5 10] [Missile 10 20]

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
   --    - atomic distinct: Start
   --    - atomic distinct: Play
   --    - atomic distinct: GameOver
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

   model  = Model Start <| Game (Tank 8 0) [] []

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
    = KeyDown Key
    | KeyUp Key
    | Tick Float
    | NoOp



{- Msg is one of:
       - KeyDown Key
       - KeyUp Key
       - Tick Float
       - NoOp
     interp. KeyDown and KeyUp are keyboard events. Tick is a time based event
     -- <examples are redundant for enumerations>

   fnForMsg : Msg -> ...
   fnForMsg msg =
     case msg of
       KeyDown key -> ... key
       KeyUp key -> ... key
       Tick x -> ... x
       NoOp -> ...

   -- Template rules used:
   --  - one of: 4 cases
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDown key ->
            ( keyDown key model, Cmd.none )

        KeyUp key ->
            ( keyUp key model, Cmd.none )

        Tick tick ->
            ( onTick tick model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


keyDown : Key -> Model -> Model
keyDown key model =
    case key of
        Space ->
            if model.state == Start then
                { model | state = Play }

            else
                { model | game = shootMissile model.game }

        ArrowLeft ->
            model

        ArrowRight ->
            model

        _ ->
            model


keyUp : Key -> Model -> Model
keyUp key model =
    initialModel


onTick : Float -> Model -> Model
onTick tick model =
    initialModel


shootMissile : Game -> Game
shootMissile game =
    let
        newMissile =
            Missile game.tank.x tankY
    in
    { game | missiles = newMissile :: game.missiles }



-- SUBSCRIPTIONS


type Key
    = Space
    | ArrowLeft
    | ArrowRight
    | Unknown



{- Key is one of:
       - Space
       - ArrowLeft
       - ArrowRight
       - Unknown
     interp. Key is the code of the key pressed
     -- <examples are redundant for enumerations>

   fnForKey : Key -> ...
   fnForKey key =
     case key of
       Space -> ...
       ArrowLeft -> ...
       ArrowRight -> ...
       _ -> ...

   -- Template rules used:
   --  - one of: 4 cases
-}


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Events.onAnimationFrameDelta Tick
        , Events.onKeyDown (Decode.map KeyDown keyDecoder)
        , Events.onKeyUp (Decode.map KeyUp keyDecoder)
        ]


keyDecoder : Decode.Decoder Key
keyDecoder =
    Decode.map fromCode (Decode.field "key" Decode.string)


fromCode : String -> Key
fromCode keyCode =
    case keyCode of
        " " ->
            Space

        "ArrowLeft" ->
            ArrowLeft

        "ArrowRight" ->
            ArrowRight

        _ ->
            Unknown



-- VIEW
-- Render current state of the game in the screen according to the model


view : Model -> Html Msg
view model =
    svgBox ( gameWidth, gameHeight ) <| render model.game


render : Game -> Collage msg
render game =
    let
        gameObjects =
            renderTank game.tank :: renderListOfInvaders game.invaders ++ renderListOfMissiles game.missiles
    in
    group gameObjects


renderTank : Tank -> Collage msg
renderTank tank =
    image ( tankWidth, tankHeight ) tankImage |> shift ( tank.x, tankY )


renderListOfInvaders : List Invader -> List (Collage msg)
renderListOfInvaders invaders =
    case invaders of
        [] ->
            []

        first :: rest ->
            renderInvader first :: renderListOfInvaders rest


renderListOfMissiles : List Missile -> List (Collage msg)
renderListOfMissiles missiles =
    case missiles of
        [] ->
            []

        first :: rest ->
            renderMissile first :: renderListOfMissiles rest


renderInvader : Invader -> Collage msg
renderInvader invader =
    image ( invaderWidth, invaderHeight ) invaderImage |> shift ( invader.x, invader.y )


renderMissile : Missile -> Collage msg
renderMissile missile =
    image ( missileWidth, missileHeight ) missileImage |> shift ( missile.x, missile.y )
