export default class Log {
    timestamp;
    logLevel;
    messagePayload;

    constructor(log) {
        this.timestamp = log.timestamp;
        this.logLevel = log.logLevel;
        this.messagePayload = log.messagePayload;
    }
}
