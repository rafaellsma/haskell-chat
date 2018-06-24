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
        Just (Entity userid _) -> do 
            insertedMessage <- runDB $ insertEntity (message { messageUserId = (Just userid), messageChannelId = (Just channelId) })
            returnJson insertedMessage
   