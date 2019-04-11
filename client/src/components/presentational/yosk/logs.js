import React from 'react';
import {inject, observer} from 'mobx-react';
import {Skeleton} from 'antd';
import LogTable from "../tables/log-table";

@inject('yosksStore')
@observer
class Logs extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;
        const logs = yosk.logs;

        return logs !== null ?
            <LogTable data={logs}/>
            : <Skeleton active={true}/>
    }
}

export default Logs;
