pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: rood

    property alias server: serv

    NotificationServer {
        id: serv

        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true;
        }
    }
}
