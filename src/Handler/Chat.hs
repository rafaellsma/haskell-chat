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
    allMessages <- runDB $ selectList [MessageChannelId ==. (Just channelId)] [Asc MessageId]
    defaultLayout $ do
        setTitle "Chat Monstro"
        $(widgetFile "chat")

showMessageUser :: Entity Message -> Widget
showMessageUser (Entity _ message) = do
    muserid <- maybeAuthId
    case (messageUserId message) of
        (Just userid) -> do
            user <- handlerToWidget $ runDB $ get404 $ userid
            $(widgetFile "message")

getMessageClass :: Maybe UserId -> UserId -> Text
getMessageClass Nothing _ = "other"
getMessageClass (Just x) y =
    if x == y
        then "me"
        else "other"