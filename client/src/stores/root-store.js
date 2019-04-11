import YosksStore from './domain-stores/yosk-store';
import RoutesStore from "./domain-stores/routes-store";
import RoutersStore from "./ui-stores/router-store";

class RootStore {
    constructor() {
        this.yosksStore = new YosksStore(this);
        this.routesStore = new RoutesStore(this);
        this.routerStore = new RoutersStore(this);
        console.log(this, 'mobx store inited!');
    }
}


export default new RootStore();
