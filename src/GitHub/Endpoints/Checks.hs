-- |
-- The checks API as described on <https://docs.github.com/en/rest/checks>.

module GitHub.Endpoints.Checks (
    createCheckRunR,
    updateCheckRunR,
    module GitHub.Data,
    ) where

import GitHub.Data
import GitHub.Internal.Prelude
import Prelude ()

-- | Create a check run.
-- <https://docs.github.com/en/rest/checks/runs#create-a-check-run>
createCheckRunR :: Name Owner -> Name Repo -> NewCheckRun -> Request 'RW CheckRun
createCheckRunR owner repo =
    command Post ["repos", toPathPart owner, toPathPart repo, "check-runs"] . encode

-- | Update a check run.
-- <https://docs.github.com/en/rest/checks/runs#update-a-check-run>
updateCheckRunR :: Name Owner -> Name Repo -> Id CheckRun -> UpdateCheckRun -> Request 'RW CheckRun
updateCheckRunR owner repo crid =
    command Patch ["repos", toPathPart owner, toPathPart repo, "check-runs", toPathPart crid] . encode
