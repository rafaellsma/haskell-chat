{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Chat where

import Import

getChatR :: ChannelId -> Handler Html
getChatR channelId = do
    channel <- runDB $ get404 channelId
    defaultLayout $ do
        setTitle "Chat Monstro"
        $(widgetFile "chat")
