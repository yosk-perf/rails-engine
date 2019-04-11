import React from 'react';
import {inject, observer} from 'mobx-react';
import {Skeleton} from 'antd';
import MonacoEditor from 'react-monaco-editor';

@inject('yosksStore')
@observer
class Response extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;
        const response = yosk.response;

        return response ?
            <>
                <MonacoEditor
                    width="100%"
                    style={{minHeight: '700px'}}
                    language="json"
                    theme="vs-light"
                    options={{formatOnPaste: true, formatOnType: true, readOnly: true, automaticLayout: true}}
                    value={JSON.stringify(response, null, '\t')}
                />
            </>
            : <Skeleton active={true}/>
    }
}

export default Response;
