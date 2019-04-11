import axios from 'axios';
import GlobalConfig from '../config/global-config';

export default class YoskService {
    static execute(yoskData) {
        return axios.post(`${GlobalConfig.API_URL}/execution`, yoskData);
    }

    static getExecutionStatus(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/status`);
    }

    static getDetails(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/details`);
    }

    static getResponse(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/response`);
    }

    static getlogs(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/logs`);
    }

    static getMemoryProfiler(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/memory_profiler`);
    }

    static getQueries(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/sql_queries`);
    }

    static getRequest(executionId) {
        return axios.get(`${GlobalConfig.API_URL}/execution/${executionId}/request`);
    }
}
