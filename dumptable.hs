{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Main (main) where

import Text.XML.Cursor (fromDocument)
import Text.HTML.DOM (parseLBS)
import qualified Data.Text.Lazy.IO as TI (putStrLn)
import qualified Data.Text.IO as T (putStrLn)

import Control.Monad 
import Control.Monad.IO.Class (liftIO)

import Text.XML.Scraping (innerHtml, ename)
import Text.XML.Selector.TH

import Network.HTTP.Conduit
import Data.Conduit.Binary

main :: IO ()
main = do
    root <- fmap (fromDocument . parseLBS) $ simpleHttp "http://en.wikipedia.org/wiki/ISO_3166-1"
    let tables = queryT [jq| table.wikitable |] root
    let cs = tables
    --mapM_ (T.putStrLn . ename) tables
    mapM_ (TI.putStrLn . innerHtml) cs

