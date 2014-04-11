#MaaSAlerts Changelog

##1.3.0 (Friday, April 11, 2014)
 * Renamed MaaSAlerts to PWAlerts
 * Added PWAlertSegment class which allows easy management of segment subscriptions
 * Moved subscription management state into the PWAlerts SDK leveraging PWAlertSegment -- see documentation for more details
 * Added support for nested alert segments
 * Added new method: `getAlertSegmentsWithSuccess:failure:`
 * Deprecated method: `getSubscriptionGroupsWithSuccess:failure:`
 * Added new method: `updateAlertSegments:success:failure:`
 * Deprecated method: `subscribeToGroupsWithIDs:success:failure:`

##1.2.1 (Wednesday, March 26th, 2014)
 * Adding arm64 support

##1.2.0 (Monday, December 23rd, 2013)
 * Added support for custom alerts (direct, location based, etc)
 * Added new object to encapsulate a notification, PWAlert
 * Added new method: `getExtraInformationForAlert:success:failure`
 * Deprecated `getExtraInformationForPushID:success:failure`

##1.1.1 (Friday, November 8th, 2013)
 * Re-enabled alerts registration with MaaS on application launch

##1.1.0 (Thursday, November 7th, 2013)
 * Updated MaaSAlerts to support registration on subscription group update
 * Now only triggering an alerts registration event when the device token changes
 * Network optimizations & bug fixes

##1.0.0 (Friday, June 30th, 2013)
 * Initial release