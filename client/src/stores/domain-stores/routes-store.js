import { observable, action, computed} from "mobx"
import Route from "../domain-objects/route";
import RoutesService from "../../services/routes_service";
import {configure} from "mobx/lib/mobx";

configure({enforceActions: "always"});

export default class RoutesStore {
    @observable routes = []
    @observable isLoading = true;

    async init() {
        if (!this.routes.length) {
            const response = await RoutesService.get();
            response.data.forEach(this.addRoute);
            this.setLoaded();
        }
    }

    @action
    setLoaded() {
        this.isLoading = false;
    }

    @action
    addRoute = (route) => {
        const newRoute = new Route(route);
        this.routes.push(newRoute);
    }

    @computed
    get getRoutes() {
        return this.routes;
    }
}
