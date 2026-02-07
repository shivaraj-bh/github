-- |
-- The apps API as described on <https://docs.github.com/en/rest/apps>.

module GitHub.Endpoints.Apps (
    createAccessTokenR,
    module GitHub.Data,
    ) where

import GitHub.Data
import GitHub.Internal.Prelude
import Prelude ()

-- | Create an installation access token for an app
-- See <https://developer.github.com/v3/apps/#create-a-new-installation-token>
createAccessTokenR :: Id Installation -> Request 'RW AccessToken
createAccessTokenR installation =
    command Post ["app", "installations", toPathPart installation, "access_tokens"] mempty

