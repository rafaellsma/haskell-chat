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
    case channelPassword channel of
        Nothing -> do
            muser <- maybeAuth
            defaultLayout $ do
                setTitle "Chat Monstro"
                $(widgetFile "chat")
        Just password -> do
            passwordMaybe <- lookupGetParam "p"
            case passwordMaybe of
                Nothing -> do 
                    redirect HomeR
                Just p ->
                    if p == password then
                        do
                            muser <- maybeAuth
                            defaultLayout $ do
                                setTitle "Chat Monstro"
                                $(widgetFile "chat")
                        else
                            redirect HomeR
            

postValidatePasswordR :: Handler Value
postValidatePasswordR = do
    validatechannel <- requireJsonBody :: (Handler ValidatePasswordChannel)
    channel <- runDB $ get404 (validatePasswordChannelChannelId validatechannel)
    case (channelPassword channel) of
        Nothing -> sendResponseStatus status200 ("OK"::Text)
        Just password ->
            if password == (validatePasswordChannelPassword validatechannel) then
                sendResponseStatus status200 ("OK"::Text)
                else
                    sendResponseStatus status403 ("UNAUTHORIZED"::Text)
    

