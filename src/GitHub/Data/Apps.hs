module GitHub.Data.Apps where

import GitHub.Data.Definitions (SimpleOwner)
import GitHub.Data.Id          (Id)
import GitHub.Data.Name        (Name)
import GitHub.Data.URL         (URL)
import GitHub.Internal.Prelude
import Prelude                 ()

data App = App
    { appId          :: !(Id App)
    , appOwner       :: !SimpleOwner
    , appName        :: !(Name App)
    , appDescription :: !(Maybe Text)
    , appExternalUrl :: !URL
    , appHtmlUrl     :: !URL
    , appCreatedAt   :: !UTCTime
    , appUpdatedAt   :: !UTCTime
    }
    deriving (Show, Data, Eq, Ord, Generic)

instance NFData App
instance Binary App

data Installation = Installation
    deriving (Show, Data, Eq, Ord, Generic)

instance NFData Installation
instance Binary Installation

data AccessToken = AccessToken
    { accessTokenToken      :: !Text
    , accessTokenExpiration :: !UTCTime
    }
    deriving (Show, Data, Eq, Ord, Generic)

instance NFData AccessToken
instance Binary AccessToken

instance FromJSON App where
  parseJSON = withObject "App" $ \o -> App
      <$> o .:  "id"
      <*> o .:  "owner"
      <*> o .:  "name"
      <*> o .:? "description"
      <*> o .:  "external_url"
      <*> o .:  "html_url"
      <*> o .:  "created_at"
      <*> o .:  "updated_at"

instance FromJSON AccessToken where
  parseJSON = withObject "AccessToken" $ \o -> AccessToken
      <$> o .: "token"
      <*> o .: "expires_at"
