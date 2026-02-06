module GitHub.Data.Checks where

import GitHub.Data.Id          (Id)
import GitHub.Data.Name        (Name)
import GitHub.Data.URL         (URL)
import GitHub.Internal.Prelude
import Prelude                 ()

data CheckRun = CheckRun
    { checkRunId          :: !(Id CheckRun)
    , checkRunHeadSha     :: !Text
    , checkRunNodeId      :: !Text
    , checkRunExternalId  :: !(Maybe Text)
    , checkRunUrl         :: !URL
    , checkRunHtmlUrl     :: !URL
    , checkRunDetailsUrl  :: !(Maybe URL)
    , checkRunStatus      :: !CheckRunStatus
    , checkRunConclusion  :: !(Maybe CheckRunConclusion)
    , checkRunStartedAt   :: !(Maybe UTCTime)
    , checkRunCompletedAt :: !(Maybe UTCTime)
    , checkRunName        :: !Text
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData CheckRun
instance Binary CheckRun

data NewCheckRun = NewCheckRun
    { newCheckRunName        :: !Text
    , newCheckRunHeadSha     :: !Text
    , newCheckRunDetailsUrl  :: !(Maybe Text)
    , newCheckRunExternalId  :: !(Maybe Text)
    , newCheckRunStatus      :: !(Maybe CheckRunStatus)
    , newCheckRunStartedAt   :: !(Maybe UTCTime)
    , newCheckRunConclusion  :: !(Maybe CheckRunConclusion)
    , newCheckRunCompletedAt :: !(Maybe UTCTime)
    , newCheckRunOutput      :: !(Maybe CheckRunOutput)
    , newCheckRunActions     :: !(Maybe (Vector CheckRunAction))
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData NewCheckRun
instance Binary NewCheckRun

data UpdateCheckRun = UpdateCheckRun
    { updateCheckRunName        :: !(Maybe Text)
    , updateCheckRunDetailsUrl  :: !(Maybe Text)
    , updateCheckRunExternalId  :: !(Maybe Text)
    , updateCheckRunStatus      :: !(Maybe CheckRunStatus)
    , updateCheckRunStartedAt   :: !(Maybe UTCTime)
    , updateCheckRunConclusion  :: !(Maybe CheckRunConclusion)
    , updateCheckRunCompletedAt :: !(Maybe UTCTime)
    , updateCheckRunOutput      :: !(Maybe CheckRunOutput)
    , updateCheckRunActions     :: !(Maybe (Vector CheckRunAction))
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData UpdateCheckRun
instance Binary UpdateCheckRun

data CheckRunStatus
    = CheckRunQueued
    | CheckRunInProgress
    | CheckRunCompleted
    | CheckRunWaiting
    | CheckRunRequested
    | CheckRunPending
  deriving (Show, Data, Enum, Bounded, Eq, Ord, Generic)

instance NFData CheckRunStatus
instance Binary CheckRunStatus

data CheckRunConclusion
    = CheckRunActionRequired
    | CheckRunCancelled
    | CheckRunFailure
    | CheckRunNeutral
    | CheckRunSuccess
    | CheckRunSkipped
    | CheckRunStale
    | CheckRunTimedOut
  deriving (Show, Data, Enum, Bounded, Eq, Ord, Generic)

instance NFData CheckRunConclusion
instance Binary CheckRunConclusion

data CheckRunOutput = CheckRunOutput
    { checkRunOutputTitle       :: !Text
    , checkRunOutputSummary     :: !Text
    , checkRunOutputText        :: !(Maybe Text)
    , checkRunOutputAnnotations :: !(Maybe (Vector CheckRunAnnotation))
    , checkRunOutputImages      :: !(Maybe (Vector CheckRunImage))
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData CheckRunOutput
instance Binary CheckRunOutput

data AnnotationLevel
    = AnnotationNotice
    | AnnotationWarning
    | AnnotationFailure
  deriving (Show, Data, Enum, Bounded, Eq, Ord, Generic)

instance NFData AnnotationLevel
instance Binary AnnotationLevel

data CheckRunAnnotation = CheckRunAnnotation
    { checkRunAnnotationPath       :: !Text
    , checkRunAnnotationStartLine  :: !Int
    , checkRunAnnotationEndLine    :: !Int
    , checkRunAnnotationStartColumn :: !(Maybe Int)
    , checkRunAnnotationEndColumn   :: !(Maybe Int)
    , checkRunAnnotationLevel      :: !AnnotationLevel
    , checkRunAnnotationMessage    :: !Text
    , checkRunAnnotationTitle      :: !(Maybe Text)
    , checkRunAnnotationRawDetails :: !(Maybe Text)
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData CheckRunAnnotation
instance Binary CheckRunAnnotation

data CheckRunImage = CheckRunImage
    { checkRunImageAlt     :: !Text
    , checkRunImageUrl     :: !Text
    , checkRunImageCaption :: !(Maybe Text)
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData CheckRunImage
instance Binary CheckRunImage

data CheckRunAction = CheckRunAction
    { checkRunActionLabel       :: !Text
    -- ^ Button text (max 20 chars)
    , checkRunActionDescription :: !Text
    -- ^ Short description (max 40 chars)
    , checkRunActionIdentifier  :: !Text
    -- ^ Identifier sent back in webhook (max 20 chars)
    }
  deriving (Show, Data, Eq, Ord, Generic)

instance NFData CheckRunAction
instance Binary CheckRunAction

instance FromJSON CheckRun where
    parseJSON = withObject "CheckRun" $ \o -> CheckRun
        <$> o .: "id"
        <*> o .: "head_sha"
        <*> o .: "node_id"
        <*> o .:? "external_id"
        <*> o .: "url"
        <*> o .: "html_url"
        <*> o .:? "details_url"
        <*> o .: "status"
        <*> o .:? "conclusion"
        <*> o .:? "started_at"
        <*> o .:? "completed_at"
        <*> o .: "name"

instance FromJSON CheckRunStatus where
    parseJSON = withText "CheckRunStatus" $ \t -> case t of
        "queued"      -> pure CheckRunQueued
        "in_progress" -> pure CheckRunInProgress
        "completed"   -> pure CheckRunCompleted
        "waiting"     -> pure CheckRunWaiting
        "requested"   -> pure CheckRunRequested
        "pending"     -> pure CheckRunPending
        _             -> fail $ "Unknown CheckRunStatus: " <> unpack t

instance ToJSON CheckRunStatus where
    toJSON CheckRunQueued     = "queued"
    toJSON CheckRunInProgress = "in_progress"
    toJSON CheckRunCompleted  = "completed"
    toJSON CheckRunWaiting    = "waiting"
    toJSON CheckRunRequested  = "requested"
    toJSON CheckRunPending    = "pending"

instance FromJSON CheckRunConclusion where
    parseJSON = withText "CheckRunConclusion" $ \t -> case t of
        "action_required" -> pure CheckRunActionRequired
        "cancelled"       -> pure CheckRunCancelled
        "failure"         -> pure CheckRunFailure
        "neutral"         -> pure CheckRunNeutral
        "success"         -> pure CheckRunSuccess
        "skipped"         -> pure CheckRunSkipped
        "stale"           -> pure CheckRunStale
        "timed_out"       -> pure CheckRunTimedOut
        _                 -> fail $ "Unknown CheckRunConclusion: " <> unpack t

instance ToJSON CheckRunConclusion where
    toJSON CheckRunActionRequired = "action_required"
    toJSON CheckRunCancelled      = "cancelled"
    toJSON CheckRunFailure        = "failure"
    toJSON CheckRunNeutral        = "neutral"
    toJSON CheckRunSuccess        = "success"
    toJSON CheckRunSkipped        = "skipped"
    toJSON CheckRunStale          = "stale"
    toJSON CheckRunTimedOut       = "timed_out"

instance FromJSON AnnotationLevel where
    parseJSON = withText "AnnotationLevel" $ \t -> case t of
        "notice"  -> pure AnnotationNotice
        "warning" -> pure AnnotationWarning
        "failure" -> pure AnnotationFailure
        _         -> fail $ "Unknown AnnotationLevel: " <> unpack t

instance ToJSON AnnotationLevel where
    toJSON AnnotationNotice  = "notice"
    toJSON AnnotationWarning = "warning"
    toJSON AnnotationFailure = "failure"

instance ToJSON NewCheckRun where
    toJSON (NewCheckRun name sha url eid status started concl completed out acts) =
        object $ filter notNull
            [ "name"         .= name
            , "head_sha"     .= sha
            , "details_url"  .= url
            , "external_id"  .= eid
            , "status"       .= status
            , "started_at"   .= started
            , "conclusion"   .= concl
            , "completed_at" .= completed
            , "output"       .= out
            , "actions"      .= acts
            ]
      where
        notNull (_, Null) = False
        notNull (_, _)    = True

instance ToJSON UpdateCheckRun where
    toJSON (UpdateCheckRun name url eid status started concl completed out acts) =
        object $ filter notNull
            [ "name"         .= name
            , "details_url"  .= url
            , "external_id"  .= eid
            , "status"       .= status
            , "started_at"   .= started
            , "conclusion"   .= concl
            , "completed_at" .= completed
            , "output"       .= out
            , "actions"      .= acts
            ]
      where
        notNull (_, Null) = False
        notNull (_, _)    = True

instance ToJSON CheckRunOutput where
    toJSON (CheckRunOutput title summary txt anns imgs) =
        object $ filter notNull
            [ "title"       .= title
            , "summary"     .= summary
            , "text"        .= txt
            , "annotations" .= anns
            , "images"      .= imgs
            ]
      where
        notNull (_, Null) = False
        notNull (_, _)    = True

instance ToJSON CheckRunAnnotation where
    toJSON (CheckRunAnnotation path sl el sc ec lvl msg title raw) =
        object $ filter notNull
            [ "path"             .= path
            , "start_line"       .= sl
            , "end_line"         .= el
            , "start_column"     .= sc
            , "end_column"       .= ec
            , "annotation_level" .= lvl
            , "message"          .= msg
            , "title"            .= title
            , "raw_details"      .= raw
            ]
      where
        notNull (_, Null) = False
        notNull (_, _)    = True

instance ToJSON CheckRunImage where
    toJSON (CheckRunImage alt url caption) =
        object $ filter notNull
            [ "alt"       .= alt
            , "image_url" .= url
            , "caption"   .= caption
            ]
      where
        notNull (_, Null) = False
        notNull (_, _)    = True

instance ToJSON CheckRunAction where
    toJSON (CheckRunAction label desc ident) = object
        [ "label"       .= label
        , "description" .= desc
        , "identifier"  .= ident
        ]
