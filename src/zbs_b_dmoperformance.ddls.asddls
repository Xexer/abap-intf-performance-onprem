@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base View Performance Data'
define view entity ZBS_B_DMOPerformance
  as select from zbs_dmo_perf
{
  key identifier       as Identifier,
      item_description as ItemDescription,
      description      as RandomDescription,
      @Semantics.amount.currencyCode: 'Currency'
      amount           as Amount,
      currency         as Currency,
      blob             as BlobObject,
      ndate            as NewDate,
      ntime            as NewTime,
      utc              as UTCTimestamp
}
