export default class Query {
    query;
    name;
    duration;

    constructor(queryData) {
        this.query = queryData.query;
        this.name = queryData.name;
        this.duration = queryData.duration;
    }
}
