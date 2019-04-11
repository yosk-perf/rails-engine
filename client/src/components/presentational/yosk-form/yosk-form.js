import React from 'react';
import {inject, observer} from 'mobx-react';
import {AutoComplete, InputNumber, Button, Skeleton} from 'antd';
import _debounce from 'lodash/debounce';
import { JsonEditor  } from 'jsoneditor-react';
import 'jsoneditor-react/es/editor.min.css';

const Option = AutoComplete.Option;

@inject('routesStore')
@inject('yosksStore')
@observer
class YoskForm extends React.Component {
state = {
    controllerResults: [],
    actionResults: [],
    selectedYosk: null,
    selectedAction: '',
    userId: null,
    params: '{}'
};

handleSearch = (value, type) => {
    const results = [];
    const array = type === 'routes' ? this.props.routesStore.routes : this.state.selectedYosk.actions;

    array.forEach(route => {
        let name = type === 'routes' ? route.controller : route;
        name = name.replace('_', ' ');

        if (name.toLowerCase().includes(value.toLowerCase()) && results.length < 10) {
            results.push(route);
        }
    });

    return results;
};

onSelect = (value) => {
    this.setState({selectedYosk: this.state.controllerResults[value]});
};

onSelectAction = (value) => {
    this.setState({selectedAction: this.state.actionResults[value]});
};

createYosk = () => {
    this.props.yosksStore.execYosk({
        request_controller: this.state.selectedYosk.controller,
        request_action: this.state.selectedAction,
        user_id: this.state.userId,
        params: this.state.params
    });
};

onControllerSearch = (value) => {
    const results = this.handleSearch(value, 'routes');
    this.setState({controllerResults: results});
};


render() {
    const {isLoading} = this.props.routesStore;

    return isLoading ? <Skeleton active={true}/> : (
        <>
            <div className="input-padding">
                <AutoComplete
                    style={{width: '100%'}}
                    placeholder="Select Controller"
                    onSearch={_debounce(this.onControllerSearch, 300)}
                    onSelect={this.onSelect}
                >
                    {this.state.controllerResults.map((route, i) => <Option key={i}>{route.controller}</Option>)}
                </AutoComplete>
            </div>
            <div className="input-padding">
                <AutoComplete
                    disabled={!this.state.selectedYosk}
                    style={{width: '100%'}}
                    placeholder="Select Action"
                    onSearch={(value) => {
                        const results = this.handleSearch(value, 'actions');
                        this.setState({actionResults: results});
                    }}
                    onSelect={this.onSelectAction}
                >
                    {this.state.selectedYosk ? this.state.actionResults.map((action, i) => <Option
                        key={i}>{action}</Option>) : null}
                </AutoComplete>
            </div>
            <div className="input-padding">
                <InputNumber placeholder={"User Id"} onChange={(value) => {
                    this.setState({userId: value})
                }} value={this.state.userId}/>
            </div>
            <div className="input-padding"
                    style={{maxWidth: "1400px", maxHeight: "100%", border: "1px solid #e3e3e3", borderRadius: "5px"}}>
                    <JsonEditor
                        value={this.state.params}
                        onChange={(newValue) => {this.setState({params: newValue})}}
                        mode={'code'}
                    />
                </div>
                <div className="input-padding">
                    <Button style={{width: '100%'}} onClick={this.createYosk}>Send</Button>
                </div>
            </>

        );
    }
}

export default YoskForm;
