pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: rood

    NotificationServer {
        bodyHyperlinksSupported: true
        imageSupported: true
        bodyImagesSupported: true
        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        persistenceSupported: true
        inlineReplySupported: true
        onNotification: notif => {
            notif.tracked = true;
        }
    }
}
