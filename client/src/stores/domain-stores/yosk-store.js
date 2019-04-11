import { observable, action, computed} from "mobx"
import Yosk from "../domain-objects/yosk";
import YoskService from "../../services/yosk_service";
import {routes} from '../ui-stores/router-store';
import {configure} from "mobx/lib/mobx";

configure({enforceActions: "always"});

export default class YoskStore {
    rootStore;
    @observable yosk;

    constructor(rootStore) {
        this.rootStore = rootStore;
    }

    @action
    init() {
        this.yosk = null;
    }

    @action
    async execYosk(yoskRequest) {
        this.yosk = new Yosk();
        const resp = await YoskService.execute(yoskRequest);
        const executionId = resp.data.execution_id;
        this.rootStore.routerStore.router.navigate(`yosk/${executionId}`);
    }

    @action
    initYosk(executionId) {
        this.yosk = new Yosk({executionId});
    }
}
