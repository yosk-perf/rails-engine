import React from 'react';
import {inject, observer} from "mobx-react/index";
import yoskLogo from './yosk-logo.png';
import { Layout, Row, Col } from 'antd';

const { Footer } = Layout;

@inject('yosksStore')
@observer
class NavBar extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;

        return (
            <Footer>
                <Row>
                    <Col span={2}>
                        <img src={yoskLogo} alt="YOSKKKK" style={{width: '60px', height: '60px'}} />
                    </Col>
                    {
                        yosk ?
                            <>
                                <Col span={10}>
                                    <div>
                                        <h2 style={{marginTop: '15px'}}>{yosk.request ? `${yosk.request.controller}#${yosk.request.action}` : null}</h2>
                                    </div>
                                </Col>
                                <Col span={12}>
                                    <h2 style={{float: 'right', marginTop: '15px'}}>
                                        User Id: {yosk.request ? yosk.request.userId : null} {yosk.details ?
                                        `| Execution Time: ${yosk.details.totalDuration.toFixed(2)}ms` : null}</h2>
                                </Col>
                            </>
                        : null
                    }
                </Row>
            </Footer>
        );
    }
}

export default NavBar;
