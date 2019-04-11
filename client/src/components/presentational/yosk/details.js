import React from 'react';
import {inject, observer} from 'mobx-react';
import {Skeleton} from 'antd';
import CustomCard from "../custom-card/custom-card";

@inject('yosksStore')
@observer
class Details extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;
        const details = yosk.details;

        return (
            <CustomCard>
                {details ?
                    <div>
                        <div>{details.totalDuration}</div>
                        {details.instrumentation ?
                            <div>
                                Duration :{details.instrumentation.panko_array_serializer_duration}
                                redis: {details.instrumentation.redis_call_duration}
                            </div>
                            : null}
                        <div>{details.allocationsCount}</div>
                    </div>
                    : <Skeleton active={true} />}
            </CustomCard>
        )
    }
}

export default Details;
