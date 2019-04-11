import React from 'react';
import Response from "../yosk/response";
import Logs from "../yosk/logs";
import MemoryProfiler from "../yosk/memory-profiler";
import Queries from "../yosk/queries";
import { Tabs } from 'antd';
import './result.css';

const TabPane = Tabs.TabPane;

class Results extends React.Component {
    render() {
        return (
            <div className="Result" >
                <Tabs defaultActiveKey="1" tabPosition={'left'}>
                    <TabPane tab="Logs" key="1"><Logs/></TabPane>
                    <TabPane tab="Queries" key="2"><Queries /></TabPane>
                    <TabPane tab="Response" key="3"><Response/></TabPane>
                    <TabPane tab="Memory Profiler" key="4"><MemoryProfiler /></TabPane>
                </Tabs>
            </div>
        )
    }
}

export default Results;
