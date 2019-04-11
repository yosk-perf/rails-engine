export default class Request {
    controller;
    action;
    userId;
    params;

    constructor(requestData) {
        this.controller = requestData.controller;
        this.action = requestData.action;
        this.userId = requestData.user_id;
        this.params = requestData.params;
    }
}
