import React from 'react';
import {inject, observer} from 'mobx-react';
import {Skeleton} from 'antd';

import { JsonEditor  } from 'jsoneditor-react';
import 'jsoneditor-react/es/editor.min.css';

@inject('yosksStore')
@observer
class Response extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;
        const response = yosk.response;

        return response ?
            <>
                <JsonEditor
                    value={response.json}
                    mode={'view'}
                />
            </>
            : <Skeleton active={true}/>
    }
}

export default Response;
