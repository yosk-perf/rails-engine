import axios from 'axios';
import GlobalConfig from '../config/global-config';

const ROUTE_NAME = 'routes';

export default class RoutesService {
    static get() {
        return axios.get(`${GlobalConfig.API_URL}/${ROUTE_NAME}`);
    }
}
