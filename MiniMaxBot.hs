
module MiniMaxBot 
(
    alphBetaBotMove
,   alphBetaBotLeaf
,   miniMaxBotMove
,   miniMaxBotLeaf
,   successor
) where

import qualified MiniMax as MM 
import qualified AlphaBeta as AB
import MetaTicTacToe
import System.Random
import MetaTicTacToeBot


alphBetaBotMove :: Integer -> StdGen -> [Move] -> Maybe Move
alphBetaBotMove depth gen moves = AB.move `fmap` alphBetaBotLeaf depth gen moves

alphBetaBotLeaf :: Integer -> StdGen -> [Move] -> Maybe (AB.Leaf Move) -- Returns Nothing if Game Alread won or noMore Valid Moves
alphBetaBotLeaf depth gen moves
    | successor moves == [] = Nothing
    | even(length moves)  = Just (AB.miniMaxLeaf moves depth successor (utilityFunc X gen))
    | odd(length moves) = Just (AB.miniMaxLeaf moves depth successor (utilityFunc O gen))

miniMaxBotMove :: Integer -> StdGen -> [Move] -> Maybe Move
miniMaxBotMove depth gen moves = MM.move `fmap` miniMaxBotLeaf depth gen moves

miniMaxBotLeaf :: Integer -> StdGen -> [Move] -> Maybe (MM.Leaf Move) -- Returns Nothing if Game Alread won or noMore Valid Moves
miniMaxBotLeaf depth gen moves
    | successor moves == [] = Nothing
    | even(length moves)  = Just (MM.miniMaxLeaf moves depth successor (utilityFunc X gen))
    | odd(length moves) = Just (MM.miniMaxLeaf moves depth successor (utilityFunc O gen))
    

subBoardWinValue = 100
midCellValue = 10
maxMinNoise = 5

utilityFunc :: XO -> StdGen -> [Move] -> Integer
utilityFunc _ _ [] = 0
utilityFunc xo gen moves = subBoardsU + gameWinU + randomOffset
    where randomOffset = fst $ randomR (-maxMinNoise, maxMinNoise) (mkStdGen seed)
            where seed = (fst $ random gen) + sum (map fst moves)
          mb = makeMoves' moves
          lsb i = look' mb i
          gsbU win
            | win == Empty = 0
            | win == xo = subBoardWinValue
            | otherwise = -subBoardWinValue
          subBoardsU = gsbU(lsb 0) + gsbU(lsb 1) + gsbU(lsb 2) + gsbU(lsb 3) + gsbU(lsb 4) + gsbU(lsb 5) + gsbU(lsb 6) + gsbU(lsb 7) + gsbU(lsb 8)
          gameWinU
            | toXO mb == Empty = 0
            | toXO mb == xo    = AB.integerInfinity
            | otherwise        = AB.integerNegInfinity
          midControlU = cellU 0 + cellU 1 + cellU 2 + cellU 3 + cellU 4 + cellU 5 + cellU 6 + cellU 7 + cellU 8
            where midBoard = getSubBoard' mb 4
                  cellU i = midXOU (look' midBoard i)
                  midXOU ox
                    | ox == Empty = 0
                    | ox == xo    = midCellValue
                    | otherwise   = -midCellValue

          
          

successor :: [Move] -> [Move]
successor moves = possibleMoves . makeMoves' $ moves