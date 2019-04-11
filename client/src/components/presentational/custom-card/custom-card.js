import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';

import './custom-card.css';

const CustomCard = ({title, loading = false, cardClass, children}) => {
    const mergedStyle = cardClass ? classNames('CustomCard', cardClass) : 'CustomCard';
    return (
        <div className={mergedStyle}>
            {
                title ?
                    <div>
                        <p className="Title">{title}</p>
                    </div>
                    : <React.Fragment/>
            }

            <div>
                {children}
            </div>
        </div>
    )
};

CustomCard.propTypes = {
    title: PropTypes.string,
    loading: PropTypes.bool,
    cardClass: PropTypes.string,
    children: PropTypes.any
};

export default CustomCard;
