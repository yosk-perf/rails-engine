import React from 'react';
import Navigo from 'navigo';
import globalConfig from '../../config/global-config';

export default class RoutersStore {
    router;
    rootStore;

    constructor(rootStore) {
        this.rootStore = rootStore;
        this.router = new Navigo(globalConfig.ROUTER_CONFIG.ROOT, globalConfig.ROUTER_CONFIG.USE_HASH, globalConfig.ROUTER_CONFIG.HASH);
        this.router
            .on('yosk', () => {
                this.rootStore.yosksStore.init();
                this.rootStore.routesStore.init();
            })
            .on('yosk/:id', (params) => {
                const executionId = params.id;
                this.rootStore.yosksStore.initYosk(executionId);
            })
            .notFound(() => {
                document.location.href = 'yosk';
            })
            .resolve();
    }
}
