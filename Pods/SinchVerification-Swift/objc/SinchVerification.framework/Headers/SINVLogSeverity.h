/*
 * Copyright (c) 2016 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#ifndef SINV_LOG_SEVERITY_H
#define SINV_LOG_SEVERITY_H

#ifndef SINV_LOG_SEVERITY_
#define SINV_LOG_SEVERITY_
typedef NS_ENUM(NSInteger, SINVLogSeverity) {
  SINVLogSeverityTrace = 0,
  SINVLogSeverityInfo,
  SINVLogSeverityWarning,
  SINVLogSeverityCritical
};
#endif  // SINV_LOG_SEVERITY_

#endif  // SINV_LOG_SEVERITY_H
