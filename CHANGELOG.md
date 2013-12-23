#MaaSAlerts Changelog

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