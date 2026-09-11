import { registerPlugin } from '@capacitor/core';
const CapacitorZip = registerPlugin('CapacitorZip', {
    web: () => import('./web').then((m) => new m.CapacitorZipWeb()),
});
export * from './definitions';
export { CapacitorZip };
//# sourceMappingURL=index.js.map