{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Message where

import Import

postMessageR :: ChannelId -> Handler Value
postMessageR channelId = do
    message <- (requireJsonBody :: Handler Message)
    muser <- maybeAuth
    case muser of
        Nothing -> sendResponseStatus status403 ("UNAUTHORIZED" :: Text)
        Just (Entity userid user) -> do 
            insertedMessage <- runDB $ insertEntity (message { messageUserId = (Just userid), messageChannelId = (Just channelId), messageUsername = (Just (userIdent user)) })
            returnJson insertedMessage

getMessageR :: ChannelId -> Handler Value
getMessageR channelId = do
    allMessages <- runDB $ selectList [MessageChannelId ==. (Just channelId)] [Asc MessageId]
    returnJson allMessages