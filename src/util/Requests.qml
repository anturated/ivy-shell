pragma Singleton

import Quickshell

Singleton {
    id: root

    function get(url: string, callback: var): void {
        const xhr = new XMLHttpRequest();

        const cleanup = () => {
            xhr.abort();
            xhr.onreadystatechange = null;
            xhr.onerror = null;
        };

        xhr.open("GET", url, true);
        xhr.onreadystatechange = () => {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200)
                    callback(xhr.responseText);
                else
                    console.warn(`Request ${url} failed (${xhr.status})`);
                cleanup();
            }
        };
        xhr.onerror = () => {
            console.warn(`Request error (${url})`);
            cleanup();
        };

        xhr.send();
    }
}
