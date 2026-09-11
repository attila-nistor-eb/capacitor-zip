import { WebPlugin } from '@capacitor/core';
import type { CapacitorZipPlugin, UnzipOptions, ZipOptions } from './definitions';
export declare class CapacitorZipWeb extends WebPlugin implements CapacitorZipPlugin {
    zip(_options: ZipOptions): Promise<void>;
    unzip(options: UnzipOptions): Promise<void>;
    getPluginVersion(): Promise<{
        version: string;
    }>;
}
