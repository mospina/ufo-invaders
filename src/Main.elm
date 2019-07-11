module Main exposing (Game, Invader, Key(..), Missile, Model, Msg(..), State(..), Tank, assetsDir, fromCode, gameHeight, gameWidth, generateInvader, halfGameHeight, halfGameWidth, init, initialGame, initialModel, initialTank, invaderCollide, invaderHeight, invaderImage, invaderWidth, invaderXspeed, invaderYspeed, keyDecoder, keyDown, keyUp, main, missileCollide, missileHeight, missileImage, missileSpeed, missileWidth, onInvade, onTick, render, renderInvader, renderListOfInvaders, renderListOfMissiles, renderMissile, renderTank, shootMissile, subscriptions, tankHeight, tankImage, tankSpeed, tankWidth, tankY, update, updateGame, updateInvader, updateInvaderDir, updateInvaders, updateMissile, updateMissiles, updateTank, updateTankDirection, view)

import Browser
import Browser.Events as Events
import Collage exposing (Collage, group, image, shift)
import Collage.Render exposing (svgBox)
import Html exposing (..)
import Json.Decode as Decode
import Random exposing (Generator)



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
    1.5


invaderYspeed =
    -1.5



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
     ... tank.x    -- Float
     ... tank.dir  -- Float

   -- Template rules used:
   --   - compound: 2 fields
-}


type alias Invader =
    { x : Float
    , y : Float
    , dir : Float
    }



