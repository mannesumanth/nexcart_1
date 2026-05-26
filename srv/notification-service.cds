using { nexcart.db } from '../db/schema' ;


service NotificationService {

    entity Notifications      as projection on db.NOTIFICATIONS;
    entity EmailTemplates     as projection on db.EMAIL_TEMPLATES;
    entity SmsLogs            as projection on db.SMS_LOGS;
    entity PushNotifications  as projection on db.PUSH_NOTIFICATIONS;
}