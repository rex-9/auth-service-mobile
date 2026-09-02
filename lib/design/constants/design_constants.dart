// lib/design/constants/design_constants.dart

/// Component sizes matching web tokens.
enum EComponentSize { xs, sm, md, lg, xl }

abstract final class ComponentSizes {
  static const String xs = 'xs';
  static const String sm = 'sm';
  static const String md = 'md';
  static const String lg = 'lg';
  static const String xl = 'xl';
}

/// Button variants matching web tokens.
enum EButtonVariant { primary, neon, secondary, tertiary, text, icon, google }

abstract final class ButtonVariants {
  static const String primary = 'primary';
  static const String neon = 'neon';
  static const String secondary = 'secondary';
  static const String tertiary = 'tertiary';
  static const String text = 'text';
  static const String icon = 'icon';
  static const String google = 'google';
}

/// Badge variants matching web tokens.
enum EBadgeVariant {
  defaultVariant,
  neon,
  primary,
  secondary,
  success,
  warning,
  error,
  info,
}

/// Aliases for backward and cross-layer compatibility.
typedef BadgeType = EBadgeVariant;
typedef BadgeVariant = EBadgeVariant;

abstract final class BadgeVariants {
  static const String defaultVariant = 'default';
  static const String neon = 'neon';
  static const String primary = 'primary';
  static const String secondary = 'secondary';
  static const String success = 'success';
  static const String warning = 'warning';
  static const String error = 'error';
  static const String info = 'info';
}

abstract final class BadgeStatuses {
  static const String active = 'active';
  static const String resolved = 'resolved';
  static const String success = 'success';
  static const String completed = 'completed';
  static const String paid = 'paid';
  static const String inProgress = 'in_progress';
  static const String pending = 'pending';
  static const String trialing = 'trialing';
  static const String warning = 'warning';
  static const String expired = 'expired';
  static const String revoked = 'revoked';
  static const String failed = 'failed';
  static const String closed = 'closed';
  static const String discarded = 'discarded';
  static const String error = 'error';
  static const String canceled = 'canceled';
  static const String pastDue = 'past_due';
  static const String newStatus = 'new';
  static const String info = 'info';
  static const String paused = 'paused';
}

abstract final class BadgePriorities {
  static const String critical = 'critical';
  static const String urgent = 'urgent';
  static const String high = 'high';
  static const String medium = 'medium';
  static const String normal = 'normal';
  static const String low = 'low';
}

abstract final class BadgeSeverities {
  static const String fatal = 'fatal';
  static const String error = 'error';
  static const String warn = 'warn';
  static const String warning = 'warning';
  static const String info = 'info';
}

abstract final class BadgeRoles {
  static const String superAdmin = 'super_admin';
  static const String admin = 'admin';
  static const String supportAdmin = 'support_admin';
  static const String feedbackAdmin = 'feedback_admin';
}

abstract final class BadgeCategories {
  static const String bug = 'bug';
  static const String featureRequest = 'feature_request';
  static const String improvement = 'improvement';
  static const String general = 'general';
}

/// Input & Form variants matching web tokens.
enum EInputVariant { defaultVariant, glass }

abstract final class InputVariants {
  static const String defaultVariant = 'default';
  static const String glass = 'glass';
}

/// Form container variants matching web tokens.
enum EFormVariant { defaultVariant, glass }

abstract final class FormVariants {
  static const String defaultVariant = 'default';
  static const String glass = 'glass';
}

/// Dialog variants matching web tokens.
enum EDialogVariant { defaultVariant, confirm, alert }

abstract final class DialogVariants {
  static const String defaultVariant = 'default';
  static const String confirm = 'confirm';
  static const String alert = 'alert';
}

/// Toast / Alert types matching web tokens.
enum EToastType { info, success, warning, error }

abstract final class ToastTypes {
  static const String info = 'info';
  static const String success = 'success';
  static const String warning = 'warning';
  static const String error = 'error';
}

/// Typography variants matching web tokens.
enum ETypographyVariant {
  h1,
  h2,
  h3,
  h4,
  bodyL,
  bodyM,
  bodyS,
  caption,
  button,
  link,
}

abstract final class TypographyVariants {
  static const String h1 = 'h1';
  static const String h2 = 'h2';
  static const String h3 = 'h3';
  static const String h4 = 'h4';
  static const String bodyL = 'body-l';
  static const String bodyM = 'body-m';
  static const String bodyS = 'body-s';
  static const String caption = 'caption';
  static const String button = 'button';
  static const String link = 'link';
}
