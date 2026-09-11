import { WebPlugin } from '@capacitor/core';
import JSZip from 'jszip';
export class CapacitorZipWeb extends WebPlugin {
    async zip(_options) {
        throw new Error('Zip functionality is not supported on the web platform. Use the File System API or a server-side solution.');
    }
    async unzip(options) {
        try {
            // Fetch the zip file
            const response = await fetch(options.source);
            const arrayBuffer = await response.arrayBuffer();
            // Load zip with password if provided
            const zip = await JSZip.loadAsync(arrayBuffer, {
                decodeFileName: (bytes) => {
                    return new TextDecoder('utf-8').decode(bytes);
                },
            });
            // Extract all files by triggering downloads
            const promises = Object.keys(zip.files).map(async (filename) => {
                const file = zip.files[filename];
                if (!file.dir) {
                    const blob = await file.async('blob');
                    const url = URL.createObjectURL(blob);
                    // Create download for each file
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = filename;
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    URL.revokeObjectURL(url);
                }
            });
            await Promise.all(promises);
        }
        catch (error) {
            throw new Error(`Failed to unzip: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async getPluginVersion() {
        return { version: '7.0.0' };
    }
}
//# sourceMappingURL=web.js.map