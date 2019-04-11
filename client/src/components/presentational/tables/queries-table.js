import React from 'react';
import { Table } from 'antd';

import BareHighlight from 'react-fast-highlight/lib/BareHighlight';
import hljs from 'highlight.js/lib/highlight';
hljs.registerLanguage('sql', require('highlight.js/lib/languages/sql'));

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
                    <pre style={{whiteSpace: 'pre-line', fontFamily: "'Inconsolata', monospace", fontSize: 14}}>
                        <BareHighlight highlightjs={hljs} languages={['sql']} >
                            {query}
                        </BareHighlight>
                    </pre>
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
