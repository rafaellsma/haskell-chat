{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Channel where

import Import

postChannelR :: Handler Value
postChannelR = do
    channel <- (requireJsonBody :: Handler Channel)
    insertedChannel <- runDB $ insertEntity channel
    returnJson insertedChannel