{-
      -- Invader is: Invader x y dir
      -- interp. a invader at position x y,
                 and direction dir[-1, 1] (left -1. right 1, straight 0)
                 Invader moves at speed (invaderXspeed * dir) pixels per clock-tick
                 on the X axis and invaderYspeed on the Y axis.

      invader  = Invader 6 16 -1 -- moving left

      fnForInvader : Invader -> ...
      fnForInvader invader =
        ... invader.x   -- float
            invader.y   -- float
            invader.dir -- float [-1,1]

      -- Template rules used:
      --   - compound: 3 fields

   ----------------------------------------------

      -- [Invader] is one of:
      --   - []
      --   - Invader :: [Invader]
      -- interp. a list of Invader

      invader0 = []
      invader1 = [Invader 10 20 1, Invader 20 20 -1]

      fnForListOfInvaders : List Invader -> ...
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
        ... missile.x  -- float
            missile.y  -- float

      -- Template rules used:
      --   - compound: 2 fields

   ----------------------------------------------

      -- [Missile] is one of:
      --   - []
      --   - Missile :: [Missile]
      -- interp. a list of Missile

      missile0 = []
      missile1 = [Missile 10 20, Missile 20 20]

      fnForListOfMissiles : List Missile -> ...
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
     ... fnForTank game.tank                -- Tank
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
       Start -> ...
       Play -> ...
       GameOver -> ...

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

   model  = Model Start (Game (Tank 8 0) [] [])

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
    | Invade (Maybe Invader)



{- Msg is one of:
       - KeyDown Key
       - KeyUp Key
       - Tick Float
       - Invade (Maybe Invader)
     interp. KeyDown and KeyUp are keyboard events.
             Tick is a time based event
             Invade is a command to add random invaders

     -- <examples are redundant for enumerations>

   fnForMsg : Msg -> ...
   fnForMsg msg =
     case msg of
       KeyDown key -> ... key
       KeyUp key -> ... key
       Tick tick -> ...
       Invade maybeInvader -> ...

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

        Tick _ ->
            case model.state of
                Play ->
                    ( onTick model, Random.generate Invade generateInvader )

                _ ->
                    ( model, Cmd.none )

        Invade maybeInvader ->
            case model.state of
                Play ->
                    ( { model | game = onInvade model.game maybeInvader }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


keyDown : Key -> Model -> Model
keyDown key model =
    case key of
        Space ->
            if model.state == Play then
                { model | game = shootMissile model.game }

            else
                { model | state = Play }

        ArrowLeft ->
            if model.state == Play then
                { model | game = updateTankDirection model.game -1 }

            else
                model

        ArrowRight ->
            if model.state == Play then
                { model | game = updateTankDirection model.game 1 }

            else
                model

        _ ->
            model


keyUp : Key -> Model -> Model
keyUp key model =
    case key of
        ArrowLeft ->
            if model.state == Play then
                { model | game = updateTankDirection model.game 0 }

            else
                model

        ArrowRight ->
            if model.state == Play then
                { model | game = updateTankDirection model.game 0 }

            else
                model

        _ ->
            model


onTick : Model -> Model
onTick model =
    { model
        | game = updateGame model.game
        , state = checkState model.game
    }


checkState : Game -> State
checkState game =
    if invasionCompleted game.invaders then
        GameOver

    else
        Play


invasionCompleted : List Invader -> Bool
invasionCompleted invaders =
    case invaders of
        [] ->
            False

        first :: rest ->
            if first.y <= -halfGameHeight then
                True

            else
                invasionCompleted rest


onInvade : Game -> Maybe Invader -> Game
onInvade game maybeInvader =
    case maybeInvader of
        Just invader ->
            { game | invaders = invader :: game.invaders }

        Nothing ->
            game


updateGame : Game -> Game
updateGame game =
    { game
        | tank = updateTank game.tank
        , invaders = updateInvaders game.invaders game.missiles
        , missiles = updateMissiles game.missiles game.invaders
    }


updateTank : Tank -> Tank
updateTank tank =
    if tank.x <= -halfGameWidth && tank.dir < 0 then
        tank

    else if tank.x >= halfGameWidth && tank.dir > 0 then
        tank

    else
        { tank | x = tank.x + (tankSpeed * tank.dir) }


updateTankDirection : Game -> Float -> Game
updateTankDirection game newDir =
    let
        updatedTank =
            Tank game.tank.x newDir
    in
    { game | tank = updatedTank }


updateInvaders : List Invader -> List Missile -> List Invader
updateInvaders invaders missiles =
    case invaders of
        [] ->
            []

        first :: rest ->
            if invaderCollide first missiles then
                updateInvaders rest missiles

            else
                updateInvader first :: updateInvaders rest missiles


invaderCollide : Invader -> List Missile -> Bool
invaderCollide invader missiles =
    case missiles of
        [] ->
            False

        first :: rest ->
            if hit first invader then
                True

            else
                invaderCollide invader rest


updateInvader : Invader -> Invader
updateInvader invader =
    { invader
        | x = invader.x + (invader.dir * invaderXspeed)
        , y = invader.y + invaderYspeed
        , dir = updateInvaderDir invader
    }


updateInvaderDir : Invader -> Float
updateInvaderDir invader =
    if invader.x <= -halfGameWidth && invader.dir < 0 then
        invader.dir * -1

    else if invader.x >= halfGameWidth && invader.dir > 0 then
        invader.dir * -1

    else
        invader.dir


generateInvader : Generator (Maybe Invader)
generateInvader =
    let
        randomX =
            Random.float -halfGameWidth halfGameWidth

        randomDir =
            Random.float -1 1

        invadeOrNot =
            Random.weighted ( 1, True ) [ ( 99, False ) ]

        maybeInvader bool x dir =
            case bool of
                True ->
                    Just (Invader x halfGameHeight dir)

                False ->
                    Nothing
    in
    Random.map3 maybeInvader invadeOrNot randomX randomDir


updateMissiles : List Missile -> List Invader -> List Missile
updateMissiles missiles invaders =
    case missiles of
        [] ->
            []

        first :: rest ->
            if missileCollide first invaders then
                updateMissiles rest invaders

            else
                updateMissile first :: updateMissiles rest invaders


updateMissile : Missile -> Missile
updateMissile missile =
    { missile | y = missile.y + missileSpeed }


missileCollide : Missile -> List Invader -> Bool
missileCollide missile invaders =
    case invaders of
        [] ->
            False

        first :: rest ->
            if hit missile first then
                True

            else
                missileCollide missile rest


shootMissile : Game -> Game
shootMissile game =
    let
        newMissile =
            Missile game.tank.x tankY
    in
    { game | missiles = newMissile :: game.missiles }


hit : Missile -> Invader -> Bool
hit missile invader =
    let
        halfInvaderWidth =
            invaderWidth / 2

        halfInvaderHeight =
            invaderHeight / 2
    in
    if
        missile.x
            >= (invader.x - halfInvaderWidth)
            && missile.x
            <= (invader.x + halfInvaderWidth)
            && missile.y
            >= (invader.y - halfInvaderHeight)
            && missile.y
            <= (invader.y + halfInvaderHeight)
    then
        True

    else
        False



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
