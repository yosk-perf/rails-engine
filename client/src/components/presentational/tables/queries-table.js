import React from 'react';
import { Table } from 'antd';
import Hightlight from 'react-highlight.js';

const columns = [
    {
        title: 'Duration',
        dataIndex: 'duration',
        key: 'duration',
        sorter: (a, b) => (a.duration - b.duration),
        sortDirections: ['descend', 'ascend'],
        render: duration => `${duration.toFixed(2)}ms`
    },
    {
        title: 'Query',
        dataIndex: 'query',
        key: 'query',
        render: query => {
            return (
                <div>
                    <Hightlight language="SQL">
                        <pre style={{whiteSpace: 'pre-line', fontFamily: "'Inconsolata', monospace", fontSize: 14}}>
                            {query}
                        </pre>
                    </Hightlight>
                </div>
            )
        }
    }
];

const QueriesTable = ({data}) => {
    return (
        <Table rowKey={record => `${record.name}-${Date.now()}`} columns={columns} dataSource={data} pagination={false}/>
    );
};

export default QueriesTable;
