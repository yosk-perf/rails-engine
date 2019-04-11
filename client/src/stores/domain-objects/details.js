export default class Details {
    totalDuration;
    instrumentation;
    allocationsCount;

    constructor(details) {
        this.totalDuration = details.total_duration;
        this.instrumentation = details.instrumentation;
        this.allocationsCount = details.allocations_count;
    }
}
