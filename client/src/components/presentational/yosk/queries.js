import React from 'react';
import {inject, observer} from 'mobx-react';
import {Skeleton} from 'antd';
import QueriesTable from "../tables/queries-table";

@inject('yosksStore')
@observer
class Queries extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;
        const queries = yosk.queries;

        return queries !== null ?
            <div>
                {<QueriesTable data={queries}/>}
            </div>
            : <Skeleton active={true}/>
    }
}

export default Queries;
