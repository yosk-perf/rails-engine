export default class GlobalConfig {
    static get API_URL() {
        if (process.env.NODE_ENV === 'development') {
            return 'http://localhost:3000/yosk';
        }
        if (process.env.NODE_ENV === 'production') {
            return '/yosk';
        }

        return '';
    }

    static get ROUTER_CONFIG () {
        return {
            USE_HASH: false,
            HASH: null,
            ROOT: ''
        };
    }
}
