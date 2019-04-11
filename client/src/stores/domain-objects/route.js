export default class Route {
    controller;
    actions;

    constructor(route) {
        this.controller = route.controller;
        this.actions = route.actions;
    }
}
