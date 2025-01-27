@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity Performance'
define root view entity ZBS_R_DMOPerformance
  as select from ZBS_B_DMOPerformance
{
  key Identifier,
      ItemDescription,
      RandomDescription,
      Amount,
      Currency,
      BlobObject,
      NewDate,
      NewTime,
      UTCTimestamp
}
