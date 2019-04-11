import React from 'react';
import {inject, observer} from 'mobx-react';
import CustomCard from "../presentational/custom-card/custom-card";
import YoskForm from "../presentational/yosk-form/yosk-form";
import Results from "../presentational/results/results";

import '../presentational/yosk-form/yosk-form.css';

@inject('yosksStore')
@observer
class YoskContainer extends React.Component {
    render() {
        const {yosk} = this.props.yosksStore;

        return (
            <>
                {!yosk ?
                    <CustomCard cardClass="Yosk-form">
                        <YoskForm/>
                    </CustomCard>
                    :
                    <Results/>}
            </>
        )
    }
}

export default YoskContainer;
